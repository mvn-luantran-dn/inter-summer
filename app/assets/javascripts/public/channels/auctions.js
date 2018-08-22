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
      html += '<a href="#"><h3>'+ e.product_name +'</h3></a>';
      html += '<p><span id="countdowntimer" class="text-danger">'+ time_convert(e.period) + '</span></p>';
      html += '<span class= "last-bid-user rows"><img src="auctions.png" alt="' + e.product_name + '" class="icon-auction">' + formatMoney(e.product_price) + '</span>';
      html += '</div>'
      html += '</div>'
      html += '</div>'
    });
    $('#listauctions').html(html);
  }
});

$(document).on('turbolinks:load', function () {

});

function time_convert(num) {
  var sec_num = parseInt(num, 10);
  var hours = Math.floor(sec_num / 3600);
  var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
  var seconds = sec_num - (hours * 3600) - (minutes * 60);

  if (hours < 10) {
    hours = "0" + hours;
  }
  if (minutes < 10) {
    minutes = "0" + minutes;
  }
  if (seconds < 10) {
    seconds = "0" + seconds;
  }
  if (hours == 0) return minutes + ':' + seconds;
  return hours + ':' + minutes + ':' + seconds;
}
function formatMoney(number) {
  return number.toLocaleString('it-IT', {
    style: 'currency',
    currency: 'VND'
  });
}
