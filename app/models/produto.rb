class Produto < ApplicationRecord

  scope :mercado_brasao, -> { where codigo_mercado: 1 }
  scope :mercado_moura, -> { where codigo_mercado: 2 }
  scope :valido, -> { where "produtos.link_imagem LIKE ?", "%_mini.jpg%" }

  class << self

    def inserir_dados produtos
      produtos.each do |produto|
        Produto.create produto
      end
    end

    def busca_produtos params = {}
      sql_produtos = Produto.valido.
        where("produtos.created_at >= (?)", Time.now.beginning_of_day).
        where("EXISTS(SELECT TRUE FROM produtos as prod WHERE prod.descricao = produtos.descricao AND prod.codigo_mercado = 2
               AND prod.link_imagem LIKE '%_mini.jpg%' AND prod.created_at >= (?))", Time.now.beginning_of_day).
        where("EXISTS(SELECT TRUE FROM produtos as prod WHERE prod.descricao = produtos.descricao AND prod.codigo_mercado = 1
               AND prod.link_imagem LIKE '%_mini.jpg%' AND prod.created_at >= (?))", Time.now.beginning_of_day).
        where("preco = (SELECT MIN(prod.preco) FROM produtos AS prod WHERE prod.descricao = produtos.descricao)").order(:descricao).to_sql

      produtos = Produto.select("DISTINCT ON(descricao) *").from("(#{sql_produtos }) AS products").order(:descricao)
      produtos.where!("descricao ilike '%#{params[:filtros][:descricao].to_s.downcase}%'") if params[:filtros].present?
      produtos.paginate(page: params[:page], per_page: 18)
    end
  end
end
