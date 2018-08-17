App.auctions = App.cable.subscriptions.create('AuctionsChannel', {
  connected: function(data){
    console.log('luan')
  },
  received: function(data) {
  }
});
