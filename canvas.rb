require 'ruby2d'

class Truepoint
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end
end

class Canvas
    include Ruby2D::DSL
    attr_accessor :zoomslide
    def initialize
        @width = get :width
        @height = get :height
        @mid = Truepoint.new(@width / 2, @height / 2)
        @panx = 0
        @pany = 0
        @objects = []
        @ui_shapes = {}
        @equation_pool = {}
        @point_pool = {}
    end

    def add_object(ob)
        @objects << ob
    end

    def run
        update do
            @zoom = 10.0+(50.0-((@zoomslide.iny)-405.0))/25 if @zoomslide
            plot_everything
        end
        show
    end

    def plot_everything
        plot_axis
        @objects.each do |obj|
            next if !obj.visible 
            objclass = obj.class
            plot_equation(obj) if objclass == Equation
            plot_text(obj) if objclass == Text
            plot_point(obj) if objclass == Point
            plot_line(obj) if objclass == Line
            plot_rectangle(obj) if objclass == Rectangle
        end
    end

    def plot_equation(eq)
        resolution = 1.0 / @zoom
        rangestart = (-@width/@zoom/2)-(@panx/@zoom)
        rangeend = (@width/@zoom/2)-(@panx/@zoom)

        @equation_pool[eq] ||= Array.new(2000){Ruby2D::Line.new(x1: -10, y1: -10, x2: -10, y2: -10, width: 1, z: eq.zindex)}
        #Array.new(2000){} gör en ny array med 2000 slots som har innehållet av blocket, object pooling
        # alltså finns det alltid 2000 linjer åt alla ekvations linjer precis utanför skärmen
        pool = @equation_pool[eq]
        x1 = rangestart
        y1 = eq.evaluate(x1)
        line_index = 0
        while x1 < rangeend
            x2 = x1 + resolution
            y2 = eq.evaluate(x2)

            unless y1.nil? || y2.nil?
                jump = (y2 - y1).abs*@zoom
                linedraw = true
                if jump > @height
                    linedraw = false
                elsif jump > 3.0
                    truey = eq.evaluate(((x1 + x2) / 2.0))
                    
                    if truey.nil?
                        linedraw = false 
                    else
                        expectedy = (y1 + y2) / 2.0
                        if (truey - expectedy).abs > (y2 - y1).abs * 0.45
                            linedraw = false
                        end
                    end
                end
                #allt över är för failsafe emot continouity errors, jag kollade online och det verkar inte som att det finns någon universiell lösning
                #så jag skapade tre scenarion istället som täcker de flesta basfall, tanx ser fortfarande lite kass ut
                if linedraw && line_index < pool.length
                    line = pool[line_index]
                    line.x1 = (x1*@zoom)+@mid.x+@panx
                    line.y1 = @pany+@mid.y-(y1*@zoom)
                    line.x2 = (x2*@zoom)+@mid.x+@panx
                    line.y2 = @pany+@mid.y-(y2*@zoom)
                    line.color = eq.color
                    line_index += 1
                end
            end

            x1 = x2
            y1 = y2
        end
        #för att ta bort alla linjer som inte målades, som tex floorx kommer inte behöva hälften av linjerna den blir assigned (i perfect teori)
        while line_index < pool.length
            l = pool[line_index]
            l.x1 = -10; l.y1 = -10; l.x2 = -10; l.y2 = -10
            line_index += 1
        end
    end

    def plot_axis
        #||= är iprincip "om nil, ge detta värde" bra för ny object pooling metoden
        @axis_x ||= Ruby2D::Line.new(color: 'gray', z: 0, width: 1)
        @axis_y ||= Ruby2D::Line.new(color: 'gray', z: 0, width: 1)
        @axis_x.x1 = 0
        @axis_x.y1 = @mid.y + @pany
        @axis_x.x2 = @width
        @axis_x.y2 = @mid.y + @pany

        @axis_y.x1 = @mid.x + @panx
        @axis_y.y1 = 0
        @axis_y.x2 = @mid.x + @panx
        @axis_y.y2 = @height
        
        #allt här under är för det mesta en copy paste av equation bara för incrementationen på axien
        @point_pool[0] ||= Array.new(1000) { Ruby2D::Square.new(x: -10, y: -10, size: 2, color: 'white', z: 1) }
        pool = @point_pool[0]
        point_index = 0
        minx = ((-@mid.x - @panx) / @zoom).floor
        maxx = ((@width - @mid.x - @panx) / @zoom).ceil
        miny = ((@mid.y + @pany - @height) / @zoom).floor
        maxy = ((@mid.y + @pany) / @zoom).ceil

        (minx..maxx).each do |x|
            next if x == 0 || point_index >= pool.length 
            sq = pool[point_index]
            sq.x = (x * @zoom) + @mid.x + @panx - 1 #hälften av size
            sq.y = @mid.y + @pany - 1
            point_index += 1
        end

        (miny..maxy).each do |y|
            next if y == 0 || point_index >= pool.length 
            sq = pool[point_index]
            sq.x = @mid.x + @panx - 1
            sq.y = @mid.y + @pany - (y * @zoom) - 1 
            point_index += 1
        end

        while point_index < pool.length
            sq = pool[point_index]
            sq.x = -10
            sq.y = -10
            point_index += 1
        end
    end

    def plot_text(text)
        obj = @ui_shapes[text] ||= Ruby2D::Text.new(text.content, style: 'bold', size: text.size, color: text.color, z: text.zindex)
        obj.text = text.content
        obj.x = text.inx
        obj.y = text.iny
        obj.color = text.color
        obj.size = text.size
    end

    def plot_point(point)
        obj = @ui_shapes[point] ||= Ruby2D::Square.new(size: point.size, color: point.color, z: point.zindex)
        obj.x = point.inx - 3
        obj.y = point.iny - 3
        obj.color = point.color
        obj.size = point.size
    end

    def plot_line(line)
        obj = @ui_shapes[line] ||= Ruby2D::Line.new(width: 1, color: line.color, z: line.zindex)
        obj.x1 = line.inx1
        obj.y1 = line.iny1
        obj.x2 = line.inx2
        obj.y2 = line.iny2
    end

    def plot_rectangle(rect)
        obj = @ui_shapes[rect] ||= Ruby2D::Rectangle.new(width: rect.wide, height: rect.high, color: rect.color, z: rect.zindex)
        obj.x = rect.inx
        obj.y = rect.iny
        obj.width = rect.wide
        obj.height = rect.high
        obj.color = rect.color
    end

    def pan_to(x,y)
        @panx += x
        @pany += y
    end
end