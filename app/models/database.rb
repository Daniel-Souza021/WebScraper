require 'pg'

class Database

  class << self

    def inserir_dados produtos
      # cria_conexao
      # tratamento_excecao do
        produtos.each do |produto|
          Produto.create(descricao: produto[:descricao], preco: produto[:preco], mercado_id: produto[:mercado_id])
          # @connection.exec("INSERT INTO produto VALUES('#{produto[:mercado_id]}', '#{produto[:descricao]}', '#{produto[:preco]}')")
        # end
      end
    end

    private

    def cria_conexao
      host = String('localhost')
      database = String('scraper_db')
      user = String('postgres')
      password = String('postgres')
      @connection = PG::Connection.new(:host => host, :user => user, :dbname => database, :port => '5432', :password => password)
    end

    def tratamento_excecao
      begin
        yield
      rescue PG::Error => e
        puts e.message
      ensure
        @connection.close if @connection
      end
    end
  end
end