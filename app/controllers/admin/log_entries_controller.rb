# frozen_string_literal: true

module Admin
  class LogEntriesController < AdminController
    include Sorting

    before_action -> { check_authorization(:admin) }

    def index
      @log_entries = LogEntry.eager_load(:user).order(order).page(page).per(per_page)
    end

    private

    def order
      return super unless order_params[:column] == 'user'

      [user_arel_table[:last_name].send(order_dir), user_arel_table[:first_name].send(order_dir)]
    end
  end
end
