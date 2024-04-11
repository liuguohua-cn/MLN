local timeDistance = "1.02km 4分钟前"
local cnt = 1
local window_1 = View()
                :setGravity(Gravity.CENTER)
                :width(MeasurementType.MATCH_PARENT)
                :height(88)
                :bgColor(Color(34, 66, 121, 1))
local window_1_1 = ImageView()
                  :width(60)
                  :height(60)
                  :contentMode(ContentMode.SCALE_TO_FILL)
                  :setGravity(Gravity.CENTER_VERTICAL)
                  :cornerRadius(35)
                  :marginLeft(10)
window_1_1:onClick(function()
cnt=cnt+1
DataBinding:update("userData.name", "click " .. cnt)
end)
window_1_1:image(DataBinding:get("userData.iconUrl"))
DataBinding:bind("userData.iconUrl", function(new, old)
    window_1_1:image(new)
end)
window_1_1:gone(DataBinding:get("userData.hideIcon"))
DataBinding:bind("userData.hideIcon", function(new, old)
    window_1_1:gone(new)
end)
window_1:addView(window_1_1)
local window_1_2 = LinearLayout(LinearType.VERTICAL)
                  :width(MeasurementType.MATCH_PARENT)
                  :height(70)
                  :setGravity(MBit:bor(Gravity.CENTER_VERTICAL, Gravity.RIGHT))
                  :marginRight(8)
                  :padding(3, 8, 3, 8)
                  :marginLeft(98)
                  :bgColor(Color(255, 252, 153, 0.5))
local window_1_2_1 = View()
                    :width(MeasurementType.MATCH_PARENT)
                    :marginTop(5)
                    :bgColor(Color(94, 87, 46, 70))
local window_1_2_1_1 = Label()
                      :setGravity(Gravity.CENTER_VERTICAL)
                      :marginLeft(5)
window_1_2_1_1:text(DataBinding:get("userData.name"))
DataBinding:bind("userData.name", function(new, old)
    window_1_2_1_1:text(new)
end)
window_1_2_1:addView(window_1_2_1_1)
local window_1_2_1_2 = Label()
                      :setGravity(MBit:bor(Gravity.CENTER_VERTICAL, Gravity.RIGHT))
local window_1_2_1_2_bindFunc = function()
if DataBinding:get("userData.hideIcon") then
window_1_2_1_2:text(timeDistance)
else
window_1_2_1_2:text(DataBinding:get("userData.title"))
end
end
window_1_2_1_2_bindFunc()
DataBinding:bind("userData.title", function(new, old)
    window_1_2_1_2_bindFunc()
end)
DataBinding:bind("userData.hideIcon", function(new, old)
    window_1_2_1_2_bindFunc()
end)
window_1_2_1:addView(window_1_2_1_2)
window_1_2:addView(window_1_2_1)
window_1:addView(window_1_2)
window:addView(window_1)
ui_views = {}
ui_views.window_1 = window_1
ui_views.window_1_2_1_2 = window_1_2_1_2
ui_views.window_1_2_1 = window_1_2_1
ui_views.window_1_2_1_1 = window_1_2_1_1
ui_views.window_1_1 = window_1_1
ui_views.window_1_2 = window_1_2
return {}, true
