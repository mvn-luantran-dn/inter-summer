$(document).ready(function () {
  check = document.querySelector('#user-notif');
  if (check) {
    addEventChangeStatus(check.dataset.userId);
    App.notification = App.cable.subscriptions.create({
      channel: "NotificationChannel",
      user_id_notif: check.dataset.userId,
    },
     {
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
        if(data.obj[0].user_id === current_id){
          $('#quantity-notify').show();
          number = parseInt($('#quantity-notify').html()) + 1;
          $('#quantity-notify').html(number);
          list = data.obj;
          html = "";
          list.forEach(function (e) {
            if(e.status == 1){
              html += "<li class='notif-item'>";
              html += "<a href='/auctions/" + e.timer_id + "'>";
              html += "<div class='content-notif'>";
              html += "<div>" + e.content + "</div>";
              html += "<div class='content-right'>" + e.created_at + "</div>";
              html += "</div>";
              html += "</a>";
              html += "</li>";
            } else {
              html += "<li class='notif-item'>";
              html += "<a href='/auctions/" + e.timer_id + "'>";
              html += "<div>";
              html += "<div>" + e.content + "</div>";
              html += "<div class='content-right'>" + e.created_at + "</div>";
              html += "</div>";
              html += "</a>";
              html += "</li>";
            }
          });
          $('#list-notif').html(html);
        }
      }
    });
  } else {
    if (App.notification != undefined) {
      App.notification.unsubscribe()
    }
  }
});
