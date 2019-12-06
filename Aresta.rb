require_relative "Vertice.rb"

class Aresta
    HOVER_COLOR = Gosu::Color::rgba(255,255,160, 255)
    DEFAULT_COLOR = Gosu::Color.rgba(255,255,255, 255)
    SUBG_COLOR = Gosu::Color.rgba(255,5,5, 255)

    attr_accessor :v1, :v2, :color

    def initialize v1, v2, color=DEFAULT_COLOR
        @v1 = v1
        @v2 = v2
        @color = color
    end

    def update(window)
    end

    def draw(window)
        offset1, offset2 = @v1.size/2, @v2.size/2
        window.draw_line(@v1.x+offset1, @v1.y+offset1,
        (@v1.hover?(window.mouse_x, window.mouse_y) ? HOVER_COLOR : @color),
        @v2.x+offset2, @v2.y+offset2,
        (@v2.hover?(window.mouse_x, window.mouse_y) ? HOVER_COLOR : @color))
    end

    def existe_em? (arestas)
        arestas.each do |a|
            if (a.vertices == [@v1, @v2]) || (a.vertices == [@v2, @v1])
                return true
            end
        end
        return false
    end

    def vertices
        [@v1, @v2]
    end

    def to_s
        "Aresta #{@v1.rotulo}:#{@v2.rotulo}"
    end
end