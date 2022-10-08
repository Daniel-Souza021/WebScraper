class CreateProdutos < ActiveRecord::Migration[5.2]
  def change
    create_table :produtos do |t|
      t.string :descricao
      t.string :preco
      t.integer :mercado_id

      t.timestamps
    end
  end
end
