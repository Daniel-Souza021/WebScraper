json.extract! produto, :id, :descricao, :preco, :codigo_mercado, :link_imagem, :link_endereco, :created_at, :updated_at
json.url produto_url(produto, format: :json)
