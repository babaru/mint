
( function( $ ) {

$(function() {

    var calendar = recordCalendar({
        userIdType: 'select',
        calendar: {
            element: $('#leave-calendar'),
            events: '/user_leave_records_feed.json'
        }
    });

});

})( jQuery );