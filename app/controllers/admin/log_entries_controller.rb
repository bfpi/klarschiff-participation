# frozen_string_literal: true

module Admin
  class LogEntriesController < AdminController
    include Sorting
    before_action -> { check_authorization(:admin) }

    def index
      @log_entries = LogEntry.includes(:user).joins(:user).order(order_attr)
                             .page(params[:page] || 1).per(params[:per_page] || 20)
    end

    def custom_order(col, dir)
      case col.to_sym
      when :user
        [user_arel_table[:last_name].send(dir), user_arel_table[:first_name].send(dir)]
      end
    end

    def default_order
      { created_at: :desc }
    end
  end
end
