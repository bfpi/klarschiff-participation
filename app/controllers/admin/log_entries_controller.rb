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
      case order_params[:column]
      when 'user'
        [User.arel_table[:name].send(order_dir), LogEntry.arel_table[:created_at].send(order_dir)]
      when 'created_at'
        LogEntry.arel_table[:created_at].send order_dir
      else
        super
      end
    end
  end
end
