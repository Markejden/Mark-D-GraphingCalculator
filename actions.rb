require_relative 'canvas'
require_relative 'equation'

class Actions
    extend Ruby2D::DSL
    @@sliderdrag = false
    @@pandrag = false
    @@typing

    def self.slider1(slider) #zoomsliderns logik
        @@sliderdrag = false
        on :mouse_down do |event|
            next unless event.button == :left
            next unless (event.x - slider.inx).abs < 10 && (event.y - slider.iny).abs < 10 #click hitbox på 10 pixlar
            #leeway på 5 pixlar extra
            @@sliderdrag = true
        end

        on :mouse_move do |event| #uppdatera positionen om out of bounds
            next unless @@sliderdrag
            if slider.iny>HEIGHT-20 || slider.iny<HEIGHT-350
                @@sliderdrag = false
                slider.iny = ((slider.iny - (HEIGHT-50)).positive? ? HEIGHT-25 : HEIGHT-345)
                next
            end
            slider.iny = event.y
        end

        on :mouse_up do |event| #snapback
            @@sliderdrag = false
            slider.iny = HEIGHT-185
        end
    end

    def self.pan(canvas)
        lastx = 0
        lasty = 0
        on :mouse_down do |event|
            next if @@sliderdrag #skippa pan om du håller i slidern
            next unless event.button == :left
            @@pandrag = true
            lastx = event.x
            lasty = event.y
        end

        on :mouse_move do |event|
            next unless @@pandrag
            canvas.pan_to(event.x-lastx, event.y-lasty) #här kallas canvas pan_to, ligger längst ner i filen
            lastx = event.x
            lasty = event.y
        end

        on :mouse_up do |event|
            @@pandrag = false
        end
    end

    def self.inputbox(text,box, &finish) #&finish för att passera logiken som ligger i main som ett block
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
                finish.call(inputs.join) #här använder den alltså metoden som ligger i main som ett block och ger inputsen till blocket vilket skickas till equation.rb
                @@typing = false
            elsif event.key == 'backspace'
                inputs.pop
                text.content = inputs.join
            elsif event.key == 'right shift' || event.key == 'left shift'
                shiftbuffer = true
            else
                key = case event.key #allt detta är bara här för att ruby2d kör på amerikanskt tangentbord, så det är bara en "översättning"
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
                end #case är som en längre if statement med flera passerande conditions
                shiftbuffer ? inputs << key.upcase : inputs << key #om shiftbuffer är true ge inputs upcase key annars ge inputs vanliga key
                text.content = inputs.join
                shiftbuffer = false
            end
            box.wide = 10 + 10*(inputs.join.length) #för att boxen ska expandera destu mer text man skriver
        end
    end

    def self.check_value(canvas, eq) #för att kolla vilket värde en graf har vid x
        canvas.value_labels ||= [] 
        on :mouse_down do |event|
            next unless event.button == :right
            graf_x = (event.x-canvas.mid.x-canvas.panx)/canvas.zoom
            graf_y = eq.evaluate(graf_x)
            next if graf_y.nil?
            canvas.value_labels << {x:graf_x,y:graf_y} #lägg till y och x till valuelabels som omvandlar till text vid punkten
        end
        on :key_down do |event|
            if (event.key == 'r' && @@typing == false)
                (canvas.value_labels ||= []).each do |pt|
                    canvas.shapes[pt].x = 0
                    canvas.shapes[pt].y = -30 #flytta utanför skärmen
                end
                canvas.value_labels = [] #ta bort alla vid R
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