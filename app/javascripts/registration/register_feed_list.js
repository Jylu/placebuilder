var RegisterFeedListView = CommonPlace.View.extend({
  template: "registration.feed",
  
  events: {
    "click a.continue": "submit"
  },
  
  afterRender: function() {
    this.appendFeedsList(this.options.communityExterior.feeds);
  },
  
  community_name: function() { return this.options.communityExterior.name; },
  
  submit: function(e) {
    if (e) { e.preventDefault(); }
    
    var feeds = _.map(this.$("input:checked"), function(feed) { return $(feed).val(); });
    CommonPlace.account.subscribeToFeed(feeds, _.bind(function() {
      this.options.nextPage("group");
    }, this));
  },
    
  appendFeedsList: function(feeds) {
    var $ul = this.$("ul.feeds_container");
    var referrer = this.options.referrer;
    
    _.each(feeds, _.bind(function(feed) {
      var itemView = new this.FeedItem({ model: feed });
      itemView.render();
      if (referrer && referrer.get("schema") == "feeds" && referrer.id == feed.id) {
        $ul.prepend(itemView.el);
        shownReferrer = true;
      } else {
        $ul.append(itemView.el);
      }
    }, this));
    
    this.options.slideIn(this.el);
  },
  
  FeedItem: CommonPlace.View.extend({
    template: "registration.feed-item",
    tagName: "li",
    
    events: { "click": "check" },
    
    initialize: function(options) { this.model = options.model; },
    
    avatar_url: function() { return this.model.avatar_url; },
    
    feed_id: function() { return this.model.id; },
    
    feed_name: function() { return this.model.name; },
    
    check: function(e) {
      if (e) { e.preventDefault(); }
      var $checkbox = this.$("input[type=checkbox]");
      if ($checkbox.attr("checked")) {
        $checkbox.removeAttr("checked");
      } else {
        $checkbox.attr("checked", "checked");
      }
    }
  })
});
