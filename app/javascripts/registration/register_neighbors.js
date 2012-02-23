var RegisterNeighborsView = CommonPlace.View.extend({
  template: "registration.neighbors",
  
  events: {
    "click input.continue": "submit",
    "submit form": "submit",
    "click a.facebook": "facebook",
    "keyup input.search": "debounceSearch",
    "click .remove_search": "removeSearch",
    "click input.contact": "toggleContact"
  },
  
  afterRender: function() {
    var self = this;
    this.page = 0;
    this.currentQuery = "";
    
    this.$(".search_finder").hide();
    
    this.$(".neighbor_finder").scroll(function() {
      if (($(this).scrollTop() + 30) > (this.scrollHeight - $(this).height())) { self.nextPageThrottled(); }
    });
    
    this.nextPageTrigger();
    this.nextPageThrottled();
    
    this.options.slideIn(this.el);
  },
  
  nextPageTrigger: function() {
    this.nextPageThrottled = _.once(_.bind(function() { this.nextPage(); }, this));
  },
  
  nextPage: function() {
    this.showGif("loading");
    $.getJSON(
      "/api" + this.options.communityExterior.links.registration.residents,
      { page: this.page, limit: 100 },
      _.bind(function(response) {
        
        if (response.length) {
          this.page++;
          var neighbors = [];
          _.each(response, _.bind(function(neighbor) {
            
            var fbUser = this.getFacebookUser(neighbor.first_name + " " + neighbor.last_name);
            var itemView = new this.NeighborItemView({
              model: neighbor,
              fbUser: fbUser,
              search: false
            });
            (!_.isEmpty(fbUser)) ? neighbors.unshift(itemView) : neighbors.push(itemView);
            
          }, this));
          this.appendPage(neighbors);
        }
        
      }, this)
    );
  },
  
  searchPage: function() {
    $.getJSON(
      "/api" + this.options.communityExterior.links.registration.residents,
      { limit: 100, query: this.currentQuery },
      _.bind(function(response) {
        if (response.length) {
          var neighbors = [];
          _.each(response, _.bind(function(neighbor) {
            var fbUser = this.getFacebookUser(neighbor.first_name + " " + neighbor.last_name);
            var itemView = new this.NeighborItemView({
              model: neighbor,
              fbUser: fbUser,
              search: true,
              addFromSearch: _.bind(function(el) {
                this.appendCell($(".neighbor_finder table"), el);
                this.removeSearch();
                this.$(".neighbor_finder").scrollTo(el);
              }, this)
            });
            (!_.isEmpty(fbUser)) ? neighbors.unshift(itemView) : neighbors.push(itemView);
          }, this));
          this.appendPage(neighbors);
        } else {
          // fill the table with a no-results notice
        }
      }, this)
    );
  },
  
  appendPage: function(neighbors) {
    var $table;
    if (this.currentQuery) {
      $table = this.$(".search_finder table");
    } else {
      $table = this.$(".neighbor_finder table");
    }
    
    _.each(neighbors, _.bind(function(itemView) {
      itemView.render();
      this.appendCell($table, itemView.el);
    }, this));
    
    this.nextPageTrigger();
    
    this.$(".remove_search").removeClass("loading");
    if (this.currentQuery) {
      this.$(".remove_search").addClass("active");
    } else {
      this.$(".remove_search").addClass("inactive");
    }
  },
  
  appendCell: function($table, el) {
    var $row;
    var $lastRow = $(_.last($table[0].rows));
    
    if ($table[0].rows.length && $lastRow[0].cells.length == 1) {
      $row = $lastRow;
    } else { $row = $($table[0].insertRow(-1)); }
    
    $row.append(el);
  },
  
  submit: function(e) {
    if (e) { e.preventDefault(); }
    
    if (this.currentQuery) {
      this.removeSearch();
      this.submit();
    }

    var data = {
      neighbors: _.map(this.$(".neighbor_finder input[name=neighbors_list]:checked"), function(neighbor) {
        return { name: $(neighbor).val() };
      }),
      can_contact: (this.$("input[name=can_contact]").attr("checked")) ? true : false
    };

    if (data.neighbors.length) {
      $.post("/api" + CommonPlace.account.link("neighbors"), data, _.bind(function() {
        this.finish()
      }, this));
    } else { this.finish(); }
  },
  
  facebook: function(e) {
    if (e) { e.preventDefault(); }

    facebook_connect_friends({
      success: _.bind(function(friends) {
        this.friends = friends;
        this.$("table").empty();
        this.page = 0;
        this.nextPageTrigger();
        this.nextPageThrottled();
      }, this)
    });
  },
  
  getFacebookUser: function(name) {
    return _.find(this.friends, function(friend) {
      return friend.name.toLowerCase() == name.toLowerCase();
    });
  },
  
  showGif: function(className) {
    this.$(".remove_search").removeClass("inactive");
    this.$(".remove_search").removeClass("active");
    this.$(".remove_search").removeClass("loading");
    this.$(".remove_search").addClass(className);
  },
  
  debounceSearch: _.debounce(function() {
    this.search();
  }, CommonPlace.autoActionTimeout),
  
  search: function() {
    this.$(".remove_search").removeClass("inactive");
    this.$(".remove_search").removeClass("active");
    this.$(".remove_search").addClass("loading");
    this.currentQuery = this.$("input[name=search]").val();
    if (!this.currentQuery) {
      this.removeSearch();
    } else {
      this.currentScroll = this.$(".neighbor_finder").scrollTop();
      this.$(".neighbor_finder").hide();
      this.$(".search_finder").show();
      this.$(".search_finder table").empty();
      this.searchPage();
    }
  },
  
  removeSearch: function(e) {
    if (e) { e.preventDefault(); }
    
    this.currentQuery = "";
    this.$("input[name=search]").val("");
    this.$(".search_finder").hide();
    this.$(".neighbor_finder").show();
    if (!this.$(".neighbor_finder").scrollTop()) {
      this.$(".neighbor_finder").scrollTo(this.currentScroll);
    }
    
    this.$(".remove_search").removeClass("active");
    this.$(".remove_search").addClass("inactive");
  },
  
  toggleContact: function(e) {
    this.$("input.contact").removeAttr("checked");
    $(e.currentTarget).attr("checked", "checked");
  },
  
  finish: function() { this.options.finish(); },
  
  NeighborItemView: CommonPlace.View.extend({
    template: "registration.neighbor-item",
    tagName: "td",
    
    events: { "click": "check" },
    
    afterRender: function() {
      if (this.isFacebook()) {
        this.check();
        facebook_connect_user_picture({
          id: this.options.fbUser.id,
          success: _.bind(function(url) {
            this.$("img").attr("src", url);
          }, this)
        });
      }
    },
    
    avatar_url: function() { return "/assets/block.png"; },
    first_name: function() { return this.model.first_name; },
    last_name: function() { return this.model.last_name; },
    
    isFacebook: function() { return !_.isEmpty(this.options.fbUser); },
    
    check: function(e) {
      if (e) { e.preventDefault(); }
      
      if (this.options.search) {
        this.options.search = false;
        this.options.addFromSearch(this.el);
      }
      
      var $checkbox = this.$("input[type=checkbox]");
      if ($checkbox.attr("checked")) {
        $checkbox.removeAttr("checked");
      } else { $checkbox.attr("checked", "checked"); }
      $(this.el).toggleClass("checked");
    }
  })
});
