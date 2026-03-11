require 'ruby2d'
require_relative 'canvas'
require_relative 'actions'
set title: 'Desmos', background: 'white'
set resizable: true

col = 'black'
WIDTH = get :width
HEIGHT = get :height

slider = Point.new(inx: 40, iny: HEIGHT-25,zindex:5)

userinput = "x*x-15"
andragraden = Equation.new(color: 'red', zindex: 1){|x|eval(userinput)}

#sine = Equation.new(color: 'blue', zindex: 2) { |x| Math.sin(x) * 10 }

hej = Text.new(content: 'Dabble',inx: 50, iny: 50, zindex:5)
heja = Text.new(content: 'Dibble',inx: 50, iny: 30, zindex:5)


sliderline = Line.new(inx1: 40, iny1: HEIGHT-350, inx2: 40, iny2: HEIGHT-20, zindex:4)
sliderline2 = Rectangle.new(inx: 32, iny: HEIGHT-360,wide:16,high:350, zindex:3, color: 'white')

inputbox = Rectangle.new(inx: 80, iny: HEIGHT-20, wide: 100, high: -30, zindex: 4) # 300 ÄR LIKA STORT SOM 27 KARAKTÄRER
textbox = Text.new(content: '_',inx: 80, iny: HEIGHT-50,zindex:5, color: 'white',size:20)

canvas = Canvas.new
canvas.add_object(slider) #slider måste vara den första punkten för metoden i update (för nu)

#canvas.add_equation(sine)
canvas.add_object(andragraden)
canvas.add_object(hej)
canvas.add_object(heja)
canvas.add_object(textbox)
canvas.add_object(sliderline)
canvas.add_object(sliderline2)
canvas.add_object(inputbox)

Actions.slider1(slider)
Actions.pan(canvas)
Actions.inputbox(textbox,inputbox) do |input|
  andragraden.set_formula do |x|
  next nil unless Actions.valid_ruby?(input)
    eval(input, binding) rescue nil
  end
  puts input
end

canvas.run