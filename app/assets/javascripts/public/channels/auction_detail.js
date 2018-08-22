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
          // $('#first-image').html('<img id="js-ContentPlaceHolder1_imgProductPhoto" class="slow-images" data-zoom-image="' + data.product_pictures[0].file_name.url + '" src="' + data.product_pictures[0].file_name.url +'" style="max-width: 100%;border-bottom: 1px solid #ccc;border-right: 1px solid #ccc;">')
          // $('#js-gallery').html('<li><a href="#" id="ContentPlaceHolder1_aProduct1" class="product_thumb img72 active" data-image="' + data.product_pictures[0].file_name.url + '" data-zoom-image="' + data.product_pictures[0].file_name.url + '"><img id="ContentPlaceHolder1_imgGallery1" class="slow-images" src="' + data.product_pictures[0].file_name.url + '"></a></li><li><a href="#" id="ContentPlaceHolder1_aProduct2" class="product_thumb img72" data-image="' + data.product_pictures[1].file_name.url + '" data-zoom-image="' + data.product_pictures[1].file_name.url + '"><img id="ContentPlaceHolder1_imgGallery2" class="slow-images" src="' + data.product_pictures[1].file_name.url + '"></a></li><li><a href="#" id="ContentPlaceHolder1_aProduct3" class="product_thumb img72" data-image="' + data.product_pictures[2].file_name.url + '" data-zoom-image="' + data.product_pictures[2].file_name.url + '"><img id="ContentPlaceHolder1_imgGallery3" class="slow-images" src="' + data.product_pictures[2].file_name.url + '"></a></li><li></li><li></li>')


          // html = "";
          // data.product_pictures.forEach(function (e) {
          //    html += '<div class="item active"><img src="' + e.file_name.url +'" alt="" style="width:100%;"></div>';
          // });
          // $('#first-image').html(html);
 
        }
    });
  }
});
