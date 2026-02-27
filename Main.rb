require 'ruby2d'
require_relative 'Point_create'
width = get :width
height = get :height

def Line(x1,x2,y1,y2,z,color)
    Line.new(
        x1: x1, y1: y1,
        x2: x2, y2: y2,
        width: 5,
        color: color,
        z: z
    )
end

def Pixel(x,y,z,color)
    Square.new(
        x: x, y: y,
        size: 5,
        color: color,
        z: z
    )
end

mid = Point.new(width/2, height/2)
puts "#{mid.y} and #{mid.x}"

update do
    Line(20,40,20,40,0,'teal')
    Pixel(30,50,0,'teal')
    Pixel(40,50,0,'teal')
end

show