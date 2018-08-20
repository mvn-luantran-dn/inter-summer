$(document).on('turbolinks:load', function () {
  check = document.querySelector('#product_id');
  if (check) {
    App.auction_detail = App.cable.subscriptions.create(
      {
        channel: 'AuctionDetailChannel',
        timer_id: check.dataset.timerId,
      },
      {
        connected: function(data){
        },
        received: function(data) {
          data = data.obj;
          $('#spanCountDown').html(time_convert(data.period));
          $('#ContentPlaceHolder1_lbTitle').html(data.product_name);
          $('#product-price').html(formatMoney(data.product_price));
          $('#detail-product').html(data.product_detail);
          $('#first-image').html('<img src="' + data.product_pictures[0].file_name.url + '" alt="' + data.product_name + ' class="slow-images" style="max-width: 100%;border-bottom: 1px solid #ccc;border-right: 1px solid #ccc;"">');
          html = "";
          data.product_pictures.forEach(function (e) {
             html += '<li class="product_thumb"><img class="slow-images" src="' + e.file_name.url + '"></li>';
          });
          $('#js-gallery').html(html);
        }
    });
  }
});
