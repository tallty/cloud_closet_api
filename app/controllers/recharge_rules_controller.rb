class RechargeRulesController < ApplicationController
  include ActionView::Layouts
  include ActionController::MimeResponds

  before_action :set_recharge_rule, only: [:show, :update, :destroy, :pay_by_balance, :cancel]

  respond_to :json

  def index
    @recharge_rules = RechargeRule.all
    respond_with(@recharge_rules)
  end

  def show
    respond_with(@recharge_rule)
  end

  # def create
  #   @recharge_rule = current_user.recharge_rules.build(recharge_rule_params)
  #   @recharge_rule.save
  #   respond_with @recharge_rule, template: "recharge_rules/show", status: 201
  # end

  # def update
  #   @recharge_rule.update(recharge_rule_params)
  #   respond_with(@recharge_rule)
  # end

  # def destroy
  #   @recharge_rule.destroy
  #   respond_with(@recharge_rule)
  # end


  private
    def set_recharge_rule
      @recharge_rule = RechargeRule.find(params[:id])
    end

    def recharge_rule_params
      params.require(:recharge_rule).permit(
        )
    end
end
