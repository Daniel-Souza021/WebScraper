class ProdutosController < ApplicationController
  before_action :filtrar, only: :index

  def index
    produtos = busca_produtos
    @produtos = produtos.paginate(page: params[:page], per_page: 18)
  end

  def filtrar
    produtos = busca_produtos
    produtos.where!("descricao ilike '%#{params['produto']['descricao'].to_s.downcase}%'") if params['produto'].present?
    @produtos = produtos.paginate(page: params[:page], per_page: 18)
  end

  private

  def produto_params
    params.require(:produto).permit(:descricao, :preco, :codigo_mercado, :link_imagem, :link_endereco)
  end

  def busca_produtos
      produto = Produto.valido.select(
      "descricao,
       MIN(preco) AS preco,
       link_imagem,
       link_endereco,
      codigo_mercado,
      created_at").
      where(descricao: Produto.mercado_brasao.pluck(:descricao)).
      where(created_at: Date.today.all_day).group(:id, :descricao, :link_imagem, :link_endereco, :codigo_mercado, :created_at)

    produto.where!("preco = (SELECT MIN(prod.preco) FROM produtos AS prod WHERE prod.descricao = produtos.descricao)")
    produto.where!(descricao: Produto.mercado_moura.pluck(:descricao))
  end
end
