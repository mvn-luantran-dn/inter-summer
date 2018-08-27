$(document).on('turbolinks:load', function () {
  obj = document.querySelector('#cat_id');
  App.auctions = App.cable.subscriptions.create(
    { 
      channel: 'AuctionsChannel',
      check: obj,
    },{
    conntected: function () {
      swal.close()
    },
    disconnected: function () {
      swal(
        'Lost connection',
        'Please check again!',
        'warning'
      )
    },
    received: function(data) {
      if(obj){
        cat_id = obj.dataset.catId;
        html = "";
        list = data.obj;
        list.forEach(function (e) {
          if (e.product_category == cat_id) {
            html += '<div class="col-sm-6 col-md-3 ser">';
            html += '<div class="product-item thumbnail">';
            html += '<a href="/auctions/' + e.id + '"><img src="' + e.product_pictures[0].file_name.url + '" alt="' + e.product_name + '"></a>';
            html += '<div class="caption text-center">';
            html += '<a href="/auctions/' + e.id + '"><h3>' + e.product_name + '</h3></a>';
            html += '<p><span id="countdowntimer" class="text-danger">' + time_convert(e.period) + '</span></p>';
            html += '<span class= "last-bid-user rows"><img src="/auctions.png" alt="' + e.product_name + '" class="icon-auction">' + formatMoney(e.product_price_start) + '</span>';
            html += '</div>'
            html += '</div>'
            html += '</div>'
          }
        });
        $('#auction-categories').html(html);
      } else {
        html = "";
        finish = "";
        list = data.obj;
        list.forEach(function (e) {
          html += '<div class="col-sm-6 col-md-3 ser">';
          html += '<div class="product-item thumbnail">';
          html += '<a href="/auctions/' + e.id + '"><img src="' + e.product_pictures[0].file_name.url + '" alt="' + e.product_name + '"></a>';
          html += '<div class="caption text-center">';
          html += '<a href="/auctions/' + e.id + '"><h3>' + e.product_name + '</h3></a>';
          html += '<p><span id="countdowntimer" class="text-danger">' + time_convert(e.period) + '</span></p>';
          html += '<span class= "last-bid-user rows"><img src="/auctions.png" alt="' + e.product_name + '" class="icon-auction">' + formatMoney(e.product_price_start) + '</span>';
          html += '</div>'
          html += '</div>'
          html += '</div>'
          if(e.period < 20) {
            finish += '<div class="col-sm-6 col-md-3 ser">';
            finish += '<div class="product-item thumbnail">';
            finish += '<a href="/auctions/' + e.id + '"><img src="' + e.product_pictures[0].file_name.url + '" alt="' + e.product_name + '"></a>';
            finish += '<div class="caption text-center">';
            finish += '<a href="/auctions/' + e.id + '"><h3>' + e.product_name + '</h3></a>';
            finish += '<p><span id="countdowntimer" class="text-danger">' + time_convert(e.period) + '</span></p>';
            finish += '<span class= "last-bid-user rows"><img src="/auctions.png" alt="' + e.product_name + '" class="icon-auction">' + formatMoney(e.product_price_start) + '</span>';
            finish += '</div>'
            finish += '</div>'
            finish += '</div>'
          }
        });
        $('#listauctions').html(html);
        $('#listauctions-finish').html(finish);
      }
    }
  });
});
