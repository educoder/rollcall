
$(document).ready(function(){ 
  $('.listing').each(function() {
    if ($(this).has('li.groupable').length > 0) {
      $(this).addClass('clickable')
    }
  })
  
  $('.groupable').draggable({
    revert: 'invalid', 
    helper: 'clone'
  })
  
  $('.group').droppable({
    hoverClass: 'dropping',
    drop: function(event, ui) {
      $(ui.helper).effect('drop')
    }
  })
  
  $('.listing').click(function() {
    if ($(this).has('li').length > 0) {
      $(this).children('.groupables').slideToggle('fast')
    }
  })
})