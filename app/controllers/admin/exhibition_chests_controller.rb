class Admin::ExhibitionChestsController < ApplicationController
  before_action :set_exhibition_chest, only: [:release, :show, :update, :destroy]
  include ActionView::Layouts
  include ActionController::MimeResponds

  acts_as_token_authentication_handler_for Admin
  respond_to :json

  def index
    user = User.find(params[:user_id])
    @exhibition_chests = user ? 
      ExhibitionChestViewService.new(user.exhibition_chests).in_user_index :
      ExhibitionChest.all
    respond_with(@exhibition_chests)
  end

  def show
    respond_with(@exhibition_chest)
  end

  # def create
  #   @exhibition_chest = ExhibitionChest.new(exhibition_chest_params)
  #   @exhibition_chest.save
  #   respond_with(@exhibition_chest)
  # end

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
      respond_with @exhibition_chest, template: 'exhibition_chests/show', status: 201
    end
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
