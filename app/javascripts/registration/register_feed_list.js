var RegisterFeedListView = RegistrationModalPage.extend({
  template: "registration.home_feed",
  
  feed_kinds: [
    "Non-profit",
    "Community Group",
    "Business",
    "Municipal",
    "News",
    "Other"
  ],

  events: {
    "click input.continue": "submit",
    "submit form": "submit",
    "click .next-button": "submit"
  },

  afterRender: function() {
    var feeds = this.communityExterior.feeds;
    var $ul = this.$("ul.feeds_container");
    
    _.each(feeds, _.bind(function(feed) {
      var itemView = new this.FeedItem({ model: feed });
      itemView.render();
      category = "#" + this.feed_kinds[feed.kind];
      this.$(category).append(itemView.el);
    }, this));
    
    this.slideIn(this.el);
    
    var height = 0;
    this.$(".feeds_container li").each(function(index) {
      if (index == 4) { return false; }
      height = height + $(this).outerHeight(true);
    });
    this.$("ul").height(height + "px");
  },
  
  community_name: function() { return this.communityExterior.name; },
  categories: function() { return this.feed_kinds; },
  
  submit: function(e) {
    if (e) { e.preventDefault(); }
    
    var feeds = _.map(this.$("input[name=feeds_list]:checked"), function(feed) { return $(feed).val(); });
    if (_.isEmpty(feeds)) {
      this.finish();
    } else {
      CommonPlace.account.subscribeToFeed(feeds, _.bind(function() { this.finish(); }, this));
    }
  },
  
  finish: function() {
    this.nextPage("group", this.data);
  },
  
  FeedItem: CommonPlace.View.extend({
    template: "registration.home_feed-item",
    tagName: "li",
    
    events: { "click": "check" },
    
    initialize: function(options) { this.model = options.model; },
    
    avatar_url: function() { return this.model.avatar_url; },
    
    feed_id: function() { return this.model.id; },
    
    feed_name: function() { return this.model.name; },
   
    feed_about: function() { return this.model.about; },

    check: function(e) {
      if (e) { e.preventDefault(); }
      var $checkbox = this.$("input[type=checkbox]");
      if ($checkbox.attr("checked")) {
        $checkbox.removeAttr("checked");
        this.$(".check").removeClass("checked");
      } else {
        $checkbox.attr("checked", "checked");
        this.$(".check").addClass("checked");
      }
    }
  })
});
