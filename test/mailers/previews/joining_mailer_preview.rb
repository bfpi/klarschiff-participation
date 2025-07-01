# frozen_string_literal: true

class JoiningMailerPreview < ActionMailer::Preview
  def informed
    JoiningMailer.informed(Participation.new(contact_name: 'Contact-Name'))
  end

  def provide
    JoiningMailer.provide(Participation.new)
  end
end
