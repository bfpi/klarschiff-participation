# frozen_string_literal: true

require 'test_helper'

class ParticipationTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test 'validate authority_name presence' do
    participation = Participation.new

    assert_not participation.valid?
    assert_equal [{ error: :blank }], participation.errors.details[:authority_name]
    participation.authority_name = 'authority_name'
    participation.valid?

    assert_empty participation.errors.details[:authority_name]
  end

  test 'validate authority_address presence' do
    participation = Participation.new

    assert_not participation.valid?
    assert_equal [{ error: :blank }], participation.errors.details[:authority_address]
    participation.authority_address = 'authority_address'
    participation.valid?

    assert_empty participation.errors.details[:authority_address]
  end

  test 'validate authority_email presence' do
    participation = Participation.new

    assert_not participation.valid?
    assert_equal [{ error: :blank }], participation.errors.details[:authority_email]
    participation.authority_email = 'authority_email'

    assert_not participation.valid?
    assert_equal [{ error: :invalid }], participation.errors.details[:authority_email]
    participation.authority_email = 'authority_email@example.com'
    participation.valid?

    assert_empty participation.errors.details[:authority_email]
  end

  test 'validate contact_name presence' do
    participation = Participation.new

    assert_not participation.valid?
    assert_equal [{ error: :blank }], participation.errors.details[:contact_name]
    participation.contact_name = 'contact_name'
    participation.valid?

    assert_empty participation.errors.details[:contact_name]
  end

  test 'validate contact_email presence' do
    participation = Participation.new

    assert_not participation.valid?
    assert_equal [{ error: :blank }], participation.errors.details[:contact_email]
    participation.contact_email = 'contact_email'

    assert_not participation.valid?
    assert_equal [{ error: :invalid }], participation.errors.details[:contact_email]
    participation.contact_email = 'contact_email@example.com'
    participation.valid?

    assert_empty participation.errors.details[:contact_email]
  end

  test 'validate contact_phone presence' do
    participation = Participation.new

    assert_not participation.valid?
    assert_equal [{ error: :blank }], participation.errors.details[:contact_phone]
    participation.contact_phone = 'contact_phone'
    participation.valid?

    assert_empty participation.errors.details[:contact_phone]
  end

  test 'notify prepared participation while status informed' do
    participation = participation(:prepared)
    assert_emails 1 do
      participation.status_informed!
    end
    assert_equal ['Klarschiff-MV: Mitteilung zur Beitrittserklärung'], ActionMailer::Base.deliveries.map(&:subject).uniq
  end

  test 'notify informed participation while status provide' do
    participation = participation(:informed)
    assert_emails 1 do
      participation.status_provide!
    end
    assert_equal ['Klarschiff-MV: Ihre Beitrittserklärung'], ActionMailer::Base.deliveries.map(&:subject).uniq
  end

  test 'notify provide participation while status joining' do
    participation = participation(:provide)
    participation.place_of_signature = 'place_of_signature'
    participation.name_of_the_signatory = 'name_of_the_signatory'
    participation.status_joining!

    assert_not_nil participation.effectiveness_date
    assert_equal ['KOPIE: Beitrittserklärung zum Kooperationsverbund „KLARSCHIFF-MV“'], ActionMailer::Base.deliveries.map(&:subject).uniq
  end

  test 'notify joined participation while status informed_withdrawal' do
    participation = participation(:joined)
    assert_emails 1 do
      participation.status_informed_withdrawal!
    end
    assert_equal ['Klarschiff-MV: Mitteilung zur Austrittserklärung'], ActionMailer::Base.deliveries.map(&:subject).uniq
  end

  test 'notify informed_withdrawal participation while status provide_withdrawal' do
    participation = participation(:informed_withdrawal)
    assert_emails 1 do
      participation.status_provide_withdrawal!
    end
    assert_equal ['Klarschiff-MV: Ihre Austrittserklärung'], ActionMailer::Base.deliveries.map(&:subject).uniq
  end

  test 'notify provide_withdrawal participation while status provide_withdrawal' do
    participation = participation(:provide_withdrawal)
    participation.withdrawal_effectiveness_date = Time.zone.today
    participation.place_of_signature = 'place_of_signature'
    participation.withdrawal_name_of_the_signatory = 'name_of_the_signatory'
    participation.status_withdrawal!

    assert_not_nil participation.withdrawal_effectiveness_date
  end

  test 'notify withdrawal participation while status withdrawal_check' do
    participation = participation(:provide_withdrawal)
    participation.status_withdrawal_check!

    assert_not_nil participation.withdrawal_receipt_date
  end
end
