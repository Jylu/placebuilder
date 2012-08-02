
OrganizerApp.Charts = CommonPlace.View.extend({
  
  //template: "organizer_app.statistics-charts",

  events: {
     "click #set-date":"setStartdate",
  },
  
  initialize: function() {
    community=this.options.community;
    console.log(this.options.community.url());
    /*if(!this.options.community.get('organize_start_date')){
      this.$("#set-start-date").style.display="";
    }*/
  },
  
  render:function () {        
        /*$(this.el).html('<div id="set-start-date" style="display:none">Organize start date is not set. Set now?<input id="start-date" type="text" placeholder="Date (MM/DD/YYYY)"><button id="set-start-date">Set</button></div><br><select id="graphs"><option value="user">User Amount</option></select><br><div id="chart_div"></div>');*/
        $(this.el).html('<div id="set-start-date" style="display:none">Organize start date is not set. Set now?</div><br><select id="graphs"></select><br><br><div id="chart_div"></div>');
        this.$('#set-start-date').append('<input id="start-date" type="text" placeholder="Date (DD/MM/YYYY)" />');
        this.$('#set-start-date').append('<button id="set-date">Set</button>');
        var newOptions = {
          'users':'User Amount',
          'posts':'Post Amount',
          'emails':'Emails Sent Amount',
          'calls':'Phone Call Amount',
          'profiles':'CH profiles Amount',
          'civicheroes':'Added to CH List',
          'feeds':'Feeds Created',
          'boxes':'Leader Boxes Sent',
          'blurb':'Blurb Sent Out'
        }
        if(this.$('#graphs').prop) {
          var options = this.$('#graphs').prop('options');
        }
        else {
          var options = this.$('#graphs').attr('options');
        }
        $.each(newOptions, function(val, text) {
          options[options.length] = new Option(text, val);
        });
        google.load('visualization', '1',  {'callback':this.drawVisualization,
            'packages':['corechart']});
        return this;
    },
    
    drawVisualization:function () {
        if(!this.community.get('organize_start_date')){
          this.$("#set-start-date").get(0).style.display="";
        }
        console.log("In draw visualization");
        var data = new google.visualization.DataTable();
        /*
        data.addColumn('date', 'Date');
        data.addColumn('number', 'Column A');
        data.addColumn('number', 'Column B');
        data.addRows(4);
        data.setCell(0, 0, new Date("2009/07/01"));
        data.setCell(0, 1, 1);
        data.setCell(0, 2, 7);
        data.setCell(1, 0, new Date("2009/07/08"));
        data.setCell(1, 1, 2);
        data.setCell(1, 2, 4);*/
        console.log(this.community.get('user_statistics'));
        var data = google.visualization.arrayToDataTable(this.community.get('user_statistics')['users'],false);
        var options = {
          chartArea:{left:30,top:20,width:"90%",height:"65%"},
          title : 'User Amount Gain Statistics',
          vAxis: {0:{title: "Amount",logScale: false},1:{}},
          hAxis: {title: "Day",textPosition: "out"},
          series: {0:{type: "line",targetAxisIndex:0},1: {type: "bars",targetAxisIndex:1}},
          legend: {position: 'in',textStyle: {color: 'blue', fontSize: 12}}
        };
        var chart = new google.visualization.ComboChart(this.$('#chart_div').get(0));
        google.visualization.events.addListener(chart, 'select', this.selectHandler);
        chart.draw(data, options);
    },
    
    selectHandler: function () {
      var selectedItem = chart.getSelection()[0];
      if (selectedItem) {
        var value = data.getValue(selectedItem.row, selectedItem.column);
        alert('The user selected ' + value);
      }
    },
    
    setStartdate: function(){
      var date=$('#start-date').val();
      //alert(date);
      data={organize_start_date: date};
      editdiv=this.$("#set-start-date").get(0);
      $.ajax({
		  type: 'POST',
          contentType: "application/json",
		  url: this.options.community.url(),
		  data: JSON.stringify(data),
		  cache: 'false',
		  success: function() {
                             alert("Saved!");
                             editdiv.style.display="none";
                           }
	  });
     }
    

});
