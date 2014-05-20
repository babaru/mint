( function( $ ) {

var date = new Date();
var d = date.getDate();
var m = date.getMonth();
var y = date.getFullYear();

$( function () {
    var calendar = $('#calendar').fullCalendar({

        // Views

        defaultView: 'agendaWeek',

        // General Display

        header: {
            left: 'title',
            center: '',
            right: 'today prevYear prev,next nextYear'
        },

        firstDay: 1,
        weekNumbers: true,
        aspectRatio: 1.8,

        viewRender: function( view, element) {

        },

        // Agenda

        allDaySlot: false,
        axisFormat: 'H',

        // Selectable

        selectable: true,
        selectHelper: true,
        select: function(start, end, allDay) {
            var title = prompt('Event Title:');
            if (title) {
                calendar.fullCalendar('renderEvent', {
                    title: title,
                    start: start,
                    end: end,
                    allDay: allDay
                },
                true // make the event "stick"
                );
            }
            calendar.fullCalendar('unselect');
        },
        editable: true,

        timeFormat: 'H:mm{ - H:mm}',

        // Events

        events: '/user_time_records_feed.json?user_id=2',

        // events: [{"id":523,"title":"UTP Derivatives: \u6492\u5927\u662f\u5927\u975e","start":1400743800,"end":1400751000, "allDay": false},{"id":524,"title":"MEFF: \u554a\u5b9a\u8eab\u6cd5\u7684","start":1400571000,"end":1400578200},{"id":525,"title":"Xetra: \u6492\u5730\u65b9","start":1400580000,"end":1400583600},{"id":526,"title":"ITS: \u963f\u65af\u987f\u53d1","start":1400657400,"end":1400662800},{"id":527,"title":"Speedy: \u963f\u65af\u987f\u53d1\u662f","start":1400666400,"end":1400671800},{"id":528,"title":"UTP Derivatives: \u963f\u65af\u987f\u53d1\u7684","start":1400450400,"end":1400455800},{"id":529,"title":"HKEx OMD-D: \u963f\u65af\u987f\u53d1\u7684","start":1400754600,"end":1400760000},{"id":530,"title":"Xetra: \u6492\u5730\u65b9","start":1400653800,"end":1400657400},{"id":531,"title":"MEFF: \u963f\u65af\u987f\u53d1\u662f\u7684","start":1400482800,"end":1400488200},{"id":532,"title":"Xetra Vienna: \u963f\u65af\u987f\u53d1\u662f\u7684","start":1400835600,"end":1400841000},{"id":533,"title":"MEFF: \u963f\u65af\u987f\u53d1","start":1400491800,"end":1400493600},{"id":534,"title":"Market research: \u963f\u65af\u987f\u653e42 \u6492\u5730\u65b9","start":1400617800,"end":1400623200},{"id":535,"title":"Market research: \u4e0d\u7740\u6389\u505a\u4e86\u4ec0\u4e48","start":1400920200,"end":1400925600},{"id":536,"title":"ASX: 123","start":1400844600,"end":1400850000}]

    });
});


})( jQuery );