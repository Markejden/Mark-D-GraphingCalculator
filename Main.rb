require 'ruby2d'
require_relative 'Create_functions'
set title: 'Desmos', background: 'white'

col = 'black'
width = get :width
height = get :height
mid = Point.new(width/2, height/2)
puts "#{mid.y} and #{mid.x}"

draw_line(20,20,40,40,0,col)
draw_pixel(30,50,0,col)
draw_pixel(40,50,0,col)
draw_axis(mid.x,mid.y)
draw_text('hello',50,50,1,0,20,col)

plot_equation(-200..200) {|x| x*x -10}

update do

end

show