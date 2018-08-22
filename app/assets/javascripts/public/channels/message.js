$(document).on('turbolinks:load', function () {
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
        price = data.obj;
        swal({
          title: 'Thông báo!',
          type: 'info',
          text: 'Bạn đang giữ giá ' + price + ' đ là giá cao nhất !',
          timer: 2000
        })
      }
    });
  } else {
    if (App.message != undefined) {
      App.message.unsubscribe()
    }
  }
});