var medium_master_plan = null;
var medium_master_plan_summary_view = null;

$(document).ready(function() {
    var MediumMasterPlan = Backbone.Model.extend({urlRoot: '/medium_master_plans'});
    var MediumMasterPlanSummaryView = Backbone.View.extend({
        initialize: function() {
            this.listenTo(this.model, 'change', this.render);
        },
        render: function() {
            $('#medium-master-plan-summary .medium-net-cost').text(
                accounting.formatMoney(
                    this.model.get('medium_net_cost'),
                    {
                        symbol: '￥',
                        format: '%s %v',
                        precision: 0
                    })
                );
            $('#medium-master-plan-summary .company-net-cost').text(
                accounting.formatMoney(
                    this.model.get('company_net_cost'),
                    {
                        symbol: '￥',
                        format: '%s %v',
                        precision: 0
                    })
                );
            $('#medium-master-plan-summary .profit').text(
                accounting.formatMoney(
                    this.model.get('profit'),
                    {
                        symbol: '￥',
                        format: '%s %v',
                        precision: 0
                    })
                );
            $('#medium-master-plan-summary .bonus-ratio').text(this.model.get('bonus_ratio'));
            $('#medium-master-plan-summary .medium-bonus-ratio').text(this.model.get('medium_bonus_ratio'));
            $('#medium-master-plan-summary .company-bonus-ratio').text(this.model.get('company_bonus_ratio'));
            return this;
        }
    });

    if(medium_master_plan == null) {
        medium_master_plan = new MediumMasterPlan({id: $('#medium-master-plan-id-value').text()});
    }

    if(medium_master_plan_summary_view == null) {
        medium_master_plan_summary_view = new MediumMasterPlanSummaryView({model: medium_master_plan});
    }

    update_medium_master_plan_summary();

    $('#medium-master-plan-summary .inline-editable-field').editable({
        mode: 'inline',
        success: function() {
            update_medium_master_plan_summary();
            update_master_plan_summary();
        }
    });

    $('#medium-master-plan-summary .editable-field').editable({
        success: function() {
            update_medium_master_plan_summary();
            update_master_plan_summary();
        }
    });
});

function update_medium_master_plan_summary() {
    medium_master_plan.fetch();
}
