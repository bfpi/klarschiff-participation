# frozen_string_literal: true

module Sorting
  extend ActiveSupport::Concern

  included do
    helper_method :order_params
  end

  private

  def order_params
    params.fetch(:order_by, {}).permit(%i[column dir])
  end

  def order
    order_params[:column] || :created_at => order_dir
  end

  def order_dir
    order_params[:dir]&.match?(/^(a|de)sc$/i) ? order_params[:dir] : :desc
  end
end
