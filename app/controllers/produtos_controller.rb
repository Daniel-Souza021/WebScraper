class ProdutosController < ApplicationController

  def index
    @produtos = Produto.all.mercado_moura.where(descricao: Produto.mercado_brasao.pluck(:descricao))
    @produtos = @produtos.paginate(page: params[:page], per_page: 18)
  end

  def filtrar
    @produtos = Produto.all.mercado_moura.where(descricao: Produto.mercado_brasao.pluck(:descricao))
    @produtos = @produtos.where("descricao ilike '%#{params['produto']['descricao'].to_s.downcase}%'")
    @produtos = @produtos.paginate(page: params[:page], per_page: 18)
  end

  private

  def produto_params
    params.require(:produto).permit(:descricao, :preco, :codigo_mercado, :link_imagem, :link_endereco)
  end
end
