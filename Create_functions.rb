require 'ruby2d'

class Point
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end
end

def draw_line(x1,y1,x2,y2,z,color)
    Line.new(
        x1: x1, y1: y1,
        x2: x2, y2: y2,
        width: 1,
        color: color,
        z: z
    )
end

def draw_pixel(x,y,z,color)
    Square.new(
        x: x, y: y,
        size: 1,
        color: color,
        z: z
    )
end

def plot_equation(range, &formula)
    wide = get :width
    high = get :height
    range.each do |x1|
        x2 = x1 + 1
        y1 = formula.call(x1)
        y2 = formula.call(x2)
        draw_line(x1 + wide/2,high/2 - y1,x2 + wide/2,high/2 - y2,0,'black')
    end
end

def draw_text(txt,x,y,z,rotation,size,color)
    Text.new(
    txt,
    x: x, y: y,
    style: 'bold',
    size: size,
    color: color,
    rotate: rotation,
    z: z
    )
end

def draw_axis(middlex,middley)
    wide = get :width
    high = get :height
    draw_line(0,middley,wide,middley,0,'black')
    draw_line(middlex,0,middlex,high,0,'black')
end