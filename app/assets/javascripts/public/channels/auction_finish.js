$(document).ready(function () {
  check = document.querySelector('#product_id');
  if (check) {
    App.auction_finish = App.cable.subscriptions.create( {
      channel: "AuctionFinishChannel",
      timer_id: check.dataset.timerId,
    },{
      connected: function() {
        swal.close()
      },
      disconnected :function() {
        swal(
          'Lost connection',
          'Please check again!',
          'warning'
        )
      },
      received: function(data) {
        current_id = auction.loadIdCurrentUser();
        if (current_id === data.obj['user_id']) {
          number = parseInt($('#itemCount').html()) + 1;
          $('#itemCount').html(number);
          // if (number == 1) {
          // } else {
          // }
          swal({
            html: 'Congratulations. You won the last auction.',
            type: 'info',
            timer: 10000
          })
        } else {
          swal({
            html: 'Oops!!! Better luck next time',
            type: 'info',
            timer: 10000
          })
        }
      } 
    });
  } else {
    if (App.auction_finish != undefined) {
      App.auction_finish.unsubscribe()
    }
  }
});
