
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

  profiles: function() {
   // alert(this.$().attr('name'));
    var todos = possTodos;
    var tagged = _.filter(models, function(model) {
      return true;
    });

    var names = _.map(tagged, function(model) {
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
