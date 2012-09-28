var TransactionWireItem = WireItem.extend({
  template: "wire_items/transaction-item",
  tagName: "li",
  className: "wire-item",

  initialize: function(options) {
    var self = this;
    this.model.on("destroy", function() { self.remove(); });
  },

    afterRender: function() {
    },

    publishedAt: function() { return timeAgoInWords(this.model.get('published_at')); },

    title: function() { return this.model.get('title'); },

    price: function() { return this.format(this.model.get('price')); },

    body: function() { return this.model.get('body'); },

    format: function(cents) {
      return '$' + (cents / 100.0).toFixed(2).toLocaleString();
    }
});
