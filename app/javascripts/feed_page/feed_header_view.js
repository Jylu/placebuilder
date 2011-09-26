
var FeedHeaderView = CommonPlace.View.extend({
  template: "feed_page/feed-header",
  id: "feed-header",
  initialize: function(options) { 
    this.account = options.account; 
  },

  events: {
    "click a.subscribe": "subscribe",
    "click a.unsubscribe": "unsubscribe"
  },

  isSubscribed: function() {
    return this.account.isSubscribedToFeed(this.model);
  },

  isOwner: function() {
    return this.account.isFeedOwner(this.model);
  },

  editURL: function() {
    return "/feeds/" + this.model.id + "/edit";
  },

  subscribe: function(e) {
    var self = this;
    e.preventDefault();
    this.account.subscribeToFeed(this.model, function() { self.render(); });
  },
  
  unsubscribe: function(e) {
    var self = this;
    e.preventDefault();
    this.account.unsubscribeFromFeed(this.model, function() { self.render(); });
  },

  feedName: function() { return this.model.get('name'); }
     
});