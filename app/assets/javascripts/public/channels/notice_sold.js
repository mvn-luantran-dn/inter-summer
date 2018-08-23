$(document).on('turbolinks:load', function () {
  check = document.querySelector('#product_id');
  if (check) {
    App.notice_sold = App.cable.subscriptions.create({
      channel: "NoticeSoldChannel",
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
        console.log(data);
        swal({
          title: 'Notification !',
          type: 'info',
          text: 'Sold out',
        })
        setTimeout(function () {
          window.location = "http://localhost:3000/";
        }, 3000)
      }
    });
  } else {
    if (App.notice_sold != undefined) {
      App.notice_sold.unsubscribe()
    }
  }
});