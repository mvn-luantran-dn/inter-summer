App.auctions = App.cable.subscriptions.create('AuctionsChannel', {
  connected: function(data){
  },
  received: function(data) {
    html = "";
    list = data.obj;
    list.forEach(function (e) {
      html += '<div class="col-sm-6 col-md-3 ser">';
      html += '<div class="product-item thumbnail">';
      html += '<img src="' + e.product_pictures[0].file_name.url + '" alt="' + e.product_name + '">';
      html += '<div class="caption text-center">';
      html += '<a href="/auctions/'+ e.id +'"><h3>'+ e.product_name +'</h3></a>';
      html += '<p><span id="countdowntimer" class="text-danger">'+ time_convert(e.period) + '</span></p>';
      html += '<span class= "last-bid-user rows"><img src="auctions.png" alt="' + e.product_name + '" class="icon-auction">' + formatMoney(e.product_price) + '</span>';
      html += '</div>'
      html += '</div>'
      html += '</div>'
    });
    $('#listauctions').html(html);
  }
});
