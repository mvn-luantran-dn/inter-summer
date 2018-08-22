$(document).on('turbolinks:load', function () {
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
        if (current_id === data.obj) {
          swal({
            html: '',
            timer: 10000
          })
        } else {
          swal({
            html: '<img src="/assets/tear-6f754a657a179' +
              'fe8b497562db896006fc90812af94443b1210' +
              '0a2ae86a07789d.png"><br><br>' +
              'Rất tiếc , bạn không phải ' +
              'người thắng cuộc trong ' +
              'phiên đấu giá này !<br> Nhưng ' +
              'không sao cả, hãy bắt đầu lại nào !<br>' +
              'Thông báo này sẽ được đóng trong 10 giây' +
              ', chuyển bạn sang phiên đấu giá mới !',
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