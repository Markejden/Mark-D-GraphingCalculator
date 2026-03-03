require 'ruby2d'
require_relative 'equation'
require_relative 'drawing'

class Point
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
        @mid      = Point.new(@width / 2, @height / 2)
        @equations = []
        @text = []
    end

    def add_equation(equation)
        @equations << equation
    end

    def add_text(text)
        @text << text
    end
    
    def draw_axis
        Drawing.draw_line(0,@mid.y,@width,@mid.y,0,'black')
        Drawing.draw_line(@mid.x,0,@mid.x,@height,0,'black')
    end

    def plot_everything
        @equations.each do |eq|
            next if !eq.visible 
            plot_equation(eq)
        end

        @text.each do |txt|
            next if !txt.visible 
            plot_text(txt)
        end
    end

    def plot_text(text)
        Drawing.draw_text(text.content,text.inx,text.iny,text.zindex,text.rot,text.size,text.color)
    end

    def run
        draw_axis
        plot_everything
        update do
            clear
            draw_axis
            plot_everything
        end
        show
    end

    def plot_equation(eq)
        range = (-@width/2..@width/2)
        y1 = eq.evaluate(range.first)

        range.each_cons(2) do |x1, x2|
        y2 = eq.evaluate(x2)
        Drawing.draw_line(
            x1 + @mid.x, @mid.y - y1,
            x2 + @mid.x, @mid.y - y2,
            eq.zindex, eq.color
        )
        y1 = y2
        end
    end
end