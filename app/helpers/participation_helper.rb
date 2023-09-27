# frozen_string_literal: true

module ParticipationHelper
  def show_error_messages(participation, attribute)
    content_tag :div, participation.errors.full_messages_for(attribute).join(', '), class: 'text-danger'
  end
end
