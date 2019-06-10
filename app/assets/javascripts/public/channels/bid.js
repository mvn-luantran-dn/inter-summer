$(document).ready(function () {
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
        $.each(data.obj, function (index, e) {
          html += '<li class="history_rows odd">';
          if(index == 0) {
            html += '<span class="bid_user current_winner pro_user">' + '<i class="fa fa-trophy" aria-hidden="true"></i> ' + e['name'] + '</span>';
          } else {
            html += '<span class="bid_user current_winner pro_user">' + e['name'] + '</span>';            
          }
          html += '<span class="bid_amount">' + formatMoney(e['price_bid']) + '</span>';
          html += '<span class="bid_time">' + e['updated_at'] + '</span>';
          html += '</li>';
        });
        $('#bid-final').html(html);
        $('#user-winner').html('<i class="fa fa-trophy" aria-hidden="true"></i> ' + data.obj[0]['name']);
      } 
    });
  } else {
    if (App.bid != undefined) {
      App.bid.unsubscribe();
    }
  }
});
