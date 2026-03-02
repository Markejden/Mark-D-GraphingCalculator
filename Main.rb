require 'ruby2d'
require_relative 'canvas'
set title: 'Desmos', background: 'white'
set resizable: true

col = 'black'
WIDTH = get :width
HEIGHT = get :height
mid = Point.new(WIDTH/2, HEIGHT/2)
puts "#{mid.y} and #{mid.x}"


andragraden = Equation.new(color: 'red', zindex: 1)  { |x| x * x - 10 }
sine = Equation.new(color: 'blue', zindex: 2) { |x| Math.sin(x) * 10 }

canvas = Canvas.new
canvas.add_equation(sine)
canvas.add_equation(andragraden)

on :key_down do |event|
  sine.toggle!
  canvas.plot_everything if event.key == 's'
end

canvas.run