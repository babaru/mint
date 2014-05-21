( function( $ ) {

$( function () {

    var eventDialog = $('#event-dialog');
    var userIdEditor = $('#time_record_user_id');
    var projectIdEditor = $('#time_record_project_id');
    var startedAtEditor = $('#time_record_started_at');
    var endedAtEditor = $('#time_record_ended_at');
    var remarkEditor = $('#time_record_remark');
    var eventForm = $('#event-dialog form');
    var submitButton = $('#event-dialog form input[type="submit"]');
    var alertMessage = $('#time-record-error-message');
    var alertBox = $('#event-dialog .alert');

    var userId = $('#current-user-id').val();

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

            showEventDialog({
                url: '/time_records.json',
                method: 'post',
                start: start,
                end: end,
                user_id: userId
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

        events: '/user_time_records_feed.json?user_id=' + userId,
        eventRender: function(event, element) {
            element.qtip({
                content: event.title
            });

            element.attr('data-id', event.id);
        }

    });

    $('#event-dialog')
    .on('ajax:beforeSend', function () {
        submitButton.button('loading');
    })
    .on('ajax:success', function (xhr, data, status) {
        console.log(status);
        // if (status == 'success') {
            var eventId = data['id'];
            var events = calendar.fullCalendar('clientEvents', eventId);
            if (events.length == 0) {
                var title = data["project_name"] + ': ' + data["remark"];
                renderEventOnCalendar(title, data['started_at'], data['ended_at'], false);
            } else {
                var event = events[0];
                event.title = data["project_name"] + ': ' + data["remark"];
                calendar.fullCalendar('updateEvent', event);
            }

            dismissEventDialog();

        // }
    })
    .on('ajax:error', function(xhr, error, status) {
        if (status == 'error') {
            alertMessage.text(error.responseJSON['time_records']);
            alertBox.show();

            resetSubmitButton();
        }
    })
    .on('hidden', function() {
        resetEventDialog();
    });

    $.contextMenu({
        selector: '.fc-event',
        build: function($trigger, e) {
            var target = $trigger;

            return {

                callback: function() {},

                items: {
                    'edit': {
                        name: '<i class="icon-pencil"></i> Edit',
                        callback: function() {
                            // console.log(target.data('id'));
                            var currentEvents = calendar.fullCalendar('clientEvents', target.data('id'));
                            if (currentEvents.length > 0) {
                                // console.log(currentEvents[0]);
                                showEventDialog({
                                    url: '/time_records/' + target.data('id') + '.json',
                                    method: 'put',
                                    start: currentEvents[0].start,
                                    end: currentEvents[0].end,
                                    project_id: currentEvents[0].project_id,
                                    remark: currentEvents[0].description,
                                    user_id: userId
                                });
                            }
                        }
                    },
                    'delete': {
                        name: '<i class="icon-trash"></i> Delete',
                        callback: function() {
                            ajaxDeleteEvent(target.data('id'), function() {
                                console.log("Deleting event: " + target.data('id'));
                                calendar.fullCalendar('removeEvents', target.data('id'));
                            });
                        }
                    }
                }
            }
        }
        // items: {
        //     "delete": {
        //         name: 'Delete',
        //         callback: function() {
        //             calendar.fullCalendar('removeEvents', event.id);
        //         }
        //     }
        // }
    });

    function ajaxUpdateEventDuration(id, start, end, revertFunc) {
        $.ajax({
            url: '/time_records/' + id + '.json',
            method: 'PUT',
            data: {
                time_record: {
                    started_at: start,
                    ended_at: end
                }
            },

            error: function(xhr, status, error) {
                if (status == 'error') {
                    revertFunc();
                }
            }
        });
    }

    function ajaxDeleteEvent(id, callback) {
        $.ajax({
            url: '/time_records/' + id + '.json',
            method: 'DELETE',

            success: function(data, status, xhr) {
                callback();
            },

            error: function(xhr, status, error) {
                if (status == 'error') {
                    // revertFunc();
                }
            }
        });
    }

    function renderEventOnCalendar(title, start, end, allDay) {
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
        projectIdEditor.val(0);
        userIdEditor.val(0);
        remarkEditor.val(null);
    };

    function dismissEventDialog() {
        eventDialog.modal('hide');
    };

    function showEventDialog(options) {
        var default_options = {
            url: null,
            method: 'post',
            start: null,
            end: null,
            user_id: 0,
            project_id: 0,
            remark: null
        }

        options = options || default_options;

        eventForm.attr('action', options['url']);
        eventForm.attr('method', options['method']);
        startedAtEditor.val(options['start']);
        endedAtEditor.val(options['end']);
        projectIdEditor.val(options['project_id']);
        userIdEditor.val(options['user_id']);
        remarkEditor.val(options['remark']);

        eventDialog.modal();
    };
});

})( jQuery );