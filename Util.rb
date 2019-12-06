require "gosu"

module Util
    def setFont size
        Gosu::Font.new(self, Gosu::default_font_name, size)
    end

    def click_in? click_x, click_y, rect_x, rect_y, rect_w, rect_h
        (click_x >= rect_x) && (click_x <= rect_x+rect_w) && (click_y >= rect_y) && (click_y <= rect_y+rect_h)
    end

    def click_vertice?
        @grafo.vertices.each do |v|
            if click_in? mouse_x, mouse_y, v.x, v.y, v.size, v.size
                return v
            end
        end
        return nil
    end

    def gerar_rotulo vertices
        return "v0" if vertices.length == 0
        ind = 0
        vertices.each_with_index do |v, k|
            i = v.rotulo[1..-1].to_i
            if ind < i
                ind = i
            end
        end
        "v#{ind+1}"
    end
end