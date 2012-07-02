
OrganizerApp.TodoList = CommonPlace.View.extend({

  template: "organizer_app.todo-list",
  //template: "organizer_app.new-resident",

  events: {
  },

  show: function(){
    //return this.filePicker.url();
    collection.each(function(model) {
      console.log(model.full_name());
    });
    //return this.collection.url();
    //return result;
    //return this.filepicker.reload();
  },

  todos: function() {
    possTodos = this.options.community.get('resident_todos');
    return this.options.community.get('resident_todos');
  }
});
