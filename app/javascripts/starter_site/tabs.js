$(document).ready(function(){
  $('.nav li a').click(function(){
    
    $('.nav li').removeClass('selected');
    
    $(this).parent().addClass('selected');
    
    $('.slide').hide();
    
    if($(this).attr('href')=="our-mission"){
      $('#our-mission').show();
    }
    else if($(this).attr('href')=="our-story"){
      $('#our-story').show();
    }
    else if($(this).attr('href')=="our-platform"){
      $('#our-platform').show();
    }
    return false;
  });
});