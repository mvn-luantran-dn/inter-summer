$(document).on('turbolinks:load', function () {
  check = document.querySelector('#product_id');
  if (check) {
    App.bid = App.cable.subscriptions.create( {
      channel: "BidChannel",
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
        html = "";
        data.obj.forEach(function (e) {
          html += '<li class="history_rows odd">';
          html += '<span class="bid_user current_winner pro_user">' + e['name'] + '</span>';
          html += '<span class="bid_amount">' + e['price_bid'] + '</span>';
          html += '<span class="bid_time">' + e['created_at'] + '</span>';
          html += '</li>';
        });
        $('#bid-final').html(html);
        $('#user-winner').html(data.obj[0]['name']);
      } 
    });
  } else {
    if (App.bid != undefined) {
      App.bid.unsubscribe();
    }
  }
});