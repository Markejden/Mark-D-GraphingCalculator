def slider1(slider)
    dragging = false
    sliderdrag = false
    on :mouse_down do |event|
    if event.button == :left
        dragging = true
        if (event.x - slider.inx).abs < 5 && (event.y - slider.iny).abs < 5
        sliderdrag = true
        end
    end
    end

    on :mouse_move do |event|
    next unless sliderdrag
    if slider.iny>HEIGHT-20 || slider.iny<HEIGHT-80
        sliderdrag = false
        slider.iny = ((slider.iny - (HEIGHT-50)).positive? ? HEIGHT-20 : HEIGHT-80)
        #viktigt för dokumentation: såsom jag föstått det körs ? om true och : om false
        next
    end
    slider.iny = event.y
    end

    on :mouse_up do |event|
    sliderdrag = false
    end
end