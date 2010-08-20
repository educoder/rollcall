
$(document).ready(function(){ 
  $('.listing').each(function() {
    if ($(this).has('li.groupable').length > 0) {
      $(this).addClass('clickable')
    }
  })
  
  $('.listing').click(function() {
    if ($(this).has('li').length > 0) {
      $(this).children('.groupables').slideToggle('fast')
    }
  })
})