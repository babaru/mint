
( function( $ ) {

$(function() {

    // var user_id = $('#user-id-field').text();
    var params = window.location.search.substring(1);

    $.ajax({
        url: '/manager/time/record.json?' + params,
        method: 'GET',

        success: function(data, status, xhr) {
            $.each(data, function(i, item) {
                var recorded_on = moment(item.recorded_on);
                // console.log(item.project_id);
                // console.log(moment(item.recorded_on).isValid());
                var cell_name = '.record-' + item.project_id + '-' + recorded_on.year() + '-' + (recorded_on.month() + 1) + '-' + recorded_on.date();
                // console.log(cell_name);
                $(cell_name).text(item.value);
            });
        },

        error: function(xhr, status, error) {
            if (status == 'error') {
                // revertFunc();
            }
        }
    });

});

})( jQuery );