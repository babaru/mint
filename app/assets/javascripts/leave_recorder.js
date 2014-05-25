
( function( $ ) {

$(function() {

    var dialog = $('#user-leave-recorder-dialog');
    var userIdEditor = $('#leave_record_user_id');
    var startedAtEditor = $('#leave_record_started_at');
    var endedAtEditor = $('#leave_record_ended_at');
    var remarkEditor = $('#leave_record_remark');
    var eventForm = $('#user-leave-recorder-dialog form');
    var submitButton = $('#user-leave-recorder-dialog form input[type="submit"]');
    var alertMessage = $('#error-message');
    var alertBox = $('#user-leave-recorder-dialog .alert');

    var calendar = $('#leave-calendar').fullCalendar({

        // Views
        defaultView: 'month',

        header: {
            left: 'title',
            center: '',
            right: 'today prevYear prev,next nextYear'
        },

        aspectRatio: 1.8,

        selectable: true,
        selectHelper: true,
        select: function(start, end, allDay) {

            showDialog({
                url: '/leave_records.json',
                method: 'post',
                start: start,
                end: end
            });

        },
        editable: true,
        eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {

            ajaxUpdateEventDuration(event.id, event.start, event.end, revertFunc);

        },

        eventResize: function(event, dayDelta, minuteDelta, revertFunc) {

            ajaxUpdateEventDuration(event.id, event.start, event.end, revertFunc);

        },

        timeFormat: 'H:mm{ - H:mm}',

        // Events

        events: '/user_leave_records_feed.json',
        eventRender: function(event, element) {

            element.attr('data-id', event.id);
        }

    });

    dialog
    .on('ajax:beforeSend', function () {
        submitButton.button('loading');
    })
    .on('ajax:success', function (xhr, data, status) {
        console.log(status);
        // if (status == 'success') {
            var eventId = data['id'];
            var events = calendar.fullCalendar('clientEvents', eventId);
            if (events.length == 0) {
                var title = data["user_name"] + ': ' + data["remark"];
                renderEventOnCalendar(data['id'], title, data['started_at'], data['ended_at'], false);
            } else {
                var event = events[0];
                event.title = data["user_name"] + ': ' + data["remark"];
                calendar.fullCalendar('updateEvent', event);
            }

            dismissEventDialog();

        // }
    })
    .on('ajax:error', function(xhr, error, status) {
        if (status == 'error') {
            alertMessage.text(error.responseJSON['leave_records']);
            alertBox.show();

            resetSubmitButton();
        }
    })
    .on('hidden', function() {
        resetEventDialog();
    });

    function showDialog(options) {
        var default_options = {
            url: null,
            method: 'post',
            start: null,
            end: null,
            user_id: 0,
            remark: null
        }

        options = options || default_options;

        eventForm.attr('action', options['url']);
        eventForm.attr('method', options['method']);
        startedAtEditor.val(options['start']);
        endedAtEditor.val(options['end']);
        userIdEditor.val(options['user_id']);
        remarkEditor.val(options['remark']);

        dialog.modal();
    };

    function renderEventOnCalendar(id, title, start, end, allDay) {
        if (title) {
            calendar.fullCalendar('renderEvent', {
                id: id,
                title: title,
                start: start,
                end: end,
                allDay: allDay
            },
            true // make the event "stick"
            );
        }
        calendar.fullCalendar('unselect');
    }

    function resetSubmitButton() {
        submitButton.button('reset');
    }

    function resetAlertBox() {
        alertBox.hide();
    }

    function resetEventDialog() {
        resetSubmitButton();
        resetAlertBox();

        startedAtEditor.val(null);
        endedAtEditor.val(null);
        userIdEditor.val(0);
        remarkEditor.val(null);
    };

    function dismissEventDialog() {
        dialog.modal('hide');
    };

});

})( jQuery );