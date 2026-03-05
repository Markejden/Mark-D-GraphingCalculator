require 'ruby2d'
require_relative 'canvas'
require_relative 'actions'
set title: 'Desmos', background: 'white'
set resizable: true

col = 'black'
WIDTH = get :width
HEIGHT = get :height

andragraden = Equation.new(color: 'red', zindex: 1)  { |x| x * x - 10 }
sine = Equation.new(color: 'blue', zindex: 2) { |x| Math.sin(x) * 10 }

hej = Text.new(content: 'Dabble',inx: 50, iny: 50)
heja = Text.new(content: 'Dibble',inx: 50, iny: 30)

slider = Point.new(inx: 40, iny: HEIGHT-20)

canvas = Canvas.new
canvas.add_equation(sine)
canvas.add_equation(andragraden)
canvas.add_text(hej)
canvas.add_text(heja)
canvas.add_point(slider)

on :key_down do |event|
  sine.toggle
end

slider1(slider)

canvas.run