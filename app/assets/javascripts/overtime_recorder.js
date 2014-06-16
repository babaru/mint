
( function( $ ) {

$(function() {

    var calendar = recordCalendar({
        userIdType: 'select',
        calendar: {
            element: $('#overtime-calendar'),
            eventClasses: [
                'overtime_record'
            ],
            eventSources: [
              {
                url: '/user_overtime_records_feed.json',
                color: '#299053',
                className: 'overtime_record'
              }
            ]
        }
    });

});

})( jQuery );