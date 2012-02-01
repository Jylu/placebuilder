var ProfileBox = CommonPlace.View.extend({
  template: "main_page.profile-box",
  id: "profile-box",

  initialize: function(options) {
    this.profileDisplayer = options.profileDisplayer;
  },

  afterRender: function() {
    this.lists = new ProfileBoxLists({ 
      el: this.$("#profile-box-lists"), 
      showProfile: _.bind(this.profileDisplayer.show, this.profileDisplayer)
    });

    this.$("#profile-box-profile").replaceWith(this.profileDisplayer.el);
    this.profileDisplayer.bind("shown", _.bind(function(shown, options) {
      this.switchFilterClass(shown.get('schema'));
      if (options && options.from_wire) {
        this.lists.showList(shown.get('schema'));
      }
    }, this));
    this.profileDisplayer.render();
    this.lists.showList("account");
    this.$("[placeholder]").placeholder();
  },

  events: {
    "click .filters a": "switchFilter",
    "click .remove-search": "removeSearch",
    "keyup input.search": "search"
  },
  
  switchFilterClass: function(schema) {
    this.$(".filters a").removeClass("current");
    this.$(".filters a." + schema + "-filter").addClass("current");    
  },
  
  switchFilter: function(e) {
    e.preventDefault();

    var schema = $(e.target).attr("href").split("#")[1];
    
    if (schema == "account") {
      this.lists.showList(schema);
      this.profileDisplayer.show(CommonPlace.account);
    } else {
      this.lists.showList(schema, { showProfile: true });
    }

    this.switchFilterClass(schema);
    this.lists.clearSearch();
  },

  search: _.debounce(function() {
    var search_term = this.$("#profile-box-search input.search").val();
    if (search_term === "") {
      this.removeSearch()
    } else {
      this.lists.showSearch(search_term, { showProfile: true });
      this.$(".filters a").removeClass("current");
    }
  }, 500),

  removeSearch: function() { 
    this.lists.clearSearch(); 
    this.$(".filters a.account-filter").click() 
  }
  

});
