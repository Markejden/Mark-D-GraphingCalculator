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

    def self.draw_pixel(x,y,z,color)
        Ruby2D::Square.new(
            x: x, y: y,
            size: 1,
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
end