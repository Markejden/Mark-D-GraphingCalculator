require 'ruby2d'
require_relative 'create_functions'
set title: 'Desmos', background: 'white'

col = 'black'
WIDTH = get :width
HEIGHT = get :height
mid = Point.new(WIDTH/2, HEIGHT/2)
puts "#{mid.y} and #{mid.x}"

draw_line(20,20,40,40,0,col)
draw_pixel(30,50,0,col)
draw_pixel(40,50,0,col)
draw_axis(mid.x,mid.y, WIDTH, HEIGHT)
draw_text('hello',50,50,1,0,20,col)

plot_equation(-200..200,WIDTH, HEIGHT) {|x| x*x -10}

update do

end

show