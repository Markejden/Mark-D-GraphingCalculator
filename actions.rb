require_relative 'canvas'

class Actions
    extend Ruby2D::DSL
    @@sliderdrag = false
    @@pandrag = false
    def self.slider1(slider)
        @@sliderdrag = false
        on :mouse_down do |event|
            if event.button == :left
                if (event.x - slider.inx).abs < 10 && (event.y - slider.iny).abs < 10
                #leeway på 5 pixlar extra
                @@sliderdrag = true
                end
            end
        end

        on :mouse_move do |event|
            next unless @@sliderdrag
            if slider.iny>HEIGHT-20 || slider.iny<HEIGHT-80
                @@sliderdrag = false
                slider.iny = ((slider.iny - (HEIGHT-50)).positive? ? HEIGHT-25 : HEIGHT-75)
                #viktigt för dokumentation: såsom jag föstått det körs ? som if (true) och : som else (false)
                next
            end
            slider.iny = event.y
        end

        on :mouse_up do |event|
            @@sliderdrag = false
        end
    end

    def self.pan(canvas)
        lastx = 0
        lasty = 0
        on :mouse_down do |event|
            next if @@sliderdrag
            if event.button == :left
                @@pandrag = true
                lastx = event.x
                lasty = event.y
            end
        end

        on :mouse_move do |event|
            next unless @@pandrag
            canvas.pan_to(event.x-lastx, event.y-lasty)
            lastx = event.x
            lasty = event.y
        end

        on :mouse_up do |event|
            @@pandrag = false
        end
    end
end