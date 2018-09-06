$(document).ready(function () {
  check = document.querySelector('#product_id');
  if (check) {
    App.message = App.cable.subscriptions.create({
      channel: "MessageChannel",
      timer_id: check.dataset.timerId,
    }, {
      connected: function () {
        swal.close()
      },
      disconnected: function () {
        swal(
          'Lost connection',
          'Please check again!',
          'warning'
        )
      },
      received: function (data) {
        current_id = auction.loadIdCurrentUser();
        user_notice = data.obj['user_id'];
        price = data.obj['price_bid'];
        if (current_id === user_notice) {
          swal({
            title: 'Notification !',
            type: 'info',
            text: 'You are still keepping ' + price + ' đ is max price !',
            timer: 2000
          })
        }
      }
    });
  } else {
    if (App.message != undefined) {
      App.message.unsubscribe()
    }
  }
});
