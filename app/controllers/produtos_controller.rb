class ProdutosController < ApplicationController
  def index
    produtos = busca_produtos
    @produtos = produtos.paginate(page: params[:page], per_page: 18)
  end

  def filtrar
    produtos = busca_produtos
    produtos.where!("descricao ilike '%#{params['produto']['descricao'].to_s.downcase}%'") if params['produto'].present?
    @produtos = produtos.paginate(page: params[:page], per_page: 18)
  end

  def historico
    @historico_produto = Produto.valido.where(descricao: params['produto'])
  end

  private

  def produto_params
    params.require(:produto).permit(:descricao, :preco, :codigo_mercado, :link_imagem, :link_endereco)
  end

  def busca_produtos
    produtos = Produto.valido.select(
      "DISTINCT ON(descricao, codigo_mercado) *").
      where(created_at: Date.today.all_day).
      where("EXISTS(SELECT TRUE FROM produtos as prod WHERE prod.descricao = produtos.descricao AND prod.codigo_mercado = 2
AND prod.link_imagem ILIKE '%_mini.jpg%' AND prod.created_at >= (?))", Time.now.beginning_of_day).
      where("EXISTS(SELECT TRUE FROM produtos as prod WHERE prod.descricao = produtos.descricao AND prod.codigo_mercado = 1
AND prod.link_imagem ILIKE '%_mini.jpg%' AND prod.created_at >= (?))", Time.now.beginning_of_day).
      where("preco = (SELECT MIN(prod.preco) FROM produtos AS prod WHERE prod.descricao = produtos.descricao)").order(:descricao).to_sql

    Produto.select("DISTINCT ON(descricao) *").from("(#{produtos }) AS products").order(:descricao)
  end
end
