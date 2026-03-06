require 'ruby2d'

module Drawing
    def self.draw_line(x1,y1,x2,y2,z,color)
        Ruby2D::Line.new(
            x1: x1, y1: y1,
            x2: x2, y2: y2,
            width: 1,
            color: color,
            z: z
        )
    end

    def self.draw_point(x,y,z,color)
        Ruby2D::Square.new(
            x: x-3, y: y-3, # då 3 är hälften av 6 för kvadrater spawnar på upleft hörnen
            size: 6,
            color: color,
            z: z
        )
    end

    def self.draw_text(txt,x,y,z,rotation,size,color)
        Ruby2D::Text.new(
        txt,
        x: x, y: y,
        style: 'bold',
        size: size,
        color: color,
        rotate: rotation,
        z: z
        )
    end

    def self.draw_rectangle(x,y,w,h,z,color)
        Ruby2D::Rectangle.new(
        x: x, y: y,
        width: w, height: h,
        color: color,
        z: z
        )
    end
end