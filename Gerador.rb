require_relative "Grafo.rb"

module Gerador
    def nulo n=1, divisor=4
        g = Grafo.new "G Nulo"
        centro = {x: Modelador::Width/divisor, y: Modelador::Width/divisor}
        angulo = 360.0/n
        a = 0
        for i in (0...n)
            rad = a*Math::PI/180
            x = centro[:x]+centro[:x]*Math.cos(rad)
            y = centro[:y]+centro[:y]*Math.sin(rad)

            g.add_vertice(Vertice.new("", x, y))
            
            a += angulo
        end        
        dif = [Modelador::Width/2 - centro[:x], Modelador::Height/2 - centro[:y]]
        g.vertices.each do |v|
            v.x += dif[0] - v.size/2
            v.y += dif[1] - v.size/2
        end
        return g
    end
    def ciclo n=3
        g = nulo n
        g.rotulo = "C#{n}"
        for i in (0...n-1)
            g.add_aresta(Aresta.new(g.vertices[i], g.vertices[i+1]))
        end
        g.add_aresta(Aresta.new(g.vertices[-1], g.vertices[0]))
        return g
    end
    def completo n=3
        g = ciclo n
        g.rotulo = "K#{n}"
        g.arestas = []

        g.vertices.each_with_index do |v, i|
            g.vertices[i+1..n].each do |w|
                g.add_aresta Aresta.new v, w
            end
        end

        return g
    end
    def petersen
        g = ciclo 5
        
        nulo(5, 8).vertices.each do |v|
            g.add_vertice v
        end

        for i in (0...5)
            g.add_aresta(Aresta.new(g.vertices[i], g.vertices[i+5]))
        end

        g.add_aresta(Aresta.new(g.vertices[5], g.vertices[7]))
        g.add_aresta(Aresta.new(g.vertices[7], g.vertices[9]))
        g.add_aresta(Aresta.new(g.vertices[9], g.vertices[6]))
        g.add_aresta(Aresta.new(g.vertices[6], g.vertices[8]))
        g.add_aresta(Aresta.new(g.vertices[8], g.vertices[5]))

        return g
    end
end