$(document).on('turbolinks:load', function () {
  check = document.querySelector('#product_id');
  if (check) {
    App.auction_detail = App.cable.subscriptions.create(
      {
        channel: 'AuctionDetailChannel',
        timer_id: check.dataset.timerId,
      },
      {
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
          data = data.obj;
          $('#spanCountDown').html(time_convert(data.period));
          $('#product-price').html(formatMoney(data.product_price_start));
        }
    });
  } else {
      if(App.auction_detail != undefined) {
      App.auction_detail.unsubscribe()
    }
  }
});
