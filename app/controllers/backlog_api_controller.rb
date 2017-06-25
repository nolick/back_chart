class BacklogApiController < ApplicationController
  require 'backlog_kit'
  before_action :intialize_backlog_client

  def milestones
    milestones = @client.get('projects/39284/versions')
    render json: milestones
  end

  def issues
    milestone = params[:milestone] || '2017_07_05'
    issues = @client.get_issues.body.select do |i|
      if i.milestone.present?
        i.milestone.first.name == milestone
      else
        false
      end
    end
    render json: issues
  end

  private

  #TODO: isolated from controller by service class
  # https://www.sitepoint.com/ddd-for-rails-developers-part-1-layered-architecture/
  def intialize_backlog_client
    @client ||= BacklogKit::Client.new(
      space_id: 'rebecca',
      api_key: '',
    )
  end
end
