require "gosu"
require_relative "Util.rb"

class Ev
    def == ev_class
        self.instance_of? ev_class
    end
    def update(window)
    end
    def draw(window)
    end
end
class Ev_None < Ev # Nenhum evento
end
class Ev_Subgrafo < Ev
end
class Ev_Move_Vert < Ev  # Movendo vértice
    attr_accessor :v
    def initialize v
        @v = v
    end
    def update(window)
        off = @v.offset
        @v.x = window.mouse_x - off
        @v.y = window.mouse_y - off
    end
    def draw(window)
        offset = @v.offset
        window.getFont(15).draw_text("Movendo vértice\nx: #{@v.x.to_i}, y: #{@v.y.to_i}",
        window.mouse_x+offset, window.mouse_y+offset, 1, 1.0, 1.0, Gosu::Color::YELLOW)
    end
end
class Ev_Add_Aresta < Ev # Adicionando Aresta
    attr_accessor :v1, :v2
    def initialize v1, v2=nil
        @v1 = v1
        @v2 = v2
    end
    def aresta
        Aresta.new @v1, @v2
    end
    def update(window)
    end
    def draw(window)
        offset = @v1.offset
        window.getFont(15).draw_text("Criando aresta",
        window.mouse_x+offset, window.mouse_y+offset, 1, 1.0, 1.0, Gosu::Color::YELLOW)
        window.draw_line(@v1.x+offset, @v1.y+offset, Gosu::Color::WHITE, 
        window.mouse_x, window.mouse_y,  Gosu::Color::YELLOW)
    end
end

module ModeladorEvents

    def cancelar_evento
        @evento = Ev_None.new
        "Evento cancelado"
    end
    
    def sair_subgrafo
        @grafo.vertices.each { |v| v.color = Vertice::DEFAULT_COLOR }
        @grafo.arestas.each  { |a| a.color = Aresta::DEFAULT_COLOR  }

        @evento = Ev_None.new
        @subgrafo = Grafo.new "subG"
        @console.limpar_destaque
        "Sair do subgrafo que não pertence à classe"
    end

    def adicionar_vertice
        offset = Vertice::DEFAULT_SIZE/2
        resultado = @grafo.add_vertice Vertice.new "", mouse_x-offset, mouse_y-offset
        @console.add_mensagem(resultado[0])
        if(resultado[1])
            @evento = Ev_Move_Vert.new @grafo.vertices[-1]
        end
        "Adicionar Vértice"
    end

    def adicionar_aresta
        if @evento == Ev_None
            v1 = click_vertice?
            if v1 != nil
                @evento = Ev_Add_Aresta.new v1
            end
        elsif @evento == Ev_Add_Aresta
            v2 = click_vertice?
            if v2 != nil
                @evento.v2 = v2
                if @evento.v1 != @evento.v2
                    resultado = @grafo.add_aresta(@evento.aresta)
                    if resultado[1]
                        @console.add_mensagem(resultado[0])
                    else
                        @console.add_mensagem(resultado[0], Console::ERRO)
                    end
                end
                @evento = Ev_None.new
            end
        end
        "Adicionar Aresta"
    end

    def excluir_vertice
        v = click_vertice?
        if v != nil
            if @grafo.vertices.length > 1
                resultado = @grafo.rmv_vertice v
                @console.add_mensagem(resultado[0])
            else
                @console.add_mensagem("O grafo não pode ficar sem vértices!", Console::ERRO)
            end
            return true
        end
        return false
        "Excluir Vértice"
    end
    
    def excluir_aresta
        offset = Vertice::DEFAULT_SIZE
        @grafo.arestas.each do |a|
            x0,y0 = a.v1.x + a.v1.offset, a.v1.y + a.v1.offset
            x1,y1 = a.v2.x + a.v2.offset, a.v2.y + a.v2.offset

            cb = (y1 - (x1/x0) * y0)/(1-(x1/x0))
            ca = (y0-cb)/x0

            fc = proc {|x| (ca)*x + cb}
            #puts "A=(#{a.v1.x},#{a.v1.y}), B=(#{a.v2.x},#{a.v2.y})\nf(y) = #{ca}*x + #{cb}"
            fy = fc.call(mouse_x)
            #puts "f(#{mouse_x}) = #{fy}    #{mouse_y}"

            if (fy >= mouse_y - offset && fy <= mouse_y + offset) &&
                (mouse_x >= [a.v1.x, a.v2.x].min - offset && mouse_x <= [a.v1.x, a.v2.x].max + offset)
                resultado = @grafo.rmv_aresta a
                @console.add_mensagem(resultado[0])
                break
            end
        end
        "Excluir Aresta"
    end

    def mover_vertice v
        @evento = Ev_Move_Vert.new v
        "Mover Vértice"
    end

    def reset
        @grafo = init_model []
        sair_subgrafo
        @console.limpar_console
        @console.add_mensagem("O grafo foi reiniciado.", Gosu::Color::YELLOW)
    end

end