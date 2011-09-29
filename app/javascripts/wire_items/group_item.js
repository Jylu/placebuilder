var GroupWireItem = WireItem.extend({
  template: "wire_items/feed-item",
  tagName: "li",
  className: "wire-item",

  initialize: function() {
    this.options.account.bind("change", this.render, this);
  },

  events: {
    "mouseenter": "showProfile",
    "click button.subscribe": "subscribe",
    "click button.unsubscribe": "unsubscribe"
  },

  avatarUrl: function() {
    return this.model.get("avatar_url");
  },

  name: function() {
    return this.model.get("name");
  },

  showProfile: function(e) {
    window.infoBox.showProfile(this.model);
  },

  subscribe: function() { this.options.account.subscribeToGroup(this.model); },

  unsubscribe: function() { this.options.account.unsubscribeFromGroup(this.model); },

  isSubscribed: function() { return this.options.account.isSubscribedToGroup(this.model); }


});
