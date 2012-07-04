
OrganizerApp.TodoList = CommonPlace.View.extend({

  template: "organizer_app.todo-list",

  events: {
    "click #add-tag" : "addTag",
  },

  initialize: function() {
    models = this.collection.models;
    community = this.options.community;
  },

  addTag: function() {
  },

  afterRender: function() {
    _.each(this.$(".todo-specific"), function(list) {
      var value = $(list).attr('value');
      var profiles = _.filter(models, function(model) {
        console.log(model.get('type'));
        console.log(model.get('tags'));
        return true;
      });

      $(list).empty();
      $(list).append(
        _.map(profiles, function(model) {
          var li = $("<li/>",{ text: model.full_name(), data: { model: model } })[0];
          var cb = $("<input/>", { type: "checkbox", value: model.getId(), data: { model: model } })[0];
          $(cb).addClass("cb");
          $(li).prepend(cb);

          return li;
        }));
      //console.log($(list).attr('value'));
    });
  },

  profiles: function() {
    var todos = possTodos;

    var names = _.map(models, function(model) {
      return model.full_name();
    });
    
    return names;
  },

  todos: function() {
    possTodos = this.options.community.get('resident_todos');
    return this.options.community.get('resident_todos');
  },

  tags: function() { return community.get('resident_tags'); },
});
