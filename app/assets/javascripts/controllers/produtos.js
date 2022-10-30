$(function () {
    $(document).delegate(".adiciona-carrinho", 'click', function () {
        var produtos = JSON.parse(localStorage.getItem('produtos')),
            produto = $(this).closest('.thumbnail').data('produto');
        if (!produtos) produtos = [];
        if (!produtos.includes(produto)) produtos.push(produto);

        localStorage.setItem('produtos', JSON.stringify(produtos));
        $(".badge-pill").text(produtos.length);
        $(this).closest('.thumbnail').find('.remove-carrinho').removeClass('hide');
        $(this).addClass('hide');
    });

    $(document).delegate(".remove-carrinho", 'click', function () {
        var produtos = JSON.parse(localStorage.getItem('produtos')),
            produto = $(this).closest('.thumbnail').data('produto');
        if (!produtos) produtos = [];
        if (produtos.includes(produto)) produtos = produtos.filter(item => item !== produto);

        localStorage.setItem('produtos', JSON.stringify(produtos));
        $(".badge-pill").text(produtos.length);
        $(this).closest('.thumbnail').find('.adiciona-carrinho').removeClass('hide');
        $(this).addClass('hide');
    });

    $('.thumbnail').each(function () {
        var produtos = JSON.parse(localStorage.getItem('produtos'));
        if (produtos) {
            $(".badge-pill").text(produtos.length);
            if (produtos.includes($(this).data('produto'))) {
                $(this).find('.remove-carrinho').removeClass('hide');
                $(this).find('.adiciona-carrinho').addClass('hide');
            }
        }
    });

    $(document).delegate(".historico", 'click', function () {
        $.ajax({
            method: 'POST',
            beforeSend: function (xhr) {
                xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
            },
            url: root_url + 'produtos/historico',
            data: {produto: $(this).data('produto')},
            success: function () {
                $("#staticBackdrop").modal('show');
            }
        })
    });
});