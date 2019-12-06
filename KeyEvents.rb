require "gosu"
require_relative "Algoritmos.rb"
require_relative "ModeladorEvents.rb"

module KeyEvents
    include ModeladorEvents
    include Algoritmos

    def event_button_down id
        case id
            when Gosu::KB_ESCAPE # ESC
                esc_down
            when Gosu::KB_R
                r_down
            when Gosu::KB_H
                h_down
            when Gosu::KB_F1
                forca_bruta
            when Gosu::KB_F2
                cond_necessarias
            when Gosu::KB_F3
                cond_suficientes
        end

        return if @evento == Ev_Subgrafo

        case id
            when Gosu::MS_LEFT # Click esquerdo
                mouse_left_down
            when Gosu::MS_RIGHT # Click direito
                mouse_right_down
            when Gosu::KB_DELETE
                delete_down
            end
    end

    def event_button_up id
        case id
        when Gosu::MS_LEFT # Click esquerdo
            mouse_left_up
        end
    end

    def esc_down
        return sair_subgrafo if @evento == Ev_Subgrafo # apagar subgrafo
        return cancelar_evento if @evento != Ev_None # cancelar evento
        exit if @evento == Ev_None # Sair
    end

    def mouse_left_down
        if @evento == Ev_None
            vert = click_vertice?
            return adicionar_vertice if vert == nil # add vertice
            return mover_vertice vert # mover vertice
        end
    end

    def mouse_left_up
        if @evento == Ev_Move_Vert
            cancelar_evento
        end
    end

    def mouse_right_down
        return adicionar_aresta
    end

    def delete_down
        if @evento == Ev_None
            return if excluir_vertice == true
            return excluir_aresta
        end
    end

    def r_down
        return reset
    end

    def h_down
        Modelador.instrucoes[:enable] = !Modelador.instrucoes[:enable]
    end
end