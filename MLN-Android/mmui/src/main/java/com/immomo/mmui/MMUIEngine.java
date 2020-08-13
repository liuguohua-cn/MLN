/**
  * Created by MomoLuaNative.
  * Copyright (c) 2020, Momo Group. All rights reserved.
  *
  * This source code is licensed under the MIT.
  * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
  */
package com.immomo.mmui;

import android.content.Context;

import com.immomo.mls.MLSEngine;
import com.immomo.mls.fun.lt.SINavigator;
import com.immomo.mls.adapter.ILoadLibAdapter;
import com.immomo.mls.adapter.impl.LoadLibAdapterImpl;
import com.immomo.mls.fun.lt.SISystem;
import com.immomo.mls.util.LogUtil;
import com.immomo.mls.utils.MainThreadExecutor;
import com.immomo.mls.wrapper.IJavaObjectGetter;
import com.immomo.mls.wrapper.ILuaValueGetter;
import com.immomo.mls.wrapper.Register;
import com.immomo.mls.wrapper.Translator;
import com.immomo.mmui.constants.CrossAxis;
import com.immomo.mmui.constants.FlexConstants;
import com.immomo.mmui.constants.MainAxis;
import com.immomo.mmui.constants.PositionType;
import com.immomo.mmui.constants.Wrap;
import com.immomo.mmui.databinding.LTCDataBinding;
import com.immomo.mmui.globals.UDLuaView;
import com.immomo.mmui.sbridge.SMMUI;
import com.immomo.mmui.ud.UDNodeGroup;
import com.immomo.mmui.ud.SIPageLink;
import com.immomo.mmui.ud.UDCanvasView;
import com.immomo.mmui.ud.UDColor;
import com.immomo.mmui.ud.UDEditText;
import com.immomo.mmui.ud.UDNodeView;
import com.immomo.mmui.ud.UDHStack;
import com.immomo.mmui.ud.UDImageButton;
import com.immomo.mmui.ud.UDImageView;
import com.immomo.mmui.ud.UDLabel;
import com.immomo.mmui.ud.UDSafeAreaRect;
import com.immomo.mmui.ud.UDScrollView;
import com.immomo.mmui.ud.UDSpacer;
import com.immomo.mmui.ud.UDStyleString;
import com.immomo.mmui.ud.UDSwitch;
import com.immomo.mmui.ud.UDTabLayout;
import com.immomo.mmui.ud.UDVStack;
import com.immomo.mmui.ud.UDView;
import com.immomo.mmui.ud.UDViewGroup;
import com.immomo.mmui.ud.UDViewPager;
import com.immomo.mmui.ud.anim.InteractiveBehavior;
import com.immomo.mmui.ud.anim.InteractiveDirection;
import com.immomo.mmui.ud.anim.InteractiveType;
import com.immomo.mmui.ud.anim.TouchType;
import com.immomo.mmui.ud.anim.UDAnimation;
import com.immomo.mmui.ud.anim.UDAnimatorSet;
import com.immomo.mmui.ud.anim.UDBaseAnimation;
import com.immomo.mmui.ud.constants.AnimProperty;
import com.immomo.mmui.ud.constants.Timing;
import com.immomo.mmui.ud.recycler.UDBaseNeedHeightAdapter;
import com.immomo.mmui.ud.recycler.UDBaseRecyclerAdapter;
import com.immomo.mmui.ud.recycler.UDBaseRecyclerLayout;
import com.immomo.mmui.ud.recycler.UDCollectionAdapter;
import com.immomo.mmui.ud.recycler.UDCollectionAutoFitAdapter;
import com.immomo.mmui.ud.recycler.UDCollectionLayout;
import com.immomo.mmui.ud.recycler.UDListAdapter;
import com.immomo.mmui.ud.recycler.UDListAutoFitAdapter;
import com.immomo.mmui.ud.recycler.UDRecyclerView;
import com.immomo.mmui.ud.recycler.UDWaterFallAdapter;
import com.immomo.mmui.ud.recycler.UDWaterFallLayout;
import com.immomo.mmui.ud.viewpager.UDViewPagerAdapter;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Xiong.Fangyu on 2020-05-27
 */
public class MMUIEngine {

    public static final String ANIMATOR_LIB = "libanimator";
    public static final String DATABIND_LIB = "mmuibridge";
    public static final String YOGA_LIB = "yoga";

    private static final Map<String, Boolean> otherLibs;
    private static boolean init = false;

    static {
        otherLibs = new HashMap<>(1);
        otherLibs.put(ANIMATOR_LIB, false);
        otherLibs.put(DATABIND_LIB, false);
        otherLibs.put(YOGA_LIB, false);
    }

    /// 单独实例，和luaview不冲突
    public static MMUIRegister singleRegister;

    static MMUIReloadButtonCreator reloadButtonCreator = new MMUIReloadButtonCreatorImpl();

    public static void init(Context context) {
        if (!MLSEngine.isInit())
            throw new Error("init mls engine first!");
        if (init)
            return;
        if (singleRegister == null) {
            synchronized (MMUIEngine.class) {
                if (singleRegister == null) {
                    singleRegister = new MMUIRegister();
                }
            }
        }

        initOtherLibs(LoadLibAdapterImpl.getInstance());

        registerMMUI(registerUD());
        registerMMUI(registerTools());
        registerMMUIEnum(registerConstants());
        registerStaticClass(registerStaticClass());
        registerCovert(registerCovertClass());
        registerSingleInstance(registerSingleInstance());
        registerNewStaticClass(registerNewStaticClass());

        MLSEngine.singleRegister.registerStaticBridge(SMMUI.LUA_CLASS_NAME, SMMUI.class);

        init = true;
    }



    /**
     * 初始化非核心库
     */
    private static void initOtherLibs(ILoadLibAdapter libAdapter) {
        Map<String, Boolean> temp = new HashMap<>(otherLibs);
        for (Map.Entry<String, Boolean> e : temp.entrySet()) {
            if (!e.getValue()) {
                otherLibs.put(e.getKey(), libAdapter.load(e.getKey()));
            }
        }
        if (MLSEngine.DEBUG) {
            LogUtil.d("mmui engine load libs:", otherLibs);
        }
    }

    public static boolean isLibInit(String libName) {
        Boolean init = otherLibs.get(libName);
        return init != null && init;
    }

    public static void registerMMUI(Register.UDHolder... mmuiHolders) {
        for (Register.UDHolder h : mmuiHolders) {
            singleRegister.registerUserdata(h);
        }
    }

    public static void registerMMUIEnum(Class... mmuiHolders) {
        for (Class h : mmuiHolders) {
            singleRegister.registerEnum(h);
        }
    }

    public static void registerStaticClass(Register.SHolder... siHolders) {
        for (Register.SHolder siHolder : siHolders) {
            singleRegister.registerStaticBridge(siHolder);
        }
    }

    private static void registerNewStaticClass(Register.NewStaticHolder... newStaticHolders) {
        for (Register.NewStaticHolder newStaticHolder : newStaticHolders) {
            singleRegister.registerNewStaticBridge(newStaticHolder);
        }
    }

    public static void registerSingleInstance(SIHolder... siHolders) {
        for (SIHolder siHolder : siHolders) {
            singleRegister.registerSingleInstance(siHolder.luaClassName, siHolder.clz);
        }
    }


    public static void registerCovert(CHolder... cHolders) {
        for (CHolder h : cHolders) {
            if (h.defaultL2J) {
                Translator.registerL2JAuto(h.clz);
            } else if (h.l2j != null) {
                Translator.registerL2J(h.clz, h.l2j);
            }
            if (h.defaultJ2L) {
                Translator.registerJ2LAuto(h.clz);
            } else if (h.j2l != null) {
                Translator.registerJ2L(h.clz, h.j2l);
            }
        }
    }

    public static void setReloadButtonCreator(MMUIReloadButtonCreator reloadButtonCreator) {
        MMUIEngine.reloadButtonCreator = reloadButtonCreator;
    }

    public static void preInit(final int num) {
        MainThreadExecutor.post(new Runnable() {
            @Override
            public void run() {
                if (PreGlobalInitUtils.hasPreInitSize() == 0)
                    PreGlobalInitUtils.initFewGlobals(num);
            }
        });
    }

    private static Register.UDHolder[] registerUD() {
        return new Register.UDHolder[]{
                Register.newUDHolder(UDView.LUA_CLASS_NAME, UDView.class, false, UDView.methods),
                Register.newUDHolder(UDNodeView.LUA_CLASS_NAME, UDNodeView.class, false, UDNodeView.methods),
                Register.newUDHolder(UDViewGroup.LUA_CLASS_NAME[0], UDViewGroup.class, false, UDViewGroup.methods),
                Register.newUDHolder(UDViewGroup.LUA_CLASS_NAME[1], UDViewGroup.class, false, UDViewGroup.methods),
                Register.newUDHolder(UDNodeGroup.LUA_CLASS_NAME, UDNodeGroup.class, false, UDNodeGroup.methods),
                Register.newUDHolder(UDLuaView.LUA_CLASS_NAME, UDLuaView.class, false, UDLuaView.methods),
                Register.newUDHolder(UDLabel.LUA_CLASS_NAME, UDLabel.class, false, UDLabel.methods),
                Register.newUDHolder(UDEditText.LUA_CLASS_NAME, UDEditText.class, false, UDEditText.methods),
                Register.newUDHolder(UDImageView.LUA_CLASS_NAME, UDImageView.class, false, UDImageView.methods),
                Register.newUDHolder(UDImageButton.LUA_CLASS_NAME, UDImageButton.class, false, UDImageButton.methods),
                Register.newUDHolder(UDScrollView.LUA_CLASS_NAME, UDScrollView.class, false, UDScrollView.methods),
                Register.newUDHolder(UDBaseRecyclerAdapter.LUA_CLASS_NAME, UDBaseRecyclerAdapter.class, false, UDBaseRecyclerAdapter.methods),
                Register.newUDHolder(UDBaseNeedHeightAdapter.LUA_CLASS_NAME, UDBaseNeedHeightAdapter.class, false, UDBaseNeedHeightAdapter.methods),
                Register.newUDHolder(UDBaseRecyclerLayout.LUA_CLASS_NAME, UDBaseRecyclerLayout.class, false, UDBaseRecyclerLayout.methods),
                Register.newUDHolder(UDRecyclerView.LUA_CLASS_NAME[0], UDRecyclerView.class, false, UDRecyclerView.methods),
                Register.newUDHolder(UDRecyclerView.LUA_CLASS_NAME[1], UDRecyclerView.class, false, UDRecyclerView.methods),
                Register.newUDHolder(UDRecyclerView.LUA_CLASS_NAME[2], UDRecyclerView.class, false, UDRecyclerView.methods),
                Register.newUDHolder(UDViewPager.LUA_CLASS_NAME, UDViewPager.class, false, UDViewPager.methods),
                Register.newUDHolder(UDTabLayout.LUA_CLASS_NAME, UDTabLayout.class, false, UDTabLayout.methods),
                Register.newUDHolder(UDSwitch.LUA_CLASS_NAME, UDSwitch.class, false, UDSwitch.methods),
                Register.newUDHolder(UDCanvasView.LUA_CLASS_NAME, UDCanvasView.class, false, UDCanvasView.methods),
                Register.newUDHolder(UDVStack.LUA_CLASS_NAME, UDVStack.class, false, UDVStack.methods),
                Register.newUDHolder(UDHStack.LUA_CLASS_NAME, UDHStack.class, false, UDHStack.methods),
                Register.newUDHolder(UDSpacer.LUA_CLASS_NAME, UDSpacer.class, false, UDSpacer.methods),

                Register.newUDHolder(UDListAdapter.LUA_CLASS_NAME, UDListAdapter.class, false, UDListAdapter.methods),
                Register.newUDHolder(UDListAutoFitAdapter.LUA_CLASS_NAME, UDListAutoFitAdapter.class, false),
                Register.newUDHolder(UDCollectionAdapter.LUA_CLASS_NAME, UDCollectionAdapter.class, false, UDCollectionAdapter.methods),
                Register.newUDHolder(UDCollectionAutoFitAdapter.LUA_CLASS_NAME, UDCollectionAutoFitAdapter.class, false, UDCollectionAutoFitAdapter.methods),
                Register.newUDHolder(UDCollectionLayout.LUA_CLASS_NAME, UDCollectionLayout.class, false, UDCollectionLayout.methods),
                Register.newUDHolder(UDWaterFallAdapter.LUA_CLASS_NAME, UDWaterFallAdapter.class, false, UDWaterFallAdapter.methods),
                Register.newUDHolder(UDWaterFallLayout.LUA_CLASS_NAME, UDWaterFallLayout.class, false, UDWaterFallLayout.methods),
                Register.newUDHolder(UDViewPagerAdapter.LUA_CLASS_NAME, UDViewPagerAdapter.class, false, UDViewPagerAdapter.methods),

                Register.newUDHolder(UDColor.LUA_CLASS_NAME, UDColor.class, false, UDColor.methods),
        };
    }

    private static Register.UDHolder[] registerTools() {
        return new Register.UDHolder[]{
                /// 两种方式生成udholder
                /// 第一种，类继承自LuaUserdata时，使用这种方式
                Register.newUDHolder(UDStyleString.LUA_CLASS_NAME, UDStyleString.class, false, UDStyleString.methods),
                Register.newUDHolder(UDSafeAreaRect.LUA_CLASS_NAME, UDSafeAreaRect.class, false, UDSafeAreaRect.methods),

                Register.newUDHolderWithLuaClass(UDBaseAnimation.LUA_CLASS_NAME, UDBaseAnimation.class, false),
                Register.newUDHolderWithLuaClass(UDAnimation.LUA_CLASS_NAME, UDAnimation.class, false),
                Register.newUDHolderWithLuaClass(UDAnimatorSet.LUA_CLASS_NAME, UDAnimatorSet.class, false),
        };
    }

    private static Class[] registerConstants() {
        return new Class[]{
                PositionType.class,
                MainAxis.class,
                CrossAxis.class,
                Wrap.class,
                FlexConstants.class,
                AnimProperty.class,
                Timing.class,
                InteractiveDirection.class,
                InteractiveType.class,
                TouchType.class
        };
    }


    private static Register.SHolder[] registerStaticClass() {
        return new Register.SHolder[] {
//            Register.newSHolderWithLuaClass(LTDataBinding.LUA_CLASS_NAME,LTDataBinding.class)
        };
    }
    private static Register.NewStaticHolder[] registerNewStaticClass() {
        return new Register.NewStaticHolder[] {
                new Register.NewStaticHolder(LTCDataBinding.LUA_CLASS_NAME, LTCDataBinding.class),
                new Register.NewStaticHolder(InteractiveBehavior.LUA_CLASS_NAME, InteractiveBehavior.class)
        };
    }


    public static CHolder[] registerCovertClass() {
        return new CHolder[]{
                new CHolder(UDColor.class, UDColor.J, null),
                new CHolder(UDBaseAnimation.class),
                new CHolder(UDAnimation.class),
                new CHolder(UDAnimatorSet.class),
        };
    }


    /**
     * 注册单例
     * @return
     */
    public static SIHolder[] registerSingleInstance() {
        return new SIHolder[]{
            new SIHolder(SISystem.KEY, SISystem.class),
            new SIHolder(SINavigator.LUA_CLASS_NAME, SINavigator.class),
            new SIHolder(SIPageLink.LUA_CLASS_NAME, SIPageLink.class)
        };
    }

    /**
     * 注册页面
     * @param linkHolders
     */
    public static void registerActivity(LinkHolder... linkHolders) {
        for(LinkHolder linkHolder: linkHolders) {
            MMUILinkRegister.register(linkHolder.linkKey,linkHolder.linkActivity);
        }
    }

    public static class LinkHolder {
        public String linkKey;
        public Class linkActivity;
        public LinkHolder(String linkKey, Class linkActivity) {
            this.linkKey = linkKey;
            this.linkActivity  = linkActivity;
        }
    }



    /**
     * 单例包裹类
     *
     * 每个虚拟机中只有一个实例，使用{@link #luaClassName}获取
     * 虚拟机销毁时，会调用相关类中__onLuaGc方法
     *
     * 和静态Bridge不同的是，单例有虚拟机状态，
     * 适用于需要获取状态的类中，或需要在虚拟机销毁时，释放资源的类中
     */
    public static class SIHolder {
        public String luaClassName;
        /**
         * 类中必须有{@link com.immomo.mls.annotation.LuaClass}注解
         */
        public Class clz;

        public SIHolder(String lcn, Class clz) {
            luaClassName = lcn;
            this.clz = clz;
        }
    }



    /**
     * 转换包裹类
     *
     * @see Translator#registerL2J(Class, IJavaObjectGetter)
     * @see Translator#registerJ2L(Class, ILuaValueGetter)
     * @see IJavaObjectGetter
     * @see ILuaValueGetter
     */
    public static class CHolder {
        Class clz;
        boolean defaultL2J;
        IJavaObjectGetter l2j;
        boolean defaultJ2L;
        ILuaValueGetter j2l;

        public CHolder(Class clz) {
            this.clz = clz;
            defaultL2J = true;
            defaultJ2L = true;
        }

        public CHolder(Class clz, IJavaObjectGetter l2j, ILuaValueGetter j2l) {
            this.clz = clz;
            this.j2l = j2l;
            this.l2j = l2j;
            defaultL2J = false;
            defaultJ2L = false;
        }
    }

}