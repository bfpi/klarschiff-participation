# frozen_string_literal: true

module Admin
  class MasterDataController < AdminController
    def edit
      @entry = MasterData.first
    end

    def update
      @entry = MasterData.first
      if @entry.update(entry_params) && params[:save_and_close].present?
        redirect_to action: :index
      else
        render action: :edit
      end
    end

    private

    def entry_params
      params.expect(master_data: permitted_attributes)
    end

    def permitted_attributes
      %i[leading_cooperation_partner_name leading_cooperation_partner_address
         leading_cooperation_partner_email]
    end
  end
end
