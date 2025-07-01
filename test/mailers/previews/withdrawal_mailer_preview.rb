# frozen_string_literal: true

class WithdrawalMailerPreview < ActionMailer::Preview
  def informed_withdrawal
    WithdrawalMailer.informed_withdrawal(Participation.new(contact_name: 'Contact-Name'))
  end

  def provide_withdrawal
    WithdrawalMailer.provide_withdrawal(Participation.new)
  end

  def withdraw
    WithdrawalMailer.withdraw(Participation.new(withdrawal_receipt_date: Date.yesterday,
                                                withdrawal_effectiveness_date: 2.days.from_now))
  end

  def withdraw_corrected
    WithdrawalMailer.withdraw(Participation.new(withdrawal_receipt_date: Date.yesterday,
                                                withdrawal_effectiveness_date_corrected: Date.tomorrow,
                                                withdrawal_effectiveness_date: 2.days.from_now))
  end
end
