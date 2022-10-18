class AddColumnsToProduto < ActiveRecord::Migration[5.2]
  def change
    add_column :produtos, :link_imagem, :string
    add_column :produtos, :link_endereco, :string

    rename_column :produtos, :mercado_id, :codigo_mercado
  end
end
