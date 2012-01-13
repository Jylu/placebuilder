
var CommunityResources = CommonPlace.View.extend({
  template: "main_page.community-resources",
  id: "community-resources",
  
  afterRender: function() {
    var self = this;
    this.searchForm = new CommunitySearchForm();
    this.searchForm.render();
    $(this.searchForm.el).prependTo(this.$(".sticky"));
    $(window).scroll(function() { self.stickHeader(); });
  },

  switchTab: function(tab) {
    var self = this;
    
    this.$(".tab-button").removeClass("current");
    this.$("." + tab).addClass("current");

    this.view = this.tabs[tab](this, function() {
      (self.currentQuery) ? self.search() : self.showTab();
    });
  },
  
  showTab: function() {
    this.$(".resources").empty();
    this.unstickHeader();
    this.countdown = 0;
    
    _.each(this.view.resources(), function(wire) {
      wire.render();
      $(wire.el).appendTo(this.$(".resources"));
    });
  },
  
  makeTab: function(wire, callback) {
    return new ResourceTab({
      wire: wire,
      callback: callback
    });
  },

  tabs: {
    landing: function(self) { return new DynamicLandingResources(); },
    
    posts: function(self) {
      var wire = new ResourceWire({
        template: "main_page.post-resources",
        emptyMessage: "No posts here yet.",
        collection: CommonPlace.community.posts,
        callback: function() { self.stickHeader(); }
      });
      return self.makeTab(wire, callback);
    },
    
    events: function(self) {
      var wire = new ResourceWire({
        template: "main_page.event-resources",
        emptyMessage: "No events here yet.",
        collection: CommonPlace.community.events,
        callback: function() { self.stickHeader(); }
      });
      return self.makeTab(wire, callback);
    },
    
    announcements: function(self) {
      var wire = new ResourceWire({
        template: "main_page.announcement-resources",
        emptyMessage: "No announcements here yet.",
        collection: CommonPlace.community.announcements,
        callback: function() { self.stickHeader(); }
      });
      return self.makeTab(wire, callback);
    },
    
    group_posts: function(self, callback) {
      var wire = new self.ResourceWire({
        template: "main_page.group-post-resources",
        emptyMessage: "No posts here yet.",
        collection: CommonPlace.community.groupPosts,
        callback: function() { self.stickHeader(); }
      });
      return self.makeTab(wire, callback);
    },
    
    groups: function(self) {
      var wire = new ResourceWire({
        template: "main_page.directory-resources",
        emptyMessage: "No groups here yet.",
        collection: CommonPlace.community.groups,
        callback: function() { self.stickHeader(); },
        active: "groups"
      });
      return self.makeTab(wire, callback);
    },
    
    feeds: function(self) {
      var wire = new ResourceWire({
        template: "main_page.directory-resources",
        emptyMessage: "No feeds here yet.",
        collection: CommonPlace.community.feeds,
        callback: function() { self.stickHeader(); },
        active: "feeds"
      });
      return self.makeTab(wire, callback);
    },
    
    users: function(self) {
      var wire = new ResourceWire({
        template: "main_page.directory-resources",
        emptyMessage: "No users here yet.",
        collection: CommonPlace.community.users,
        callback: function() { self.stickHeader(); },
        active: "users"
      });
      return self.makeTab(wire, callback);
    }
  },
  
  ResourceWire: Wire.extend({
    _defaultPerPage: 15
  }),
  
  // single item view overhaul is yet to be determined

  /**showPost: function(post) {
    this.showSingleItem(post, GroupPostWireItem);
  },
  showAnnouncement: function(announcement) {
    this.showSingleItem(announcement, AnnouncementWireItem);
  },
  showEvent: function(event) {
    this.showSingleItem(event, EventWireItem);
  },
  showGroupPost: function(groupPost) {
    this.showSingleItem(groupPost, GroupPostWireItem);
  },

  showSingleItem: function(model, ItemView) {
    var self = this;
    model.fetch({
      success: function(model) {
        var item = new ItemView({model: model, account: self.options.account});

        self.$(".tab-button").removeClass("current");

        item.render();

        self.$(".resources").html($("<div/>", { 
          "class": "wire",
          html: $("<ul/>", {
            "class": "wire-list",
            html: item.el
          })
        }));
      }
    });
  }**/
  
  debounceSearch: _.debounce(function() {
    this.search();
  }, CommonPlace.autoActionTimeout),
  
  search: function(event) {
    if (event) { event.preventDefault(); }
    this.currentQuery = this.$(".sticky form.search input").val();
    this.view.search(this.currentQuery);
  },
  
  cancelSearch: function(e) {
    this.view.cancelSearch();
  },
  
  stickHeader: function(ready) {
    if (!this._ready) {
      this.countdown++;
      this._ready = (this.countdown == this.view.resources().length);
      return;
    }
    
    var landing_top = this.$(".resources").offset().top + $(window).scrollTop();
    var landing_bottom = landing_top + this.$(".sticky .header").height();
    var wires_below_header = this.view.resources();
    
    if (!this.$(".sticky .header").height()) {
      landing_bottom += _.first(wires_below_header).header.height();
    }
    
    wires_below_header = _.filter(wires_below_header, function(wire) {
      var wire_bottom = $(wire.el).offset().top + $(wire.el).height();
      return wire_bottom >= landing_bottom;
    });
    
    var top_wire = _.sortBy(wires_below_header, function(wire) {
      return $(wire.el).offset().top;
    }).shift();
    
    if (top_wire != this.headerWire) {
      this.unstickHeader();
      var sticky = top_wire.header.clone(true);
      sticky.appendTo(this.$(".sticky .header"));
      this.headerWire = top_wire;
    }
  },
  
  unstickHeader: function() { this.$(".sticky .header").empty(); }
  
});

var ResourceTab = CommonPlace.View.extend({
  initialize: function(options) {
    this._wires = [];
    this._wires.push(options.wire);
    options.callback();
  },
  
  resources: function() { return this._wires; },
  
  search: function(query) {
    _.each(this._wires, function(wire) {
      wire.currentQuery = query;
    });
  },
  
  cancelSearch: function() { this.search(""); }
});

var CommunitySearchForm = CommonPlace.View.extend({
  template: "main_page.community-search-form",
  tagName: "form",
  className: "search"
});
