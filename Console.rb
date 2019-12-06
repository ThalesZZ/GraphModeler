require "gosu"

class Console
    DFLT= Gosu::Color::WHITE
    ERRO = Gosu::Color::RED

    DFLT_TIME = 6 # segundos
    DFLT_MAX_LINES = 10
    
    def initialize
        @destaque  = ""
        @mensagens = []
        @mensagens << {text: "Bem vindo ao Construtor de Grafos :)", color: Gosu::Color::YELLOW, time_tick: Time.now, show_time: DFLT_TIME}
    end

    def add_mensagem text, color = DFLT, st = DFLT_TIME
        @mensagens = [{text: text, color: color, time_tick: Time.now, show_time: st}] + @mensagens

        if(@mensagens.size > DFLT_MAX_LINES)
            @mensagens.slice!(-1)
        end
    end

    def set_mensagem_em_destaque msg
        @destaque = msg
    end

    def get_mensagens
        @mensagens
    end

    def limpar_console
        @mensagens = []
        limpar_destaque
    end

    def limpar_destaque
        @destaque = ""
    end

    def self.update_tick msg
        @mensagens[msg][:time_tick] = Time.now
    end

    def update window
        @mensagens.each_with_index do |msg, i|
            if Time.now - msg[:time_tick] > msg[:show_time]
                @mensagens.slice!(i)
                #msg[:time_tick] = Time.now
            end
        end
    end

    def draw window
        window.getFont(21).draw_text(@destaque, 10, 260, 1, 1.0, 1.0, Gosu::Color::FUCHSIA)
        @mensagens.each_with_index do |msg, i|            
            window.getFont(21).draw_text(msg[:text], 10, Modelador::Height-35-i*25, 1, 1.0, 1.0, msg[:color])
        end
    end

end