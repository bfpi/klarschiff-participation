# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    before_action -> { check_authorization(:admin) }

    def index
      @entries = User.active.order(:login).page(page).per(per_page)
    end

    def new
      @entry = User.new
    end

    def edit
      @entry = User.find(params[:id])
    end

    def create
      @entry = User.new({ active: true }.merge(entry_params))
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
      params.expect(user: %i[name login password password_confirmation role])
    end
  end
end
