class BacklogApiController < ApplicationController
  def summaries
    backlog_api_service = BacklogApiService.new
    summaries= backlog_api_service.summaries
    estimated_point = backlog_api_service.estimated_point summaries
    completed_point = backlog_api_service.completed_point summaries

    render json: [estimated_point, completed_point, summaries]
  end
end
