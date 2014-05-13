var master_plan = null;
var master_plan_summary_view = null;

$(document).ready(function() {
    MasterPlan = Backbone.Model.extend({urlRoot: '/master_plans'});
    MasterPlanSummaryView = Backbone.View.extend({
        initialize: function() {
            this.listenTo(this.model, 'change', this.render);
        },
        render: function() {
            $('#master-plan-summary .project-budget').text(
                accounting.formatMoney(
                    this.model.get('budget'),
                    {
                        symbol: '￥',
                        format: '%s %v',
                        precision: 0
                    })
                );
            $('#master-plan-summary .medium-net-cost').text(
                accounting.formatMoney(
                    this.model.get('medium_net_cost'),
                    {
                        symbol: '￥',
                        format: '%s %v',
                        precision: 0
                    })
                );
            $('#master-plan-summary .company-net-cost').text(
                accounting.formatMoney(
                    this.model.get('company_net_cost'),
                    {
                        symbol: '￥',
                        format: '%s %v',
                        precision: 0
                    })
                );
            $('#master-plan-summary .profit').text(
                accounting.formatMoney(
                    this.model.get('profit'),
                    {
                        symbol: '￥',
                        format: '%s %v',
                        precision: 0
                    })
                );
            return this;
        }
    });

    if(master_plan == null) {
        master_plan = new MasterPlan({id: $('#master-plan-id-value').text()});
    }

    if(master_plan_summary_view == null) {
        master_plan_summary_view = new MasterPlanSummaryView({model: master_plan});
    }

    update_master_plan_summary();
});

function update_master_plan_summary() {
    master_plan.fetch();
}
