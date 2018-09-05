$(document).ready(function () {
  check = document.querySelector('#product_id');
  if (check) {
    App.auction_detail = App.cable.subscriptions.create(
      {
        channel: 'AuctionDetailChannel',
        timer_id: check.dataset.timerId,
      },
      {
        conntected: function () {
          auction.connected();
        },
        disconnected: function () {
          auction.disconnected();          
        },
        received: function(data) {
          auction.load_detail(data);
        }
    });
  } else {
      if(App.auction_detail != undefined) {
      App.auction_detail.unsubscribe()
    }
  }
});
