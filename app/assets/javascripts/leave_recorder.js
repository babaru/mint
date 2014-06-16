
( function( $ ) {

$(function() {

    var calendar = recordCalendar({
        userIdType: 'select',
        calendar: {
            element: $('#leave-calendar'),
            eventClasses: [
                'leave_record'
            ],

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