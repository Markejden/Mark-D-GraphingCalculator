require 'ruby2d'
require_relative 'equation'
require_relative 'drawing'

class Truepoint
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end
end

class Canvas
    include Ruby2D::DSL
    def initialize
        @width    = get :width
        @height   = get :height
        @mid      = Truepoint.new(@width / 2, @height / 2)
        @panx = 0
        @pany = 0
        @eq = ""
        @equations = []
        @texts = []
        @points = []
        @lines = []
        @rectangles = []
    end

    def add_equation(equation)
        @equations << equation
    end

    def add_text(text)
        @texts << text
    end

    def add_point(point)
        @points << point
    end

    def add_line(line)
        @lines << line
    end

    def add_rectangle(rect)
        @rectangles << rect
    end
    
    def draw_axis
        Drawing.draw_line(0,@mid.y+@pany,@width,@mid.y+@pany,0,'black')
        Drawing.draw_line(@mid.x+@panx,0,@mid.x+@panx,@height,0,'black')
    end

    def plot_everything
        @equations.each do |eq|
            next if !eq.visible 
            plot_equation(eq)
        end

        @texts.each do |txt|
            next if !txt.visible 
            plot_text(txt)
        end

        @points.each do |point|
            next if !point.visible 
            plot_point(point)
        end

        @lines.each do |line|
            next if !line.visible
            plot_line(line)
        end

        @rectangles.each do |rect|
            next if !rect.visible
            plot_rectangle(rect)
        end
    end

    def run
        update do
            @zoom = 1.0+(50.0-((@points[0].iny)-405.0))/25
            clear
            draw_axis
            plot_everything
        end
        show
    end

    def plot_equation(eq)
        resolution = 1.0 / @zoom
        rangestart = (-@width/@zoom/2)-(@panx/@zoom)
        rangeend = (@width/@zoom/2)-(@panx/@zoom)

        x1 = rangestart
        y1 = eq.evaluate(x1)

        while x1 < rangeend
            x2 = x1 + resolution
            y2 = eq.evaluate(x2)
            next if y1.nil? || y2.nil?
            Drawing.draw_line(
                (x1*@zoom)+@mid.x+@panx, @pany+@mid.y-(y1*@zoom),
                (x2*@zoom)+@mid.x+@panx, @pany+@mid.y-(y2*@zoom),
                eq.zindex, eq.color
            )

            x1 = x2
            y1 = y2
        end
    end

    def plot_text(text)
        Drawing.draw_text(text.content,text.inx,text.iny,text.zindex,text.rot,text.size,text.color)
    end

    def plot_point(point)
        Drawing.draw_point(point.inx, point.iny, point.zindex, point.color,)
    end

    def plot_line(line)
        Drawing.draw_line(line.inx1,line.iny1,line.inx2,line.iny2,line.zindex,line.color)
    end

    def plot_rectangle(rect)
        Drawing.draw_rectangle(rect.inx, rect.iny, rect.wide, rect.high, rect.zindex, rect.color)
    end

    def pan_to(x,y)
        @panx += x
        @pany += y
    end
end