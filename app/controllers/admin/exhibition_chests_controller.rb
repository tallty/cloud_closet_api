class Admin::ExhibitionChestsController < ApplicationController
  before_action :set_exhibition_chest, only: [:release, :update, :destroy, :lease_renewal]
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin
  respond_to :json

  def index
    @user = User.find_by_id(params[:user_id])
    @exhibition_chests = @user ? 
      # ExhibitionChestViewService.new(@user.exhibition_chests).in_user_index :
      @user.exhibition_chests :
      ExhibitionChest.all
    respond_with(@exhibition_chests)
  end

  def release
    @exhibition_chest.release!
    respond_with @exhibition_chest, template: 'exhibition_chests/show', status: 201
  rescue => @error
    respond_with @error, template: 'error', status: 422
  end

  def update
    if @exhibition_chest.need_join
      render( json: { error: '单礼服不支持修改上限，请添加或删除单礼服柜' }, status: 422 )
    else
      @exhibition_chest.update(exhibition_chest_params)
      respond_with @exhibition_chest, template: 'exhibition_chests/show', status: 200
    end
  end

  def lease_renewal
    @exhibition_chest.lease_renewal params[:renewal_month]
    respond_with @exhibition_chest, template: 'exhibition_chests/show', status: 201
  rescue => @error
    logger.info @error
    respond_with @error, template: 'error', status: 422
  end

  def destroy
    @exhibition_chest.destroy
    respond_with(@exhibition_chest)
  end

  private
    def set_exhibition_chest
      @exhibition_chest = ExhibitionChest.find(params[:id])
    end

    def exhibition_chest_params
      params.require(:exhibition_chest).permit(
        :max_count
      )
    end
end
