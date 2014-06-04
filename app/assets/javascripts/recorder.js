
( function( $ ) {

$(function() {

    var currentUserId = $('#current-user-id').val();

    var calendar = recordCalendar({
        loggedUserId: currentUserId,
        calendar: {
            element: $('#time-calendar'),
            events: '/user_time_records_feed.json?user_id=' + currentUserId
        }
    });

});

})( jQuery );