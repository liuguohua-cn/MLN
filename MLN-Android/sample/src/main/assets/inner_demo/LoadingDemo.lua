
timer = Timer()
timer:repeatCount(1)
timer:interval(3.0)

startView = Label()
startView:text('开始')
startView:textAlign(TextAlign.CENTER)
startView:bgColor(Color(222, 20, 232, 1))
startView:frame(Rect(100, 100, 80, 30))
startView:onClick(function()
    print('timer ---- start')
    Loading:show()

    timer:start(function()
        Loading:hide()
        timer:stop()
        print('timer ----- stop')
    end)
end)
window:addView(startView)

endView = Label()
endView:text('结束')
endView:textAlign(TextAlign.CENTER)
endView:bgColor(Color(222, 20, 232, 1))
endView:frame(Rect(200, 100, 80, 30))
window:addView(endView)


timer2 = Timer()
timer2:repeatCount(1)
timer2:interval(2.0)
timer2:start(function()
    print("timer2 ----- start")
    Loading:show()
end)

timer3 = Timer()
timer3:repeatCount(1)
timer3:interval(5.0)
timer3:start(function()
    print("timer3 ----- stop")
    timer2:stop()
    Loading:hide()
end)