# frozen_string_literal: true

class JoiningMailerPreview < ActionMailer::Preview
  def informed
    JoiningMailer.informed(Participation.new(contact_name: 'Contact-Name'))
  end

  def provide
    JoiningMailer.provide(Participation.new)
  end

  def joining
    JoiningMailer.joining(Participation.new(joining_data))
  end

  private

  def joining_data
    {
      authority_name: 'Authority-Name',
      authority_address: 'Authority-Address',
      place_of_signature: 'Signature Place',
      name_of_the_signatory: 'Signature Name'
    }
  end
end
