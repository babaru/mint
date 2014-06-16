
( function( $ ) {

$(function() {

    var currentUserId = $('#current-user-id').val();

    var calendar = recordCalendar({
        loggedUserId: currentUserId,
        calendar: {
            element: $('#time-calendar'),
            // events: '/user_time_records_feed.json?user_id=' + currentUserId
            eventClasses: [
              'personal_record',
            ],

            eventSources: [
              {
                url: '/user_time_records_feed.json?user_id=' + currentUserId,
                color: '#2b72d0',
                className: 'personal_record'
              },

              {
                url: '/user_leave_records_feed.json?user_id=' + currentUserId,
                color: '#ea5929',
                editable: false,
                className: 'leave_record'
              },

              {
                url: '/user_overtime_records_feed.json?user_id=' + currentUserId,
                color: '#299053',
                editable: false,
                className: 'overtime_record'
              }
            ]
        }
    });

});

})( jQuery );