require "get_process_mem"

module Algoritmos

    def subgrafo_nao_pertencente vertices_ciclo
        
        vertices_ciclo.each_with_index { |i, k| vertices_ciclo[k] = @grafo.vertices[i] }
        arestas_ciclo = []
        vertices_ciclo.each_with_index do |v1, k|
    		v2 = vertices_ciclo[(vertices_ciclo[-1] == v1 ? 0 : k+1)]

            @grafo.arestas.each do |a|
                if a.vertices == [v1, v2] || a.vertices == [v2, v1]
                    arestas_ciclo << a
                    break
                end
            end
        end

        @grafo.vertices.each { |v| v.color = Vertice::SUBG_COLOR if !vertices_ciclo.include? v }
        @grafo.arestas.each  { |a| a.color = Aresta::SUBG_COLOR  if !arestas_ciclo.include? a  }
        
	end

    def forca_bruta

        sair_subgrafo

        def BFS m_adj # busca em largura (bfs)
            eh_hamiltoniano = false
            ciclo_hamilt = []
            subgrafo = []

            n = m_adj.length
            vertices = (0...n).to_a # apenas os indexes da matriz de adj

            return [false, vertices] if n < 3
    
            # tenta procurar o ciclo começando por tds os vertices
            vertices.each do |partida|
                
                fila = [[partida]] # fila de possibilidades de caminhos
                
                until fila.empty?
                    
                    caminho = fila[0] # pega o proximo caminho da fila
                    
                    # pega todos os proximos vertices possiveis depois do ultimo no caminho
                    vizinhos(caminho[-1], m_adj).each do |prox|
                        
                        ciclo_encontrado = (prox == caminho[0] && caminho.size >= 3)    #achou um ciclo
                        ciclo_hamilt_enc = (ciclo_encontrado && caminho.length == n)    #achou o ciclo hamiltoniano

                        if ciclo_encontrado && caminho.length > subgrafo.length #achou um ciclo, mas ainda n é hamilt
                            subgrafo = caminho
                        end

                        return [true, caminho] if ciclo_hamilt_enc

                        fila << caminho + [prox] if !caminho.include? prox                        
                    end

                    fila.slice!(0) # anda a fila
                end
            end
    
            return [false, subgrafo] # retorna se é hamilt, o ciclo hamilt se encontrado e um subg
        end

        #puts "Analisando o Grafo...\n(Isso pode demorar um pouco)"

        matriz_adj = gerar_matriz_adjacencia(@grafo)

        t = Time.now
        r_fb, caminho, mem = BFS(matriz_adj) # resultado do alg de força bruta
        @console.add_mensagem("Utilizando algoritmo por força bruta:", Gosu::Color::YELLOW)
        @console.add_mensagem("Uso de memória: #{GetProcessMem.new.mb} MB")
        @console.add_mensagem("Tempo de execução: #{Time.now-t} s")

        resultado = "Grafo #{(r_fb ? "" : "não-")}Hamiltoniano\n"
        @evento = Ev_Subgrafo.new
        if r_fb
            caminho << caminho[0]
            caminho.each_with_index { |i, k| caminho[k] = @grafo.vertices[i].rotulo }
            resultado += "\nCaminho Hamiltoniano:\n#{escrever_ciclo(caminho)}\n\nESC - Retornar"
            @console.set_mensagem_em_destaque(resultado)
        elsif @grafo.vertices.length >= 3
            subgrafo_nao_pertencente caminho
            resultado += "Este subgrafo não pertence à classe.\n\nESC - Retornar"
            @console.set_mensagem_em_destaque(resultado)

        else
            @console.add_mensagem("Grafos hamiltonianos têm no mínimo 3 vértices!", Gosu::Color::YELLOW)
        end

    end

    def cond_suficientes
        sair_subgrafo
        @console.limpar_console

        matriz_adj = gerar_matriz_adjacencia @grafo

        def completo_dirac? madj
            completo=dirac=true
            n=madj.length
            dirac = false if n < 3
            num = n/2.0
            for i in(0...n)
                grau_v = 0
                for j in(0...n)
                    grau_v += 1 if madj[i][j]
                end
                completo = false if grau_v != n-1
                dirac    = false if grau_v < num

                @grafo.vertices[i].color = Vertice::SUBG_COLOR if grau_v != n-1 && grau_v < num
            end

            return completo, dirac
        end

        if matriz_adj.length < 3
            @console.add_mensagem "O grafo deve ter no mínimo 3 vértices!", Console::ERRO
            return nil
        end

        @evento = Ev_Subgrafo.new
        t = Time.now

        completo, dirac = completo_dirac? matriz_adj

        @console.add_mensagem("Reconhecendo condições suficientes:", Gosu::Color::YELLOW)
        @console.add_mensagem("Uso de memória: #{GetProcessMem.new.mb} MB")
        @console.add_mensagem("Tempo de execução: #{Time.now-t} s")



        if completo || dirac
            txt = "Grafo Hamiltoniano"
        else
            txt = "Não pode-se afirmar que este grafo seja\nou não Hamiltoniano com estas condições."
        end

        txt += "\n\nCondições suficientes:\n"
        txt += "[#{completo ? "X" : "  "}] Grafo completo\n"
        txt += "[#{dirac ? "X" : "  "}] Teorema de Dirac"
        txt += "\n\nESC - Retornar"
        @console.set_mensagem_em_destaque(txt)
    end

    def cond_necessarias
        
        sair_subgrafo
        @console.limpar_console

        lista_adj = gerar_lista_adjacencia @Grafo

        def conexo? lista_adj
            grafo = lista_adj

            cor={}
            dist={}
            pred={}

            for i in grafo.keys
                cor[i]= "branca"
                dist[i]= 0
                pred[i]= nil
            end

            inicial = grafo.keys()[0]
            
            cor[inicial]  = "azul"
            dist[inicial] = 0
            pred[inicial] = nil
            lista = [inicial]
            u = lista[0]

            while lista.length > 0
                vertice = lista[0]
                lista.slice!(0)
                for e in grafo[vertice]
                    if(cor[e] == "branca")
                        cor[e] = "cinza"
                        dist[e] = dist[vertice]+1
                        pred[e] = vertice
                        lista << e
                    end
                end
                cor[vertice]= "azul"
            end

            dist.each { |d| return false if d[1]==0 and d[0] != u }
            return true
        end

        def biconexo? lista_adj
            bicon = true
            for i in lista_adj.keys
                g = lista_adj.clone
                g.delete i
                g.keys.each { |k| g[k] -= [i] }
                con = conexo?(g)
                bicon = false if !con
                i.color = Vertice::SUBG_COLOR if !con
            end
            return bicon
        end

        if lista_adj.length < 3
            @console.add_mensagem "O grafo deve ter no mínimo 3 vértices!", Console::ERRO
            return nil
        end

        @evento = Ev_Subgrafo.new
        t = Time.now
        conexo, biconexo = conexo?(lista_adj), biconexo?(lista_adj)
        @console.add_mensagem("Reconhecendo condições necessárias:", Gosu::Color::YELLOW)
        @console.add_mensagem("Uso de memória: #{GetProcessMem.new.mb} MB")
        @console.add_mensagem("Tempo de execução: #{Time.now-t} s")

        if conexo && biconexo
            txt = "Talvez este grafo seja Hamiltoniano"
        else
            txt = "Grafo não-Hamiltoniano"
        end
        
        txt += "\n\nCondições necessárias:\n"
        txt += "[#{conexo ? "X" : "  "}] Grafo conexo\n"
        txt += "[#{biconexo ? "X" : "  "}] Sem articulações"
        txt += "\n\nESC - Retornar"
        @console.set_mensagem_em_destaque(txt)
    end

    def escrever_ciclo caminho
        ciclo = ""
        caminho.each { |v| ciclo += "#{v}, " }
        2.times { ciclo.slice!(-1) }
        "(#{ciclo})"
    end

    def vizinhos k, m_adj
        vizinhos = []
        m_adj[k].each_with_index{ |aresta, i| vizinhos << i if aresta }
        #vizinhos.each_with_index{ |k, i| vizinhos[i] = vertices[k] }
        return vizinhos
    end

    def gerar_matriz_adjacencia grafo
        n = grafo.num_vertices
        
        matriz = []
        for i in (0...n)
            linha = []
            for j in (0...n)
                vi, vj = grafo.vertices[i], grafo.vertices[j]
                aij = Aresta.new(vi, vj)
                linha << (aij.existe_em?(grafo.arestas) ? true : false)
            end
            matriz << linha
        end

        return matriz
    end

    def gerar_lista_adjacencia grafo
        lista = {}
        @grafo.vertices.each { |v| lista[v] = [] }
        @grafo.arestas.each do |a|
            lista[a.v1] += [a.v2]
            lista[a.v2] += [a.v1]
        end
        return lista
    end
end