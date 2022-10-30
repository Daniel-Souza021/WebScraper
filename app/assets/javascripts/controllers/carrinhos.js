$(document).ready(function () {
    $.ajax({
        method: 'POST',
        beforeSend: function (xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        },
        data: {produtos: localStorage.getItem('produtos')},
        url: root_url + 'carrinhos/busca_produtos'
    });


    $(document).delegate("#limpar-carrinho", 'click', function () {
        localStorage.removeItem('produtos');
        window.location.reload();
    });
});