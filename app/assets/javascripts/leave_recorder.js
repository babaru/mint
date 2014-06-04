
( function( $ ) {

$(function() {

    var calendar = recordCalendar({
        userIdType: 'select',
        calendar: {
            element: $('#leave-calendar'),
            eventSources: [
              {
                url: '/user_leave_records_feed.json',
                color: '#ea5929',
                className: 'leave_record'
              }
            ]
        }
    });

});

})( jQuery );