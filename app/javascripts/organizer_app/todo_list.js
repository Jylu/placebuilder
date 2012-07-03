
OrganizerApp.TodoList = CommonPlace.View.extend({

  template: "organizer_app.todo-list",

  events: {
  },

  initialize: function() {
    models = this.collection.models;
  },

  profiles: function() {
   // alert(this.$().attr('name'));
    var todos = possTodos;
    var tagged = _.filter(models, _.bind(function(model) {
      return true;
    }, this));

    var names = _.map(tagged, _.bind(function(model) {
      return model.full_name();
    }, this));
    
    return names;
  },

  todos: function() {
    possTodos = this.options.community.get('resident_todos');
    return this.options.community.get('resident_todos');
  }
});
