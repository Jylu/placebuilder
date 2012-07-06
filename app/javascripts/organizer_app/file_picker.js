
OrganizerApp.FilePicker = CommonPlace.View.extend({

  template: "organizer_app.file-picker",

  events: {
    "click .pick-resident": "onClickFile",
    "click .cb": "toggle",
    "click #filter": "filterUsers",
    "click #filter-order" :"filterUsers",
    "click :checkbox": "toggle",
    "click #filter-button": "filter",
    "click .tag-filter": "cycleFilter",
    "click #check-all": "checkall",
    "click #add-tag" : "addTag",
    "click #map-button": "showMapView",
    "click #new-resident": "addResident",
    "click #todo-list": "gotoTodo",
    //"click #filter-tags": "addNewselect"
    //"click #new-street" : "addStreet"
  },

  addNewselect: function(){
    
    var select=this.$(".multiselect").clone();
    alert("!");
    //this.$('span[name=tcol1]').append();
    this.$("#new-selects").append(select);
    //alert("!!");
  },

  initialize: function() {
    checklist = [];
    all_check = false;
  },

  onClickFile: function(e) {
    e.preventDefault();
    //console.log($(e.currentTarget));
    this.options.fileViewer.show($(e.currentTarget).data('model'));
  },

  checkall: function(e) {
    all_check = !all_check;
    _.map(this.$('.cb'), function(box) {
      c = this.$(box).data('model').getId();
      checklist[c] = all_check;
    }, this);
    this.render();
  },

  // This seems like not the right way to implement checkboxes...=|
  toggle: function(e) {

    c = this.$(e.currentTarget).data('model').getId();
    if(typeof checklist[c] === "undefined")
      checklist[c] = false;

    checklist[c] = !checklist[c];
    this.render();
  },

  /*
   * For some reason, reloading the location causes a race condition
   * where it's not guaranteed for all of the checked names to have
   * the tag applied to the file
   */
  addTag: function() {
    _.map(this.collection.models, _.bind(function(model) {
      if(checklist[model.getId()]) {
        var tag = this.$("#tag-input").val();

        model.addTag(tag, _.bind(this.render, this));
      }
    }, this));
    //location.reload();
  },

  gotoTodo: function (e) {
    new OrganizerApp.TodoList({el: $('#file-viewer'), community: this.options.community,  collection: this.collection, filePicker: this}).render();
  },

  addResident: function(e) {
    new OrganizerApp.AddResident({el: $('#file-viewer'), collection: this.collection, filePicker: this}).render();
  },
/*
  addStreet: function(e) {
    new OrganizerApp.AddStreet({el: $('#file-viewer'), collection: this.collection, filePicker: this}).render();
  },
*/
  showMapView: function(e) {
    new OrganizerApp.MapView({el: $('#file-viewer'), collection: this.collection, filePicker: this}).render();
  },

  afterRender: function() {
    $("#check-all").attr("checked", all_check);
    this.renderList(this.collection.models);
    this.produceOrdertags();
  },

  renderList: function(list) {
    this.$("#file-picker-list").empty();
    //console.log(list);
    this.$("#file-picker-list").append(
      _.map(list, _.bind(function(model) {
        /*console.log("renderList model: ");
        console.log(model);
        console.log("model url: ", model.url());*/
        var li = $("<li/>", { text: model.full_name(), data: { model: model } })[0];
        var cb = $("<input/>", { type: "checkbox", checked: checklist[model.getId()], value: model.getId(), data: { model: model } })[0];
        $(cb).addClass("cb");
        $(li).prepend(cb);
        $(li).addClass("pick-resident");
        return li;
      }, this)));
  },

  filter: function() {
    var params = {
      "with": _.map(this.$(".tag-filter[data-state=on]").toArray(), function(e) {
        return $(e).attr("data-tag");
      }).join(","),
      without: _.map(this.$(".tag-filter[data-state=off]").toArray(), function(e) {
        return $(e).attr("data-tag");
      }).join(","),
      query: this.$("#query-input").val()
    };

    this.collection.fetch({
      data: params,
      success: _.bind(this.afterRender, this)
    });
    //this.showMapView();
  },

  tags: function() { possTags = this.options.community.get('resident_tags'); return this.options.community.get('resident_tags'); },

  cycleFilter: function(e) {
    window.foo = this;
    e.preventDefault();
    var state = $(e.currentTarget).attr("data-state");
    var newState = { neutral: "on", on: "off", off: "neutral"}[state];
    $(e.currentTarget).attr("data-state", newState);
  },
  
  dropdowns: function(){
    //var tags=["post","email","reply","replied","invite","announcement","event","sitevisit"];
    //var alltags=tags.concat(possTags);
    var actions=[{tag:"post",val:"Post"},{tag:"email",val:"Email"},{tag:"reply",val:"Reply"},{tag:"replied",val:"Be replied"},
              {tag:"invite",val:"Invite"},{tag:"announcement",val:"Announcement"},{tag:"event",val:"Event"},{tag:"sitevisit",val:"Log in"}         ];
    possTags=this.options.community.get('resident_tags');
    _.map(possTags, function(residenttag) {
      actions.push({tag:residenttag,val:residenttag});
    });
    return actions;
  },

  filterUsers: function(e){
    var tag=new Array();
    _.map(this.$("select[name=filter-tags]"), function(select) {
      if(select.value){ 
        tag.push(select.value);
      }    
    });
    var haves=new Array();
    _.map(this.$("select[name=haveornot]"), function(select) {
      if(select.value){ 
        haves.push(select.value);
      }    
    });
    
    switch(e.target.id){
      case "filter":
        var params={
          "search": "filter",
          "have": haves,
          "tag": tag
        };
        //console.log(params["have"]);
        this.collection.fetch({
          data: params,
          success: _.bind(this.afterRender, this)
        });
        
        break;
      case "filter-order":
        var params={
          "search": "filter",
          //"have": this.$("#haveornot").val(),
          "tag": this.$("#order-tags").val(),
          "order": this.$("#order").val()
        };
        
        this.collection.fetch({
          data: params,
          success: _.bind(this.afterRender, this)
        });
        console.log(params["tag"]);
        break;
    }
  },
  
  produceOrdertags: function(){
    //this.collection.commontags();
    //console.log(this.collection.commontags());
    var obj = this.$("#order-tags").empty(); 
    _.map(this.collection.commontags(),function(tag){
      this.$("#order-tags").append('<option value='+tag+'>'+tag+'</option>');
    });
  }

});
