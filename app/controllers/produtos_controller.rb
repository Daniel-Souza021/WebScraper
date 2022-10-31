class ProdutosController < ApplicationController
  def index
    @produtos = Produto.busca_produtos params.merge({filtros: {descricao: session[:filtros]["produtos#filtrar"]}})
  end

  def filtrar
    @produtos = Produto.busca_produtos params
  end

  def historico
    @historico_produto = Produto.valido.where(descricao: params['produto'])
  end
end
