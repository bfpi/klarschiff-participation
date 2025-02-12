# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    before_action -> { check_authorization(:admin) }

    def index
      @entries = User.order(:login).page(params[:page] || 1).per(params[:per_page] || 20)
    end

    def new
      @entry = User.new(params[:entry])
    end

    def edit
      @entry = User.find(params[:id])
    end

    def create
      @entry = User.new entry_params
      if @entry.save
        if params[:save_and_close].present?
          redirect_to action: :index
        else
          redirect_to edit_admin_user_path(@entry)
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      @entry = User.find(params[:id])
      if @entry.update(entry_params) && params[:save_and_close].present?
        redirect_to action: :index
      else
        redirect_to edit_admin_user_path(@entry)
      end
    end

    def destroy
      @entry = User.find(params[:id])
      redirect_to action: :index if @entry.update active: false
    end

    private

    def entry_params
      e_params = params.require(:user)
      e_params.permit(:name, :login, :password, :password_confirmation, :role)
    end
  end
end
