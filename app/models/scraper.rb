class Scraper
  URLS = {
    (BRASAO_CENTRO = 1) => "https://www.sitemercado.com.br/brasaochapeco/chapeco-loja-fernando-machado-centro-rua-fernando-machado",
    (MOURA_BAIRRO = 2) => "https://www.sitemercado.com.br/mourasupermercados/chapeco-loja-sao-cristovao-sao-cristovao-av-sao-pedro"
  }

  class << self

    def extrair_dados
      enderecos_sites = busca_endereco_sites
      pesquisas_chaves = busca_pesquisas_chaves
      produtos = []

      enderecos_sites.each do |codigo_mercado, endereco_site|
        pesquisas_chaves.each do |pesquisa_chave|
          browser = Watir::Browser.new(:chrome, {headless: true})
          browser.goto "#{endereco_site}/busca/#{pesquisa_chave}"

          25.times do
            sleep(0.10)
            browser.execute_script script_scroll_page
          end

          html_analisado = Nokogiri::HTML.parse(browser.html)
          lista_produtos = html_analisado.css("app-list-product-item.content-dailySale-list-products-product")

          lista_produtos.each do |lista_produto|
            produtos << {
              codigo_mercado: codigo_mercado,
              descricao: lista_produto.search('h3').text,
              preco: trata_preco(lista_produto.search('div.area-bloco-preco').text),
              link_imagem: "https:#{lista_produto.search('img').attr('src').text}",
              link_endereco: "https://www.sitemercado.com.br/#{lista_produto.search('div a').attr('href').text}"
            }
          end

          browser.close
          sleep(0.2)
        end
      end

      Produto.inserir_dados produtos
    end

    private

    def trata_preco preco
      preco.match(/\d+.\d+/).to_s.gsub(',', '.')
    end

    def busca_endereco_sites urls = {}
      urls[Scraper::BRASAO_CENTRO] = Scraper::URLS[Scraper::BRASAO_CENTRO]
      urls[Scraper::MOURA_BAIRRO] = Scraper::URLS[Scraper::MOURA_BAIRRO]
      urls
    end

    def busca_pesquisas_chaves
      %w[arroz]
    end

    def script_scroll_page
      "window.scrollTo(0, document.body.scrollHeight);"
    end
  end
end

