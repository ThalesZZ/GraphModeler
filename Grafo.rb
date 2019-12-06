require_relative "Aresta.rb"
require_relative "Util.rb"

class Grafo
    include Util

    attr_accessor :vertices, :arestas, :rotulo, :editavel

    def initialize rotulo, vertices=[], arestas=[]
        @rotulo = rotulo
        @vertices = vertices
        @arestas = arestas
    end

    def to_s
        "Grafo #{@rotulo} | n = #{num_vertices} m = #{num_arestas}"
    end

    def update(window)
        @arestas.each do |aresta|
            aresta.update(window)
        end
        @vertices.each do |v|
            v.update(window)
        end
    end

    def draw(window)
        @arestas.each do |aresta|
            aresta.draw(window)
        end
        @vertices.each do |v|
            v.draw(window)
        end
    end

    def add_vertice vertice
        vertice.rotulo = gerar_rotulo @vertices
        @vertices << vertice

        ["Vértice #{@vertices[-1].rotulo} adicionado.", true]
    end

    def rmv_vertice vertice
        @arestas.each_with_index do |a|
            if a.v1 == vertice || a.v2 == vertice
                rmv_aresta a
            end
        end
        @vertices -= [vertice]

        if @vertices.length == 1
            @vertices[0].rotulo = "v0"
        end

        ["Vértice #{vertice.rotulo} removido.", true]
    end

    def rmv_aresta aresta
        @arestas -= [aresta]

        ["Aresta #{aresta} removida.", true]
    end

    def add_aresta a
        a_s = "#{a.v1.rotulo}:#{a.v2.rotulo}"
        if (@vertices.include? a.v1) && (@vertices.include? a.v2)
            if !(a.existe_em? @arestas)
                @arestas << a
            else
                return ["Aresta #{a_s} já existe.", false]
            end
        else
            return ["Vértice(s) da Aresta (#{a_s}) não pertence(m) a este grafo.",false]
        end

        ["Aresta #{a_s} adicionada.", true]
    end

    def num_vertices
        @vertices.length
    end

    def num_arestas
        @arestas.length
    end
end