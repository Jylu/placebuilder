var LandingResources = CommonPlace.View.extend({ 
  template: "main_page.landing-resources",
  className: "resources",

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
  },

  afterRender: function() {
    this._sortCountdown = 0;
    _(this.wires()).invoke("render");
    setTimeout(function() {
      if (Features.isActive("fixedLayout")) {
        // by removing zindex of the underneath subnav, we may be able to avoid this
        $('form.search').detach().appendTo($('.landing-resources'));
      }
    }, 50);
  },

  wires: function() {
    var self = this;
    var postsCollection;
    if (self.options.community.get('locale') == "college") {
      postsCollection = self.options.account.neighborhoodsPosts();
    } else {
      postsCollection = self.options.community.posts;
    }
    if (!this._wires) {
      this._wires = [
        (new PreviewWire({
          template: 'main_page.post-resources',
          collection: CommonPlace.community.categories.neighborhood,
          account: this.account,
          el: this.$(".neighborhoodPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No posts here yet.",
          isRecent: true,
          itemView: PostWireItem,
          callback: function() { self.sortWires(); },
          modelToView: function(model) {
            return new PostWireItem({ model: model, account: self.options.account });
          }
        })),
        
        (new PreviewWire({
          template: 'main_page.post-offer-resources',
          collection: CommonPlace.community.categories.offers,
          account: this.account,
          el: this.$(".offerPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No offers here yet.",
          isRecent: true,
          callback: function() { self.sortWires(); },
          modelToView: function(model) {
            return new PostWireItem({ model: model, account: self.options.account });
          }
        })),
        
        (new PreviewWire({
          template: 'main_page.post-help-resources',
          collection: CommonPlace.community.categories.help,
          account: this.account,
          el: this.$(".helpPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No help requests here yet.",
          isRecent: true,
          callback: function() { self.sortWires(); },
          modelToView: function(model) {
            return new PostWireItem({ model: model, account: self.options.account });
          }
        })),
        
        (new PreviewWire({
          template: 'main_page.post-publicity-resources',
          collection: CommonPlace.community.categories.publicity,
          account: this.account,
          el: this.$(".publicityPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No posts here yet.",
          isRecent: true,
          callback: function() { self.sortWires(); },
          modelToView: function(model) {
            return new PostWireItem({ model: model, account: self.options.account });
          }
        })),
        
        (new PreviewWire({
          template: 'main_page.post-other-resources',
          collection: CommonPlace.community.categories.other,
          account: this.account,
          el: this.$(".otherPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No posts here yet.",
          isRecent: true,
          callback: function() { self.sortWires(); },
          modelToView: function(model) {
            return new PostWireItem({ model: model, account: self.options.account });
          }
        })),
        
        (new PreviewWire({
          template: 'main_page.event-resources',
          collection: this.community.events,
          account: this.account,
          el: this.$(".events.wire"),
          fullWireLink: "#/events",
          emptyMessage: "There are no upcoming events yet. Add some.",
          isRecent: true,
          itemView: EventWireItem,
          callback: function() { self.sortWires(); },
          modelToView: function(model) {
            return new EventWireItem({ model: model, account: self.options.account });
          }
        })),
        
        (new PreviewWire({
          template: 'main_page.announcement-resources',
          collection: this.community.announcements,
          account: this.account,
          el: this.$(".announcements.wire"),
          emptyMessage: "No announcements here yet.",
          fullWireLink: "#/announcements",
          isRecent: true,
          itemView: AnnouncementWireItem,
          callback: function() { self.sortWires(); },
          modelToView: function(model) {
            return new AnnouncementWireItem({ model: model, account: self.options.account });
          }
        })),
        
        (new PreviewWire({
          template: 'main_page.group-post-resources',
          collection: this.community.groupPosts,
          account: this.account,
          el: this.$(".groupPosts.wire"),
          emptyMessage: "No posts here yet.",
          fullWireLink: "#/group_posts",
          isRecent: true,
          itemView: GroupPostWireItem,
          callback: function() { self.sortWires(); },
          modelToView: function(model) {
            return new GroupPostWireItem({ model: model, account: self.options.account });
          }
        }))
      ];
    }
    return this._wires;
  },
  
  sortWiresOld: function() {
    var self = this;
    var sorted = this._wires;
    sorted = _.sortBy(this._wires, function(wire) {
      console.log(wire.collection.at(1));
      return wire.collection.first().get("updated_at");
    });
    $(this.el).empty();
    _.each(sorted, function(wire) {
      console.log(wire);
      $(this.el).append(wire.el);
      wire.render();
    });
  },
  
  sortWires: function() {
    this._sortCountdown++;
    var self = this;
    if (this._sortCountdown == this._wires.length) {
      var self = this;
      var sorted = _.sortBy(this._wires, function(wire) {
        var first = wire.collection.first();
        return first ? first.get("published_at") : "0";
      });
      //$(this.el).empty();
      _.each(sorted, function(wire) {
        var first = wire.collection.first();
        console.log(first ? first.get("published_at") : 0);
        wire.el.detach().appendTo(self.el);
      });
    }
  }

});
