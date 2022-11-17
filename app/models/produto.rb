class Produto < ApplicationRecord

  scope :mercado_brasao, -> { where codigo_mercado: 1 }
  scope :mercado_moura, -> { where codigo_mercado: 2 }
  scope :valido, -> { where "produtos.link_imagem LIKE ?", "%_mini.jpg%" }

  class << self

    def inserir_dados produtos
      produtos.each do |produto|
        Produto.create produto
      end
    end

    def busca_produtos params = {}
      produtos = connection.execute("
      DROP table IF EXISTS mercado1;
      DROP table IF EXISTS mercado2;
      DROP table IF EXISTS produtos_final;

      CREATE TEMP TABLE mercado1 AS
      select
      distinct on
      (descricao) descricao,
        created_at, codigo_mercado, preco, id
      from
      produtos
      where
      codigo_mercado = 1 and link_imagem LIKE '%_mini.jpg%'
      order by
      descricao,
        created_at desc, codigo_mercado, preco desc;

      CREATE TEMP TABLE mercado2 AS
      select
      distinct on
      (descricao) descricao,
        created_at,
        codigo_mercado, preco, id
      from
      produtos
      where
      codigo_mercado = 2 and link_imagem LIKE '%_mini.jpg%'
      order by
      descricao,
        created_at desc, codigo_mercado, preco desc;

      CREATE TEMP TABLE produtos_final AS
      (
        (select mercado1.* from mercado1
        join mercado2 on mercado2.descricao = mercado1.descricao)
        union all
        (select mercado2.* from mercado2
        join mercado1 on mercado1.descricao = mercado2.descricao)
      );

      select distinct on (descricao) preco, id
      from produtos_final
      order by
      descricao, preco asc;")

      produtos = Produto.where(id: produtos.values.map(&:last)).order(:descricao)
      produtos.where!("descricao ilike '%#{params[:filtros][:descricao].to_s.downcase}%'") if params[:filtros].present?
      produtos.where!(descricao: params[:historico]) if params[:historico].present?
      produtos.paginate(page: params[:page], per_page: 18)
    end

    def busca_produtos_historicos params = {}
      produtos = connection.execute("
      DROP table IF EXISTS mercado1;
      DROP table IF EXISTS mercado2;
      DROP table IF EXISTS produtos_final;

      CREATE TEMP TABLE mercado1 AS
      select
      distinct on
      (descricao) descricao,
        created_at, codigo_mercado, preco, id
      from
      produtos
      where
      codigo_mercado = 1 and link_imagem LIKE '%_mini.jpg%'
      order by
      descricao,
        created_at desc, codigo_mercado, preco desc;

      CREATE TEMP TABLE mercado2 AS
      select
      distinct on
      (descricao) descricao,
        created_at,
        codigo_mercado, preco, id
      from
      produtos
      where
      codigo_mercado = 2 and link_imagem LIKE '%_mini.jpg%'
      order by
      descricao,
        created_at desc, codigo_mercado, preco desc;

      CREATE TEMP TABLE produtos_final AS
      (
        (select mercado1.* from mercado1
        join mercado2 on mercado2.descricao = mercado1.descricao)
        union all
        (select mercado2.* from mercado2
        join mercado1 on mercado1.descricao = mercado2.descricao)
      );

      select id
      from produtos_final;")

      produtos = Produto.where(id: produtos.values.map(&:last)).order(:descricao)
      produtos.where!(descricao: params[:historico]) if params[:historico].present?
    end
  end
end
