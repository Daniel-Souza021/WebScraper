class CarrinhosController < ApplicationController
  def index;end

  def busca_produtos
    @produtos = params['produtos'].present? ? Produto.busca_produtos_historicos({ historico: JSON.parse(params['produtos']) }) : []
  end
end