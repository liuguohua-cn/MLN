/**
 * Created by MomoLuaNative.
 * Copyright (c) 2020, Momo Group. All rights reserved.
 *
 * This source code is licensed under the MIT.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */
package com.immomo.mmui.databinding.bean;

import java.util.List;
import java.util.Objects;

/**
 * Description:
 * Author: xuejingfei
 * E-mail: xue.jingfei@immomo.com
 * Date: 2020/8/6 下午4:43
 */
public class BindCell {
    private int row;
    private int section;

    private int bindHashCode;
    private List<String> properties;


    public static BindCell obtain(int section,int row,int bindHashCode,List<String> properties) {
        BindCell bindCell = new BindCell();
        bindCell.setSection(section);
        bindCell.setRow(row);
        bindCell.setBindHashCode(bindHashCode);
        bindCell.setProperties(properties);
        return bindCell;
    }

    public int getBindHashCode() {
        return bindHashCode;
    }

    public void setBindHashCode(int bindHashCode) {
        this.bindHashCode = bindHashCode;
    }


    public int getRow() {
        return row;
    }

    public void setRow(int row) {
        this.row = row;
    }

    public int getSection() {
        return section;
    }

    public void setSection(int section) {
        this.section = section;
    }

    public List<String> getProperties() {
        return properties;
    }

    public void setProperties(List<String> properties) {
        this.properties = properties;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        BindCell bindCell = (BindCell) o;
        return row == bindCell.row &&
                section == bindCell.section &&
                bindHashCode == bindCell.bindHashCode &&
                properties.size()==bindCell.properties.size() && properties.containsAll(bindCell.properties);
    }

    @Override
    public int hashCode() {
        return Objects.hash(row, section, bindHashCode, properties);
    }
}
