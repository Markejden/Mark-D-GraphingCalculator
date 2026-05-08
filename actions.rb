require_relative 'canvas'
require_relative 'equation'

class Actions
    extend Ruby2D::DSL
    @@sliderdrag = false
    @@pandrag = false
    @@typing
    def self.slider1(slider)
        @@sliderdrag = false
        on :mouse_down do |event|
            next unless event.button == :left
            next unless (event.x - slider.inx).abs < 10 && (event.y - slider.iny).abs < 10
            #leeway på 5 pixlar extra
            @@sliderdrag = true
        end

        on :mouse_move do |event|
            next unless @@sliderdrag
            if slider.iny>HEIGHT-20 || slider.iny<HEIGHT-350
                @@sliderdrag = false
                slider.iny = ((slider.iny - (HEIGHT-50)).positive? ? HEIGHT-25 : HEIGHT-345)
                next
            end
            slider.iny = event.y
        end

        on :mouse_up do |event|
            @@sliderdrag = false
            slider.iny = HEIGHT-25
        end
    end

    def self.pan(canvas)
        lastx = 0
        lasty = 0
        on :mouse_down do |event|
            next if @@sliderdrag
            next unless event.button == :left
            @@pandrag = true
            lastx = event.x
            lasty = event.y
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

    def self.inputbox(text,box, &finish)
        inputs = []
        @@typing = false
        shiftbuffer = false
        on :mouse_down do |event|
            next unless event.button == :left
            next unless (event.x - (box.inx + box.wide)).abs < box.wide && (event.y - (box.iny - 15)).abs < 15
            @@typing = true
            inputs = []
        end

        on :key_down do |event|
            next unless @@typing
            if event.key == 'return'
                finish.call(inputs.join)
                @@typing = false
            elsif event.key == 'backspace'
                inputs.pop
                text.content = inputs.join
            elsif event.key == 'right shift' || event.key == 'left shift'
                shiftbuffer = true
            else
                key = case event.key
                    when '-' then '+'
                    when '/' then '-'
                    when '\\' then '*'
                    when '`' then '('
                    when '=' then ')'
                    when ']' then '**'
                    when 'pagedown' then '"'
                    when 'pageup' then '/'
                    when 'right ctrl' then 'Equation.'
                    when 'left ctrl' then '='
                    when 'left alt' then '?'
                    when 'TAB' then ';'
                    when 'home' then ':'
                    when 'space' then ' '
                    else event.key
                end
                shiftbuffer ? inputs << key.upcase : inputs << key
                text.content = inputs.join
                shiftbuffer = false
                #case är som en längre if statement med flera passerande conditions
            end
            box.wide = 10 + 10*(inputs.join.length)
        end
    end

    def self.check_value(canvas, eq)
        canvas.value_labels ||= []  # store as graph coords
        on :mouse_down do |event|
            next unless event.button == :right
            graf_x = (event.x - canvas.mid.x - canvas.panx) / canvas.zoom
            graf_y = eq.evaluate(graf_x)
            next if graf_y.nil?
            canvas.value_labels << { x: graf_x, y: graf_y }
        end
        on :key_down do |event|
            if (event.key == 'r' && @@typing == false)
                (canvas.value_labels ||= []).each do |pt|
                    canvas.shapes[pt].x = 0
                    canvas.shapes[pt].y = -30
                end
                canvas.value_labels = []
            end
        end
    end

    def self.valid_ruby?(code)
        RubyVM::InstructionSequence.compile(code)
        true
    rescue SyntaxError
        false
    end
end