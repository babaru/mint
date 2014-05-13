$(document).ready(function() {
  $('#medium-master-plan-items-grid .editable-field').editable({
    success: function(data) {
      update_master_plan_summary();
      update_medium_master_plan_summary();
      update_master_plan_item_fields(data);
      update_estimation_fields(data);
    }
  });

  $('#medium-master-plan-items-grid .est-editable-field').editable({
    success: function(data) {
      update_estimation_fields(data);
    }
  });

  $('.master_plan_item_is_on_house').click(function() {
    var item_id = $(this).data('id');
    var medium_id = $(this).data('medium-id');
    var val = $(this).data('value');
    var button = $(this);
    $.ajax({
      url: '/master_plan_items/' + item_id + '/modify?selected_medium_id=' + medium_id,
      type: 'POST',
      data: {
        name: 'is_on_house',
        value: val
      },
      success: function(data) {
        update_master_plan_summary();
        update_medium_master_plan_summary();

        var is_on_house = false;
        if(data["is_on_house"] == true) is_on_house = true;
        update_grid_content(is_on_house, button, data);
      },
    });
  })
});

function update_estimation_fields(data) {
  $('#master-plan-item-' + data['id'] + '-est-total-imp').text(data["est_total_imp"]);
  $('#master-plan-item-' + data['id'] + '-est-total-clicks').text(data["est_total_clicks"]);
  $('#master-plan-item-' + data['id'] + '-est-ctr').text(
    accounting.formatMoney(
        data["est_ctr"] * 100,
        {
            format: '%v%',
            precision: 2
        })
    );
}

function update_grid_content(is_on_house, button, data) {
  if (is_on_house) {
    button.parent().find('.btn.purchase').show();
    button.parent().find('.btn.on_house').hide();
    button.parent().closest('.master-plan-item-row').find('.master-plan-item-position-name').removeClass('is_on_house').addClass('is_on_house');
    button.parent().parent().find('.discounts').hide();
  } else {
    button.parent().find('.btn.purchase').hide();
    button.parent().find('.btn.on_house').show();
    update_master_plan_item_fields(data);
    button.parent().closest('.master-plan-item-row').find('.master-plan-item-position-name').removeClass('is_on_house');
    button.parent().parent().find('.discounts').show();
  }
}

function update_master_plan_item_fields(data) {
  $('#master-plan-item-' + data['id'] + ' .medium-net-cost').text(
    accounting.formatMoney(
        data['medium_net_cost'],
        {
          symbol: '￥',
          format: '%s %v',
          precision: 0
        })
    );
  $('#master-plan-item-' + data['id'] + ' .company-net-cost').text(
    accounting.formatMoney(
        data['company_net_cost'],
        {
          symbol: '￥',
          format: '%s %v',
          precision: 0
        })
    );
}
