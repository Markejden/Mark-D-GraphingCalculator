require 'ruby2d'
require_relative 'canvas'
require_relative 'actions'
set title: 'Desmos', background: 'white'
set resizable: true

col = 'black'
WIDTH = get :width
HEIGHT = get :height

slider = Point.new(inx: 40, iny: HEIGHT-25) #slider måste vara den första punkten för metoden i update


userinput = "x*x-15"
andragraden = Equation.new(color: 'red', zindex: 1){|x|eval(userinput)}

sine = Equation.new(color: 'blue', zindex: 2) { |x| Math.sin(x) * 10 }

hej = Text.new(content: 'Dabble',inx: 50, iny: 50)
heja = Text.new(content: 'Dibble',inx: 50, iny: 30)

nyline = Line.new(inx1: 40, iny1: HEIGHT-80, inx2: 40, iny2: HEIGHT-20)

inputbox = Rectangle.new(inx: 80, iny: HEIGHT-20, wide: 160, high: -30, zindex: 4)

canvas = Canvas.new
canvas.add_point(slider)
canvas.add_equation(sine)
canvas.add_equation(andragraden)
canvas.add_text(hej)
canvas.add_text(heja)
canvas.add_line(nyline)
canvas.add_rectangle(inputbox)

Actions.slider1(slider)
Actions.pan(canvas)
Actions.inputbox(inputbox) do |input|
  andragraden.set_formula do |x|
    begin
      if Actions.valid_ruby(input)
        eval(input)
      else
        nil
      end
    rescue => e
      puts "error: #{e.class}"
      abort('Input at fault')
    end
  end
  puts input
end

canvas.run