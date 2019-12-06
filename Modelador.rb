require_relative "Gerador.rb"
require_relative "KeyEvents.rb"
require_relative "Console.rb"
require_relative "Util.rb"

class Modelador < Gosu::Window
    include KeyEvents
    include Gerador
    include Util

    Width      = 1366
    Height     = 768
    Background = Gosu::Color.rgba(20,20,20, 255)

    attr_accessor :grafo, :console, :evento, :subgrafo

    def initialize args
        super Width, Height        
        @@Instrucoes = {instrucoes: instrucoes_uso, enable: false}
        @@Font = {}

        @console = Console.new          # console de mensagens
        @evento  = Ev_None.new          # evento em andamento
        @grafo = init_model args        # grafo do poblema
    end

    def update #atualização de estado
        @evento.update(self)
        @console.update(self)
        @grafo.update(self)
    end

    def draw #renderização
        #background
        draw_quad(
            0    , 0,       Background,
            Width, 0,       Background,
            Width, Height,  Background,
            0    , Height,  Background
        )
        
        #license
        #@@Font[15].draw_text(Gosu::LICENSES, 10, 10, 1, 1.0, 1.0, Gosu::Color::WHITE)

        #instrucoes
        draw_instrucoes

        #eventos
        @evento.draw(self)

        #grafo
        @grafo.draw(self)

        #console
        @console.draw(self)
    end

    def getFont size
        criarFonte(size) if !@@Font.include?(size)
        return @@Font[size]
    end

    def button_down id
        event_button_down id
    end

    def button_up id
        event_button_up id
    end

    def needs_cursor? # mostrar cursor
        true
    end

    def self.instrucoes
        @@Instrucoes
    end

    private
    def criarFonte size
        @@Font[size] = setFont(size)
    end

    def init_model args # ler argumentos
        grafo = nil

        case args[0]
        when "petersen"
            grafo = petersen
        when "completo"
            grafo = completo(args[1].to_i)
        when "ciclo"
            grafo = ciclo(args[1].to_i)
        when "nulo"
            grafo = nulo(args[1].to_i)
        else
            grafo = Grafo.new "G", [Vertice.new("v0", Width/2 - Vertice::DEFAULT_SIZE/2, Height/2 - Vertice::DEFAULT_SIZE/2)]
        end
        
        return grafo
    end
    
    def draw_instrucoes # instruções da tela
        fs = 18
        ls = 22
        if @@Instrucoes[:enable]
            @@Instrucoes[:instrucoes].each_with_index do |inst, i|
                getFont(fs).draw_text(inst[:btn], 10, 10 + i*ls, 1, 1.0, 1.0, Gosu::Color::YELLOW)
                getFont(fs).draw_text(inst[:txt], 100,10 + i*ls, 1, 1.0, 1.0, Gosu::Color::YELLOW)
            end
        else
            getFont(fs).draw_text("H - Ajuda", 10, 10, 1, 1.0, 1.0, Gosu::Color::YELLOW)
            #getFont(fs).draw_text("Ajuda", 100, 10, 1, 1.0, 1.0, Gosu::Color::YELLOW)
        end
    end

    def instrucoes_uso
        [
            {btn: "H",       txt: "Minimizar ajuda"},
            {btn: "L CLICK", txt: "Adicionar Vértice"},
            {btn: "R CLICK", txt: "Adicionar Aresta"},
            {btn: "DEL",     txt: "Remover Vértice | Aresta"},
            {btn: "R",       txt: "Reiniciar Grafo"},
            {btn: "ESC",     txt: "Cancelar | Sair"},
            {btn: "F1",      txt: "Algtm. Força Bruta"},
            {btn: "F2",      txt: "Algtm. Cond. Necessárias"},
            {btn: "F3",      txt: "Algtm. Cond. Suficientes"},
        ]
    end

end

Modelador.new(ARGV).show