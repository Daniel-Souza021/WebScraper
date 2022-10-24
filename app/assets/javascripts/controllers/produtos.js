$(function () {
    $(document).delegate(".btn-success", 'click', function () {
        var produtos = JSON.parse(localStorage.getItem('produtos')),
            produto = $(this).closest('.thumbnail').data('produto');
        if (!produtos) produtos = [];
        if (!produtos.includes(produto)) produtos.push(produto);

        localStorage.setItem('produtos', JSON.stringify(produtos));
        $(this).closest('.thumbnail').find('.btn-danger').removeClass('hide');
        $(this).addClass('hide');
    });

    $(document).delegate(".btn-danger", 'click', function () {
        var produtos = JSON.parse(localStorage.getItem('produtos')),
            produto = $(this).closest('.thumbnail').data('produto');
        if (!produtos) produtos = [];
        if (produtos.includes(produto)) produtos = produtos.filter(item => item !== produto);

        localStorage.setItem('produtos', JSON.stringify(produtos));
        $(this).closest('.thumbnail').find('.btn-success').removeClass('hide');
        $(this).addClass('hide');
    });

    $('.thumbnail').each(function(){
        if(JSON.parse(localStorage.getItem('produtos')).includes($(this).data('produto'))) {
            $(this).find('.btn-danger').removeClass('hide');
            $(this).find('.btn-success').addClass('hide');
        }
    })

    $(document).delegate(".historico", 'click', function () {
        $.ajax({
            method: 'POST',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            url: root_url + 'produtos/historico',
            data: {produto: $(this).data('produto')},
            success: function () {
                $("#staticBackdrop").modal('show');
            }
        })
    })

});