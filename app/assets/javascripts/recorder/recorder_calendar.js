
function recordCalendar(options) {

    var defaultOptions = {

        loggedUserId: 0,
        userIdType: 'logged',

        recordDialog: {
            dialog:             $('#record-dialog'),
            userId:             $('#time_record_user_id'),
            projectId:          $('#time_record_project_id'),
            startedAt:          $('#time_record_started_at'),
            endedAt:            $('#time_record_ended_at'),
            remark:             $('#time_record_remark'),
            form:               $('#record-dialog form'),
            submitButton:       $('#record-dialog form input[type="submit"]'),
            alertMessage:       $('#error-message'),
            alertBox:           $('#record-dialog .alert')
        },

        urls: {
            create: '/time_records.json',
            update: '/time_records/',
            delete: '/time_records/'
        },

        calendar: {
            element: $('#calendar'),

            eventClasses: [
            ],

            defaultView: 'agendaWeek',
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

            allDaySlot: false,
            axisFormat: 'H',
            selectable: true,
            selectHelper: true,
            select: function(start, end, allDay) {
                showRecordDialog({
                    url: '/time_records.json',
                    method: 'post',
                    start: start,
                    end: end
                });
            },
            editable: true,
            eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {
                updateRecord(event.id, event.start, event.end, revertFunc);
            },

            eventResize: function(event, dayDelta, minuteDelta, revertFunc) {
                updateRecord(event.id, event.start, event.end, revertFunc);
            },

            timeFormat: 'H:mm{ - H:mm}',

            // Events

            events: [],
            eventRender: function(event, element) {
                element.attr('data-id', event.id);
            }
        }
    };

    options = $.extend(true, {}, defaultOptions, options);

    var cal = options.calendar.element.fullCalendar(
        options.calendar
    );

    options.recordDialog.dialog.on('ajax:beforeSend', function () {
        options.recordDialog.submitButton.button('loading');

    }).on('ajax:success', function (xhr, data, status) {
        console.log(data);
        var eventId = data['id'];
        var events = cal.fullCalendar('clientEvents', eventId);
        if (events.length == 0) {
            renderRecordOnCalendar(data['id'], data['title'], data['started_at'], data['ended_at'], false);
        } else {
            var event = events[0];
            // event.title = data['title'];
            cal.fullCalendar('updateEvent', event);
        }

        dismissRecordDialog();

    }).on('ajax:error', function(xhr, error, status) {
        if (status == 'error') {
            options.recordDialog.alertMessage.text(error.responseJSON['time_records']);
            options.recordDialog.alertBox.show();

            resetSubmitButton();
        }
    })
    .on('hidden', function() {
        resetRecordDialog();
    });

    function updateRecord(id, start, end, revertFunc) {
        $.ajax({
            url: options.urls.update + id + '.json',
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
    };

    function deleteRecord(id, callback) {
        $.ajax({
            url: options.urls.delete + id + '.json',
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
    };

    console.log(options.calendar.eventClasses);

    $.each(options.calendar.eventClasses, function(i, el) {
        console.log(el);
        $.contextMenu({
            selector: '.' + el,
            build: function($trigger, e) {
                var target = $trigger;

                return {

                    callback: function() {},

                    items: {
                        'edit': {
                            name: '<i class="icon-pencil"></i> Edit',
                            callback: function() {
                                // console.log(target.data('id'));
                                var currentEvents = cal.fullCalendar('clientEvents', target.data('id'));
                                if (currentEvents.length > 0) {
                                    console.log(currentEvents[0]);
                                    showRecordDialog({
                                        url: '/time_records/' + target.data('id') + '.json',
                                        method: 'put',
                                        start: currentEvents[0].start,
                                        end: currentEvents[0].end,
                                        project_id: currentEvents[0].project_id,
                                        remark: currentEvents[0].description,
                                        user_id: currentEvents[0].user_id
                                    });
                                }
                            }
                        },
                        'delete': {
                            name: '<i class="icon-trash"></i> Delete',
                            callback: function() {
                                deleteRecord(target.data('id'), function() {
                                    cal.fullCalendar('removeEvents', target.data('id'));
                                });
                            }
                        }
                    }
                }
            }
        });
    });

    function renderRecordOnCalendar(id, title, start, end, allDay) {
        cal.fullCalendar('refetchEvents');
        cal.fullCalendar('unselect');
    }

    function resetSubmitButton() {
        options.recordDialog.submitButton.button('reset');
    }

    function resetAlertBox() {
        options.recordDialog.alertBox.hide();
    }

    function resetRecordDialog() {
        resetSubmitButton();
        resetAlertBox();

        options.recordDialog.startedAt.val(null);
        options.recordDialog.endedAt.val(null);
        options.recordDialog.projectId.val(0);
        if (options.userId == 'logged') {
            options.recordDialog.userId.val(options.loggedUserId);
        } else {
            options.recordDialog.userId.val(0);
        }
        options.recordDialog.remark.val(null);
    };

    function dismissRecordDialog() {
        options.recordDialog.dialog.modal('hide');
    };

    function showRecordDialog(opts) {
        var default_options = {
            url: options.urls.create,
            method: 'post',
            start: null,
            end: null,
            user_id: 0,
            project_id: 0,
            remark: null
        }

        opts = $.extend(true, {}, default_options, opts);
        console.log(opts);

        options.recordDialog.form.attr('action', opts.url);
        options.recordDialog.form.attr('method', opts.method);
        options.recordDialog.startedAt.val(opts.start);
        options.recordDialog.endedAt.val(opts.end);
        options.recordDialog.projectId.val(opts.project_id);

        if (options.userIdType == 'logged') {
            options.recordDialog.userId.val(options.loggedUserId);
        } else {
            options.recordDialog.userId.val(opts.user_id);
        }

        console.log(options.recordDialog.userId.val());

        options.recordDialog.remark.val(opts.remark);

        options.recordDialog.dialog.modal();
    };

    return cal;
};



