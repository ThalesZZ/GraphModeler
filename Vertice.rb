require "gosu"

class Circle
    attr_reader :columns, :rows
    
    def initialize(radius, r, g, b)
        @columns = @rows = radius * 2
    
        clear = 0x00.chr
      
        lower_half = ((0...radius).map do |y|
            x = Math.sqrt(radius ** 2 - y ** 2).round
            right_half = "#{r * x}#{clear * (radius - x)}"
            right_half.reverse + right_half
        end).join
        alpha_channel = lower_half.reverse + lower_half
      
        # Expand alpha bytes into RGBA color values.
        @blob = alpha_channel.gsub(/./) { |alpha| r + g + b + alpha }
    end
    
    def to_blob
        @blob
    end
end

class Vertice
    DEFAULT_SIZE  = 14
    HOVER_SIZE    = 16
    DEFAULT_COLOR = Gosu::Color.rgba(255,255,255,255)
    SUBG_COLOR    = Gosu::Color.rgba(255,5,5, 255)
    HOVER_COLOR   = Gosu::Color.rgba(255,255,0,255)
    @@dflt_circle = Gosu::Image.new(Circle.new(DEFAULT_SIZE/2, 0xff.chr, 0xff.chr, 0xff.chr))
    @@hovr_circle = Gosu::Image.new(Circle.new(DEFAULT_SIZE/2, 0xff.chr, 0xff.chr, 0x00.chr))
    @@subg_circle = Gosu::Image.new(Circle.new(DEFAULT_SIZE/2, 0xff.chr, 0x00.chr, 0x00.chr))

    attr_accessor :rotulo, :x, :y, :size, :color

    def initialize rotulo, x, y, color = DEFAULT_COLOR

        @rotulo = rotulo        # nome vertice
        # posicao x,y e tamanho s (size)
        @x = x
        @y = y
        @size  = DEFAULT_SIZE
        @color = color
    end

    def to_s
        "Vértice #{@rotulo}"
    end

    def offset
        @size/2
    end

    def update(window)
    end

    def draw(window)
        if hover?(window.mouse_x, window.mouse_y) && @color != SUBG_COLOR
            @@hovr_circle.draw @x, @y, 0
        else            
            @@dflt_circle.draw @x, @y, 0 if @color == DEFAULT_COLOR
            @@subg_circle.draw @x, @y, 0 if @color == SUBG_COLOR
        end
        window.getFont(HOVER_SIZE).draw_text(@rotulo, @x, @y-20, 1, 1.0, 1.0, DEFAULT_COLOR)
    end

    def hover? mouse_x, mouse_y
        mouse_x >= @x && mouse_x <= @x + @size && mouse_y >= @y && mouse_y <= @y + @size            
    end
end