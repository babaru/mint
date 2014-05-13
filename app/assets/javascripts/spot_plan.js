$(document).ready(function() {
    attach_context_menu('.spot-plan-item');

    $('.spot-plan-item').on('click', function() {
        click_spot_plan_item($(this), null);
    });
});

function click_spot_plan_item(target, count) {
    if (target.data('spot-plan-item-id') == undefined) { // is empty item
        empty_spot_plan_item_clicked(target, count);
    } else {
        spot_plan_item_clicked(target, count);
    }
}

function empty_spot_plan_item_clicked(target, count) {
    var master_plan_item_id = target.data('master-plan-item-id');
    var master_plan_id = target.data('master-plan-id');
    var placed_at = target.data('placed-at');
    var count_val = 1;
    if (count != null) {
        count_val = count;
    }
    var version = target.data('version');

    if (count_val > 0) {
        change_spot_plan_item_and_master_plan_item_counts(0, count_val, target);
        highlight_changing_items(target);
        create_spot_plan_item(master_plan_id, master_plan_item_id, placed_at, count_val, version, target);
    }
}

function spot_plan_item_clicked(target, count) {
    var count_val = parseInt(target.data('count'));
    var new_count_val = count_val + 1;
    if (count != null) {
        new_count_val = count;
    }
    var spot_plan_item_id = target.data('spot-plan-item-id');

    if (count_val != new_count_val) {
        change_spot_plan_item_and_master_plan_item_counts(count_val, new_count_val, target);
        highlight_changing_items(target);
        modify_spot_plan_item_count(spot_plan_item_id, new_count_val, target);
    }
}

function reset_spot_plan_item_count(target) {
    var count = target.data('count');
    var master_plan_item_count_cell = get_master_plan_item_reality_count_cell(target);
    var master_plan_item_ideal_count_cell = get_master_plan_item_ideal_count_cell(target);

    var reality_count = parseInt(master_plan_item_count_cell.data('count'));
    var ideal_count = parseInt(master_plan_item_ideal_count_cell.data('count'));
    var new_reality_count = reality_count - count;

    target.text('');

    master_plan_item_count_cell.text(new_reality_count);
    if (new_reality_count > ideal_count) {
        master_plan_item_count_cell.addClass('warning');
    } else {
        master_plan_item_count_cell.removeClass('warning');
    }

    highlight_changing_items(target);

    delete_spot_plan_item(target.data('spot-plan-item-id'), target);
}

function get_master_plan_item_reality_count_cell(target) {
    var master_plan_item_id = target.data('master-plan-item-id');
    return $('.reality_count.master_plan_item_' + master_plan_item_id);
}

function get_master_plan_item_ideal_count_cell(target) {
    var master_plan_item_id = target.data('master-plan-item-id');
    return $('.ideal_count.master_plan_item_' + master_plan_item_id);
}

function change_spot_plan_item_and_master_plan_item_counts(original_count, new_count, target) {
    var master_plan_item_count_cell = get_master_plan_item_reality_count_cell(target);
    var master_plan_item_ideal_count_cell = get_master_plan_item_ideal_count_cell(target);

    var reality_count = parseInt(master_plan_item_count_cell.data('count'));
    var ideal_count = parseInt(master_plan_item_ideal_count_cell.data('count'));
    var new_reality_count = reality_count - original_count + new_count;

    target.text(new_count);

    master_plan_item_count_cell.text(new_reality_count);
    if (new_reality_count > ideal_count) {
        master_plan_item_count_cell.addClass('warning');
    } else {
        master_plan_item_count_cell.removeClass('warning');
    }
}

function highlight_changing_items(target) {
    target.css('background-color', 'yellow');
    var master_plan_item_count_cell = get_master_plan_item_reality_count_cell(target);
    master_plan_item_count_cell.css('background-color', 'yellow');
}

function complete_spot_plan_item_operation(target) {
    target.animate({'background-color': 'transparent'}, 500);
    var master_plan_item_count_cell = get_master_plan_item_reality_count_cell(target);
    master_plan_item_count_cell.animate({'background-color' : 'transparent'}, 500);

    console.log("target text: " + target.text());
    console.log('target count: ' + target.data('count'));

    console.log("master plan item text: " + master_plan_item_count_cell.text());
    console.log('master plan item reality count: ' + master_plan_item_count_cell.data('count'));
}

function recover_spot_plan_item_original_data(target) {
    target.text(target.data('count'));
    var master_plan_item_count_cell = get_master_plan_item_reality_count_cell(target);
    master_plan_item_count_cell.text(master_plan_item_count_cell.data('count'));
}

function update_spot_plan_item_values(target, data) {
    if (data == null) {
        target
            .data('spot-plan-item-easy-id', null)
            .data('spot-plan-item-id', null)
            .data('count', null);

        var master_plan_item_count_cell = get_master_plan_item_reality_count_cell(target);
        master_plan_item_count_cell.data('count', master_plan_item_count_cell.text());

        console.log('spot plan item count ' + target.data('count'));

        $('#confirm-spot-plan-button').show();
    } else {
        target
            .data('placed-at', data['placed_at'])
            .data('master-plan-item-id', data['master_plan_item_id'])
            .data('version', data['version'])
            .data('spot-plan-item-easy-id', data['easy_id'])
            .data('spot-plan-item-id', data['id'])
            .data('count', data['count']);

        var master_plan_item_count_cell = get_master_plan_item_reality_count_cell(target);
        master_plan_item_count_cell.data('count', data['master_plan_item_reality_count']);

        if (data['master_plan_is_dirty'] == true) {
            $('#confirm-spot-plan-button').show();
        }
    }
}

function modify_spot_plan_item_count(spot_plan_item_id, count, target) {
    $.ajax({
        url: '/spot_plan_items/' + spot_plan_item_id + '.json',
        type: 'PUT',
        data: {
            id: spot_plan_item_id,
            'spot_plan_item': {
                'count' : count
            }
        },
        success: function(data) {
            update_spot_plan_item_values(target, data);
        },
        complete: function() {
            complete_spot_plan_item_operation(target);
        },
        error: function() {
            recover_spot_plan_item_original_data(target);
        }
    });
}

function modify_spot_plan_item_placed_at(spot_plan_item_id, new_placed_at, target, new_target) {
    $.ajax({
        url: '/spot_plan_items/' + spot_plan_item_id + '/modify_placed_at.json',
        type: 'POST',
        data: {
            id: spot_plan_item_id,
            'spot_plan_item': {
                'placed_at' : new_placed_at
            }
        },
        success: function(data) {
            update_spot_plan_item_values(target, data['origin']);
            if (new_target != null) {
                update_spot_plan_item_values(new_target, data['new_item']);
            }
        },
        complete: function() {
            complete_spot_plan_item_operation(target);
        },
        error: function() {
            recover_spot_plan_item_original_data(target);
        }
    });
}

function create_spot_plan_item(master_plan_id, master_plan_item_id, placed_at, count, version, target) {

    $.ajax({
        url: '/spot_plan_items.json',
        type: 'POST',
        data: {
            'spot_plan_item': {
                'master_plan_id'        : master_plan_id,
                'master_plan_item_id'   : master_plan_item_id,
                'placed_at'             : placed_at,
                'count'                 : count,
                'version'               : version
            }
        },
        success: function(data, status, xhr) {
            update_spot_plan_item_values(target, data);
        },
        complete: function() {
            complete_spot_plan_item_operation(target);
        },
        error: function() {
            recover_spot_plan_item_original_data(target);
        }
    });
}

function delete_spot_plan_item(spot_plan_item_id, target) {
    $.ajax({
        url: '/spot_plan_items/' + spot_plan_item_id + '.json',
        type: 'DELETE',
        success: function(data, status, xhr) {
            update_spot_plan_item_values(target, null);
        },
        complete: function() {
            complete_spot_plan_item_operation(target);
        },
        error: function() {
            recover_spot_plan_item_original_data(target);
        }
    });
}

function attach_context_menu(target_name) {
    $.contextMenu({
        selector: target_name,
        build: function ($trigger, e){
            var target = $trigger;
            return {
                callback: function() {},
                items: {
                    adjustCount: {
                        name: '调整数量',
                        callback: function(key, options) {
                            $('#spot_plan_item_count').val(target.data('count'));
                            $('#spot-plan-item-modify-count-modal .submit')
                                .off('click').on('click', function() {
                                    var new_count = parseInt($('#spot_plan_item_count').val());
                                    click_spot_plan_item(target, new_count);
                                    $('#spot-plan-item-modify-count-modal').modal('hide');
                                });
                            $('#spot-plan-item-modify-count-modal').modal();
                        }
                    },
                    adjustPlacedAt: {
                        name: '移动日期',
                        callback: function(key, options) {
                            $('#spot_plan_item_placed_at').parent().data('datetimepicker').setDate(new Date(target.data('placed-at')));
                            $('#spot-plan-item-modify-placed-at-modal .submit')
                                .off('click').on('click', function() {
                                    var new_placed_at = $('#spot_plan_item_placed_at').val();
                                    var spot_plan_item_id = target.data('spot-plan-item-id');
                                    var count = parseInt(target.data('count'));
                                    var master_plan_item_id = target.data('master-plan-item-id');

                                    var new_target_name = get_easy_id(new_placed_at, master_plan_item_id);
                                    var new_target = $('.' + new_target_name);

                                    change_spot_plan_item_and_master_plan_item_counts(count, 0, target);
                                    change_spot_plan_item_and_master_plan_item_counts(0, count, new_target);

                                    highlight_changing_items(target);
                                    highlight_changing_items(new_target);

                                    modify_spot_plan_item_placed_at(spot_plan_item_id, new_placed_at, target, new_target);
                                    $('#spot-plan-item-modify-placed-at-modal').modal('hide');
                                });
                            $('#spot-plan-item-modify-placed-at-modal').modal();
                        }
                    },
                    resetCount: {
                        name: '删除',
                        callback: function(key, options) {
                            reset_spot_plan_item_count(target);
                        }
                    }
                }
            };
        }
    });
}

function get_easy_id(placed_at, master_plan_item_id) {
    return 'SPI_' + master_plan_item_id + '_' + moment(placed_at).format('YYYYMMDD')
}
