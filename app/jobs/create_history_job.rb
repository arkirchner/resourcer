class CreateHistoryJob < ApplicationJob
  queue_as :default

  def perform(request_id)
    History.create_for_request(request_id)
  end
end
