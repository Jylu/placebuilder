//= require json2
//= require showdown
//= require jquery
//= require jquery-ui
//= require jquery-blockUI
//= require jquery-badger
//= require highcharts
//= require actual
//= require underscore
//= require mustache
//= require backbone
//= require autoresize
//= require dropkick
//= require truncator
//= require ajaxupload
//= require placeholder
//= require time_ago_in_words
//= require scrollTo
//= require jcrop
//= require plaxo
//= require chosen
//= require highlight-3
//= require modernizr

//= require config
//= require feature_switches

//= require views
//= require models
//= require wires
//= require wire_items

//= require_tree ./shared
//= require_tree ../templates
//= require en

//= require community_page
//
//= require facebook

//= require_tree ./contacts

//= require show_initialization

var Application = Backbone.Router.extend({

  initialize: function() {
    var header = new CommonPlace.shared.HeaderView({ el: $("#header") });
    header.render();

    $("#notification").hide();

    this.pages = {
      community: new CommonPlace.CommunityPage({ el: $("#main") }),
    };

    _.invoke(this.pages, "unbind");

    this.bindNewPosts();
  },

  routes: {
    ":community/show/posts/:id": "showPost",
    ":community/show/events/:id": "showEvent",
    ":community/show/group_posts/:id": "showGroupPost",
    ":community/show/announcements/:id": "showAnnouncement",
    ":community/show/users/:id": "showUserWire",
  },

  showPost: function(c, id) {
    this.showPage("community");
    this.pages.community.lists.showPost(new Post({links: {self: "/posts/" + id}}));
  },

  showEvent: function(c, id) {
    this.showPage("community");
    this.pages.community.lists.showEvent(new Event({links: {self: "/events/" + id }}));
  },

  showGroupPost: function(c, id) {
    this.showPage("community");
    this.pages.community.lists.showGroupPost(new GroupPost({links: {self: "/group_posts/" + id}}));
  },

  showAnnouncement: function(c, id) {
    this.showPage("community");
    this.pages.community.lists.showAnnouncement(new Announcement({links: {self: "/announcements/" + id}}));
  },

  showUserWire: function(c, id) {
    this.showPage("community");
    this.pages.community.lists.showUserWire(new User({links: {self: "/users/" + id}}));
  },

  showPage: function(name) {
    var page = this.pages[name];
    if (this.currentPage != page) {
      if (this.currentPage) { this.currentPage.unbind(); }
      this.currentPage = page;
      this.currentPage.bind();
      this.currentPage.render();
      //window.scrollTo(0,0);
    }
  },

  bindNewPosts: function() {
    var self = this;
    var community = CommonPlace.community;
    var postlikes = [community.posts, community.events, community.groupPosts, community.announcements];
    _.each(postlikes, function(postlike) {
      postlike.on("sync", function() {
        self.navigate("/", true);
        self.community();
      });
    });
  }

});
