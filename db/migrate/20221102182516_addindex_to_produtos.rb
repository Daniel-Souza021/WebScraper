class AddindexToProdutos < ActiveRecord::Migration[5.2]
  def change
    add_index :produtos, :descricao
  end
end
