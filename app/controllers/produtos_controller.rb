class ProdutosController < ApplicationController

  def index
    produtos = busca_produtos
    @produtos = produtos.paginate(page: params[:page], per_page: 18)
  end

  def filtrar
    produtos = busca_produtos
    produtos.where!("descricao ilike '%#{params['produto']['descricao'].to_s.downcase}%'")
    @produtos = produtos.paginate(page: params[:page], per_page: 18)
  end

  private

  def produto_params
    params.require(:produto).permit(:descricao, :preco, :codigo_mercado, :link_imagem, :link_endereco)
  end

  def busca_produtos
    Produto.valido.mercado_brasao.where(descricao: Produto.mercado_moura.pluck(:descricao))
  end
end
