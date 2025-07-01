# frozen_string_literal: true

require 'test_helper'

class ResignationMailerTest < ActionMailer::TestCase
  test 'informed_resignation' do
    mail = ResignationMailer.informed_resignation(participation(:informed_resignation))

    assert_equal 'Klarschiff-MV: Mitteilung zur Austrittserklärung', mail.subject
    assert_equal ['contact_email_informed_resignation@example.com'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Wir haben den Wunsch nach Austritt aus dem Verbund zur Kenntnis genommen', mail.body.encoded
  end

  test 'provide_resignation' do
    mail = ResignationMailer.provide_resignation(participation(:provide_resignation))

    assert_equal 'Klarschiff-MV: Ihre Austrittserklärung', mail.subject
    assert_equal ['official_email_authority_provide_resignation@example.com'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Ihre Behörde möchte aus der', mail.body.encoded
  end

  test 'resigned' do
    mail = ResignationMailer.resigned(participation(:resigned))

    assert_equal 'Klarschiff-MV: Bestätigung der Austrittserklärung', mail.subject
    assert_equal ['official_email_authority_resigned@example.com'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Bestätigung des Eingangs der Austrittserklärung', mail.body.encoded
  end
end
