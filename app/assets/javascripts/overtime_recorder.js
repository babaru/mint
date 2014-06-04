
( function( $ ) {

$(function() {

    var calendar = recordCalendar({
        userIdType: 'select',
        calendar: {
            element: $('#overtime-calendar'),
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