class CarrinhosController < ApplicationController
  def index

  end

  def busca_produtos
    if params['produtos'].present?
      @produtos = Produto.valido.select(
        "DISTINCT ON(descricao, codigo_mercado)
      descricao,
      preco,
      codigo_mercado,
      link_imagem,
      link_endereco").where(descricao: JSON.parse(params['produtos'])).where(created_at: Date.today.all_day)
    else
      @produtos = []
    end
  end
end