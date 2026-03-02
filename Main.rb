require 'ruby2d'
require_relative 'canvas'
set title: 'Desmos', background: 'white'

col = 'black'
WIDTH = get :width
HEIGHT = get :height
mid = Point.new(WIDTH/2, HEIGHT/2)
puts "#{mid.y} and #{mid.x}"

canvas = Canvas.new
canvas.add_equation(Equation.new(color: 'red')  { |x| x * x - 10 })
canvas.add_equation(Equation.new(color: 'blue') { |x| Math.sin(x) * 50 })
canvas.run