
( function( $ ) {

$(function() {

    var calendar = recordCalendar({
        userIdType: 'select',
        calendar: {
            element: $('#overtime-calendar'),
            events: '/user_overtime_records_feed.json'
        }
    });

});

})( jQuery );