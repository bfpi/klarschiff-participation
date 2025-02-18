# frozen_string_literal: true

module Admin
  class ParticipationsController < AdminController
    def index
      @participations = Participation.order(created_at: :desc).page(params[:page] || 1).per(params[:per_page] || 20)
    end

    def edit
      @entry = Participation.find(params[:id])
    end

    def update
      @entry = Participation.find(params[:id])
      if @entry.update(entry_params) && params[:save_and_close].present?
        redirect_to action: :index
      else
        render action: :edit
      end
    end

    private

    def entry_params
      params.require(:participation).permit(permitted_attributes)
    end

    def permitted_attributes
      attributes = %i[authority_name authority_address authority_email contact_name contact_email contact_phone
                      partner_number name_of_the_signatory official_email_authority effectiveness_date
                      withdrawal_receipt_date withdrawal_name_of_the_signatory withdrawal_effectiveness_date
                      withdrawal_effectiveness_date_corrected status role]
      return attributes unless Current.user.role_admin?

      attributes << %i[leading_cooperation_partner_name leading_cooperation_partner_address
                       leading_cooperation_partner_email]
      attributes
    end
  end
end
