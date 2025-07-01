# frozen_string_literal: true

class ResignationMailerPreview < ActionMailer::Preview
  def informed_resignation
    ResignationMailer.informed_resignation(Participation.new(contact_name: 'Contact-Name'))
  end

  def provide_resignation
    ResignationMailer.provide_resignation(Participation.new)
  end

  def resigned
    ResignationMailer.resigned(Participation.new(withdrawal_receipt_date: Date.yesterday,
                                                 withdrawal_effectiveness_date: 2.days.from_now))
  end

  def resigned_corrected
    ResignationMailer.resigned(Participation.new(withdrawal_receipt_date: Date.yesterday,
                                                 withdrawal_effectiveness_date_corrected: Date.tomorrow,
                                                 withdrawal_effectiveness_date: 2.days.from_now))
  end
end
