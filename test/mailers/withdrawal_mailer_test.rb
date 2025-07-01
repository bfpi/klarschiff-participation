# frozen_string_literal: true

require 'test_helper'

class WithdrawalMailerTest < ActionMailer::TestCase
  test 'informed_withdrawal' do
    mail = WithdrawalMailer.informed_withdrawal(participation(:informed_withdrawal))

    assert_equal 'Klarschiff-MV: Mitteilung zur Austrittserklärung', mail.subject
    assert_equal ['contact_email_informed_withdrawal@example.com'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Wir haben den Wunsch nach Austritt aus dem Verbund zur Kenntnis genommen', mail.body.encoded
  end

  test 'provide_withdrawal' do
    mail = WithdrawalMailer.provide_withdrawal(participation(:provide_withdrawal))

    assert_equal 'Klarschiff-MV: Ihre Austrittserklärung', mail.subject
    assert_equal ['official_email_authority_provide_withdrawal@example.com'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Ihre Behörde möchte aus der', mail.body.encoded
  end

  test 'withdraw' do
    mail = WithdrawalMailer.withdraw(participation(:withdraw))

    assert_equal 'Klarschiff-MV: Bestätigung der Austrittserklärung', mail.subject
    assert_equal ['official_email_authority_withdraw@example.com'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Bestätigung des Eingangs der Austrittserklärung', mail.body.encoded
  end
end
