# frozen_string_literal: true

require 'test_helper'

class JoiningMailerTest < ActionMailer::TestCase
  test 'informed' do
    mail = JoiningMailer.informed(participation(:prepared))

    assert_equal 'Klarschiff-MV: Mitteilung zur Beitrittserklärung', mail.subject
    assert_equal ['contact_email_prepared@example.com'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Sie wurden als Ansprechperson in der Interessenbekundung Ihrer Behörde zum Beitritt zum Verbund',
                 mail.body.encoded
  end

  test 'provide' do
    mail = JoiningMailer.provide(participation(:call_back))

    assert_equal 'Klarschiff-MV: Ihre Beitrittserklärung', mail.subject
    assert_equal ['official_email_authority_call_back@example.com'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Ihre Behörde hat Interesse bekundet', mail.body.encoded
  end

  test 'joining' do
    mail = JoiningMailer.joining(participation(:call_back))

    assert_equal 'KOPIE: Beitrittserklärung zum Kooperationsverbund „KLARSCHIFF-MV“', mail.subject
    assert_equal ['email@leading_cooperation_partner.de'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'hiermit erklärt authority_name_call_back, authority_address_call_back den Beitritt', mail.body.encoded
  end
end
