(function ($) {
    $.fn.groupable = function() {
        $(this).draggable({revert: true, revertDuration: 0})
    },
    $.fn.group = function() {
        $(this).droppable({
            drop: function(ev, ui) {
                if ($(ui.draggable).is('.groupable')) {
                    groupable = (ui.draggable)
                    $.ajax({
                        url: '/groups/'+$(this).data('id')+'/add_member.xml',
                        type: 'put',
                        context: this,
                        data: {
                            member: {
                                id: groupable.data('id'),
                                type: groupable.data('type')
                            }
                        },
                        beforeSend: function(data) {
                            $(this).effect('highlight')
                        },
                        success: function(data) {
                            $.ajax({
                                url: '/groups/'+$(this).data('id')+'/show_listing',
                                type: 'get',
                                context: this,
                                success: function(data) {
                                    updatedGroup = $(data)
                                    updatedGroup.group() // make the replacement element a droppable
                                    $(this).replaceWith(updatedGroup)
                                }
                            })
                        },
                        error: function(data) {
                            alert("ERROR: \n  -"+
                                $(data.responseXML).find('error').map(function(){
                                    return $(this).text()
                                }).toArray().join("\n  -")
                            )
                        }
                    })
                }
            }
        })
    }
}(jQuery))

$(document).ready(function() {
    $('.groupable').groupable()
    $('.group').group()
    
    
    $('.edit_group .groupables li .delete')
        .bind('ajax:beforeSend', function() {
            $(this).parent().addClass('deleted')
        })
        .bind('ajax:success', function() {
            $(this).parent().hide('fade', {}, 'fast')
        })
        
    checkHasAccount = function() {
        if ($('#has_account').is(':checked')) {
            $('#account').show()
            $('#group_account_attributes__destroy').val(false)
        } else {
            $('#account').hide()
            $('#group_account_attributes__destroy').val(true)
        }
    }

    $('#has_account').click(checkHasAccount)
    checkHasAccount()
        
})