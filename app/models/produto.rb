class Produto < ApplicationRecord

  scope :mercado_brasao, -> { where codigo_mercado: 1 }
  scope :mercado_moura, -> { where codigo_mercado: 2 }
  scope :valido, -> { where "produtos.link_imagem ILIKE ?", "%_mini.jpg%" }

  class << self

    def inserir_dados produtos
      produtos.each do |produto|
        Produto.create produto
      end
    end
  end
end
