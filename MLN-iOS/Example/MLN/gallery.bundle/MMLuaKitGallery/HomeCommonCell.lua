---
--- Generated by MLN Team (http://www.immomo.com)
--- Created by MLN Team.
--- DateTime: 2019-09-05 12:05
---

local _class = {
    _name = 'HomeCommonCell',
    _version = '1.0'
}

---@public
function _class:new()
    local o = {}
    setmetatable(o, { __index = self })
    return o
end

---@public
function _class:contentView()
    self:setupCellContentView()
    self:setupViewPagerForCell()
    self:setupDetailDescViewForCell()
    self:setupInteractionViewsForCell()
    return self.cellContentView
end

---更新关注按钮
---@public
function _class:updateFollowLabel(show, text)
    self.followLabel:hidden(not show)
    self.followLabel:text(text or "+关注")
end

---更新cell内容展示
---@param item Map 数据
---@public
function _class:updateCellContentWithItem(item)
    self.nameLabel:text(item:get("sellernick")) --名字
    self.avatarView:image(item:get("itempic")) --头像

    self.cellItems:insert(1, item:get("itempic")) --图片
    self.cellItems:insert(1, item:get("taobao_image")) --图片
    local count = self.cellItems:size()
    if count > 10 then
        --设置cell上的图片滑动展示数量最多10个
        self.cellItems:removeObjectsAtRange(10, count)
    end
    self.viewPager:reloadData()

    self.descLabel:text(item:get("itemdesc")) --简介
    self.detailImageView:image(item:get("itempic"))  --小图片
    self.detailSubTitleLabel:text(item:get("itemshorttitle")) --副标题
    self.detailCountLabel:text(string.format("%d篇内容>", item:get("couponmoney"))) --内容数量
    self.likeCountLabel:text(item:get("itemsale")) --点赞数量
    self.commentCountLabel:text(item:get("general_index")) --评论数量
end

---@private
function _class:setupCellContentView()
    local cellContentView = LinearLayout(LinearType.VERTICAL)
            :width(MeasurementType.MATCH_PARENT):height(MeasurementType.WRAP_CONTENT)
    self.cellContentView = cellContentView

    --layout
    local personInfoView = LinearLayout(LinearType.HORIZONTAL)
    personInfoView:width(MeasurementType.MATCH_PARENT):height(MeasurementType.WRAP_CONTENT)
            :marginTop(12):marginBottom(12):marginLeft(12):marginRight(12)
    cellContentView:addView(personInfoView)
    self.personInfoView = personInfoView

    --头像
    local avatarView = ImageView()
    avatarView:width(35):height(35):setGravity(Gravity.CENTER_VERTICAL)
              :addCornerMask(18,ColorConstants.White, RectCorner.ALL_CORNERS)
    avatarView:bgColor(ColorConstants.LightGray)--ok
    avatarView:contentMode(ContentMode.SCALE_ASPECT_FILL)
    personInfoView:addView(avatarView)
    self.avatarView = avatarView

    --名字
    local nameLabel = Label()
    nameLabel:height(MeasurementType.WRAP_CONTENT):width(MeasurementType.MATCH_PARENT):setGravity(Gravity.CENTER_VERTICAL):marginLeft(8)
    nameLabel:fontSize(14):textAlign(TextAlign.LEFT)
    personInfoView:addView(nameLabel)
    self.nameLabel = nameLabel

    --关注按钮
    local followLabel = Label()
    followLabel:priority(1):width(55):height(30)
               :cornerRadius(3):borderWidth(1):borderColor(Color(200, 200, 200))
    followLabel:text("+关注"):textAlign(TextAlign.CENTER):fontSize(13):textColor(ColorConstants.Black)
    followLabel:onClick(function()
        if self.followLabel:text() == "+关注" then
            self.followLabel:text("已关注")
        else
            self.followLabel:text("+关注")
        end
    end)
    self.followLabel = followLabel
    personInfoView:addView(followLabel)
end

---@private
function _class:setupViewPagerForCell()
    self.cellItems = Array()

    --配置cell图片数据
    self.adapter = ViewPagerAdapter()
    self.adapter:getCount(function(_)
        return self.cellItems:size()
    end)

    self.adapter:initCell(function(cell, _)
        cell.imageView = ImageView()
        cell.imageView:contentMode(ContentMode.SCALE_ASPECT_FIT)
        cell.imageView:height(MeasurementType.MATCH_PARENT):width(MeasurementType.MATCH_PARENT)
        cell.contentView:addView(cell.imageView)
    end)

    self.adapter:fillCellData(function(cell, row)
        local item = self.cellItems:get(row)
        cell.imageView:image(item)
    end)

    --让cell上的图片支持滑动
    self.viewPager = ViewPager()
:setPreRenderCount(1)
    self.viewPager:width(MeasurementType.MATCH_PARENT):height(350)
    self.viewPager:adapter(self.adapter)
    self.cellContentView:addView(self.viewPager)
end

---@private
function _class:setupDetailDescViewForCell()
    self.descLabel = Label()
    self.descLabel:marginLeft(10):marginRight(10):marginTop(10):height(MeasurementType.WRAP_CONTENT):width(MeasurementType.MATCH_PARENT)
    self.descLabel:fontSize(15):textAlign(TextAlign.LEFT):lines(3)
    self.cellContentView:addView(self.descLabel)

    local detailViewHeight = 50
    local detailLayout = LinearLayout(LinearType.HORIZONTAL):marginTop(10):marginLeft(10):marginRight(10):height(detailViewHeight):width(MeasurementType.MATCH_PARENT)
    detailLayout:addCornerMask(3,ColorConstants.White, RectCorner.ALL_CORNERS)
    detailLayout:bgColor(ColorConstants.LightGray)--OK
    detailLayout:onClick(function()
        Toast("灵感集里还有更多内容哦", 1)
    end)
    self.detailLayout = detailLayout

    local detailImageView = ImageView():width(detailViewHeight):height(detailViewHeight):setGravity(Gravity.CENTER_VERTICAL)
    detailImageView:contentMode(ContentMode.SCALE_ASPECT_FILL)
    self.detailImageView = detailImageView

    --布局label
    local labelLayout = LinearLayout(LinearType.VERTICAL):marginLeft(10):marginTop(10):width(MeasurementType.WRAP_CONTENT):height(MeasurementType.WRAP_CONTENT)
    self.labelLayout = labelLayout

    local detailTitleLabel = Label():height(MeasurementType.WRAP_CONTENT):width(MeasurementType.WRAP_CONTENT)
    detailTitleLabel:text("来自灵感集"):fontSize(12):textAlign(TextAlign.LEFT):lines(1)
    labelLayout:addView(detailTitleLabel)
    self.detailTitleLabel = detailTitleLabel

    --布局居右显示label
    local rightLayout = LinearLayout(LinearType.HORIZONTAL):width(MeasurementType.MATCH_PARENT):setGravity(Gravity.CENTER):marginRight(0)
    self.rightLayout = rightLayout

    local placeholderLayout = Label():height(26):width(MeasurementType.MATCH_PARENT):setGravity(Gravity.CENTER):marginLeft(0):marginRight(0)
    self.placeholderLayout = placeholderLayout
    rightLayout:addView(placeholderLayout)

    local detailCountLabelWidth = 85
    local detailCountLabel = Label():marginLeft(-detailCountLabelWidth):height(26):width(detailCountLabelWidth):setGravity(Gravity.CENTER)
    detailCountLabel:bgColor(Color(210, 210, 210, 1))--ok
    detailCountLabel:cornerRadius(detailCountLabel:height() / 2)
    detailCountLabel:fontSize(12):textAlign(TextAlign.CENTER):lines(1):textColor(ColorConstants.White)
    self.detailCountLabel = detailCountLabel
    rightLayout:addView(detailCountLabel)

    --副标题
    local detailSubTitleLabel = Label():marginTop(5):marginRight(detailCountLabel:width()):height(MeasurementType.WRAP_CONTENT):width(MeasurementType.WRAP_CONTENT)
    detailSubTitleLabel:fontSize(13):textAlign(TextAlign.LEFT):lines(1):setTextFontStyle(FontStyle.BOLD)
    labelLayout:addView(detailSubTitleLabel)
    self.detailSubTitleLabel = detailSubTitleLabel

    --添加显示
    detailLayout:addView(detailImageView)
    detailLayout:addView(labelLayout)
    detailLayout:addView(rightLayout)
    self.cellContentView:addView(detailLayout)
end

---@private
function _class:setupInteractionViewsForCell()
    local height = 50
    local interactionLayout = LinearLayout(LinearType.HORIZONTAL):marginTop(10):marginLeft(10):marginRight(10):height(height):width(MeasurementType.MATCH_PARENT)
    self.interactionLayout = interactionLayout
    self.cellContentView:addView(interactionLayout)

    --分享
    local shareView = ImageView():height(25):width(25):setGravity(Gravity.CENTER_VERTICAL)
    shareView:image("share")
    shareView:onClick(function()
        Toast("可分享到微信朋友圈哦")
    end)
    self.shareView = shareView
    interactionLayout:addView(shareView)

    --布局点赞、评论、收藏
    local buttonsLayout = LinearLayout(LinearType.HORIZONTAL):height(height):width(MeasurementType.MATCH_PARENT)
    self.buttonsLayout = buttonsLayout
    interactionLayout:addView(buttonsLayout)

    --收藏
    local collectButton = ImageView():marginLeft(-30):marginTop(-3):width(30):height(30):setGravity(Gravity.CENTER_VERTICAL)
    collectButton:image("https://s.momocdn.com/w/u/others/2019/08/31/1567258988643-collect.png")
    collectButton:onClick(function()
        self:handleClickCollectEvent()
    end)
    self.collectButton = collectButton
    interactionLayout:addView(collectButton)

    --评论数量
    local commentCountLabel = Label():marginLeft(-60):marginTop(-8):width(30):height(15):setGravity(Gravity.CENTER)
    commentCountLabel:fontSize(11):textColor(ColorConstants.LightBlack)
    commentCountLabel:text("5")
    self.commentCountLabel = commentCountLabel
    interactionLayout:addView(commentCountLabel)

    --评论
    local messageButton = ImageView():marginLeft(-60):width(25):height(25):setGravity(Gravity.CENTER_VERTICAL)
    messageButton:image("https://s.momocdn.com/w/u/others/2019/08/28/1566958902036-comment.png")
    messageButton:onClick(function()
        Toast("还没有评论，赶快抢个沙发吧")
    end)
    self.messageButton = messageButton
    interactionLayout:addView(messageButton)

    --点赞数量
    local likeCountLabel = Label():marginLeft(-60):marginTop(-8):width(35):height(15):setGravity(Gravity.CENTER)
    likeCountLabel:fontSize(11):textColor(ColorConstants.LightBlack)
    likeCountLabel:text("3")
    self.likeCountLabel = likeCountLabel
    interactionLayout:addView(likeCountLabel)

    --点赞
    local likeButton = ImageView():marginLeft(-65):width(30):height(25):setGravity(Gravity.CENTER_VERTICAL)
    likeButton:image("https://s.momocdn.com/w/u/others/2019/08/31/1567257871136-like.png")
    likeButton:onClick(function()
        self:handleClickLikeEvent()
    end)
    self.likeButton = likeButton
    interactionLayout:addView(likeButton)

    --分割线
    local line = View():width(MeasurementType.MATCH_PARENT):height(10)
    line:bgColor(ColorConstants.LightGray)--ok
    self.line = line
    self.cellContentView:addView(line)
end

---点赞事件
---@private
function _class:handleClickLikeEvent()
    if self.hasLiked then
        self.likeButton:image("https://s.momocdn.com/w/u/others/2019/08/31/1567257871136-like.png")
        self.likeCountLabel:text(string.format("%s", (self.likeCountLabel:text() - 1)))
        self.hasLiked = false
    else
        Toast("点赞成功，购物基金+1", 1)
        self.likeButton:image("https://s.momocdn.com/w/u/others/2019/08/31/1567257871172-liked.png")
        self.likeCountLabel:text(string.format("%s", (self.likeCountLabel:text() + 1)))
        self.hasLiked = true
    end
    self:addScaleAnimation(self.likeButton)
end

---收藏事件
---@private
function _class:handleClickCollectEvent()
    if self.hasCollected then
        self.collectButton:image("https://s.momocdn.com/w/u/others/2019/08/31/1567258988643-collect.png")
        self.hasCollected = false
    else
        Toast("收藏成功", 1)
        self.collectButton:image("https://s.momocdn.com/w/u/others/2019/08/31/1567258988643-collected.png")
        self.hasCollected = true
    end
    self:addScaleAnimation(self.collectButton)
end

---动画
---@private
function _class:addScaleAnimation(view)
    local anim = Animation()
    anim:setScaleX(0.9, 1):setScaleY(0.9, 1):setDuration(0.2)
    anim:start(view)
end

return _class