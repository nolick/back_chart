class BacklogApiController < ApplicationController
  COUNT=100
  PROJECT_ID=39284

  require 'backlog_kit'
  before_action :intialize_backlog_client

  def milestones
    milestones = @client.get_versions(PROJECT_ID).body.map(&:name)
    render json: milestones
  end

  def issues
    target_milestone = params[:milestone] || 'S0621_SS入力3'
    milestone = @client.get_versions(PROJECT_ID).body.select {|m| m.name == target_milestone}.first
    issue_type_id = @client.get_issue_types(PROJECT_ID).body.select{|it| it.name == 'ＰＢＩ'}.first.id

    issue_summaries = []
    issues = @client.get_issues(milestone_id: [milestone.id], issue_type_id: [issue_type_id], count: COUNT).body
    issues.each do|i|
      estimate = i.custom_fields.select{|cf| cf.name == '見積'}.first.value || 0
      priority = i.custom_fields.select{|cf| cf.name == '着手順'}.first.value || 0
      issue_summaries << {
        id: i.id,
        user: i.assignee.name,
        status: i.status.name,
        summary: i.summary,
        estimate: estimate,
        priority: priority,
        progress: judge_progress(i.status.name, estimate),
        actual_hours: i.actual_hours || 0,
        estimated_hours: i.estimated_hours || 0,
      }
    end
    render json: issue_summaries.group_by{|is| is[:user]}
  end

  private

  #TODO: isolated from controller by service class
  # https://www.sitepoint.com/ddd-for-rails-developers-part-1-layered-architecture/
  def intialize_backlog_client
    @client ||= BacklogKit::Client.new( space_id: 'rebecca',
      api_key: '',
    )
  end

  def judge_progress(status, estimate)
    p status
    case status
    when '未対応'
      0
    when '処理中'
      estimate / 2
    when '処理済み', '完了'
      estimate
    else
      0
    end
  end
end
