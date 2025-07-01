# frozen_string_literal: true

module Admin
  class ParticipationsController < AdminController
    def index
      @participations = Participation.order(created_at: :desc).page(page).per(per_page)
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
      params.expect(participation: permitted_attributes)
    end

    def permitted_attributes
      %i[authority_address authority_email authority_name contact_email contact_name contact_phone effectiveness_date
         name_of_the_signatory official_email_authority partner_number ra_activate_date ra_active ra_email ra_name
         ra_note ra_phone ra_train_date ra_trained ra_training role withdrawal_effectiveness_date
         withdrawal_effectiveness_date_corrected withdrawal_name_of_the_signatory withdrawal_receipt_date]
    end
  end
end
