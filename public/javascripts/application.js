/*jshint devel: true, browser: true */
/*globals jQuery, $ */

(function ($) {
    $.fn.groupable = function() {
        $(this).draggable({revert: true, revertDuration: 0});
    };
    $.fn.group = function() {
        $(this).droppable({
            tolerance: 'pointer',
            hoverClass: 'active',
            drop: function(ev, ui) {
                if ($(ui.draggable).is('.groupable')) {
                    var groupable = (ui.draggable);
                    $.ajax({
                        url: '/groups/'+$(this).data('id')+'/add_member',
                        type: 'put',
                        context: this,
                        data: {
                            member: {
                                id: groupable.data('id'),
                                type: groupable.data('type')
                            }
                        },
                        beforeSend: function(data) {
                            $(this).effect('highlight');
                        },
                        success: function(data) {
                            var updatedGroup = $(data);
                            updatedGroup.group(); // make the replacement element a droppable
                            $(this).replaceWith(updatedGroup);
                        },
                        error: function(data) {
                            alert("ERROR: \n  - "+
                                $(data.responseXML).find('error').map(function(){
                                    return $(this).text();
                                }).toArray().join("\n  - ")
                            );
                        }
                    });
                }
            }
        });

        var groupHoverOver = function () {
            $(this).find('.groupables .groupable').each(function () {
                $('.'+$(this).data('dom-class')).addClass("highlight");
            });
        };

        var groupHoverOut = function () {
            $(".highlight").removeClass("highlight");
        };

        $(this).hover(groupHoverOver, groupHoverOut);
    };
}(jQuery));

$(document).ready(function() {
    $('input[type=submit], input[type=button], input[type=reset]').button();
    $('button[type=submit]').button({icons: {primary: 'ui-icon-check'}});
    
    
    $('.groupable').groupable();
    $('.group').group();
    
    
    $('.edit_group .groupables li .delete')
        .bind('ajax:beforeSend', function() {
            $(this).parent().addClass('deleted');
        })
        .bind('ajax:success', function() {
            $(this).parent().hide('fade', {}, 'fast');
        });
        
    var checkHasAccount = function() {
        if ($('#has_account').is(':checked')) {
            $('#account').show();
            $('#group_account_attributes__destroy').val(false);
        } else {
            $('#account').hide();
            $('#group_account_attributes__destroy').val(true);
        }
    };

    $('#has_account').click(checkHasAccount);
    checkHasAccount();
        
});