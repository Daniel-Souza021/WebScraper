class Produto < ApplicationRecord
  class << self

    def inserir_dados produtos
      produtos.each do |produto|
          Produto.create produto
        end
      end
    end
  end
