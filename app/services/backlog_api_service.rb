class BacklogApiService
  attr_reader :client, :target_milestone
  include ActionView::Helpers::TextHelper
  require 'backlog_kit'

  COUNT=100
  PROJECT_ID=39284

  def initialize(options={})
    @client = BacklogKit::Client.new(space_id: ENV['BACKLOG_SPACE_ID'], api_key: ENV['BACKLOG_API_KEY'])
    @target_milestone = options.delete(:milestone) || '2017_07_05'
  end

  def summaries
    summaries = []
    issues.each do|i|
      summaries << build_issue_summary(i)
    end
    summaries
  end

  def estimated_point(summaries)
    summaries.sum {|i| i[:estimate]}
  end

  def completed_point(summaries)
    summaries.select {|i| i[:status] == '処理済み' || i[:status] == '完了'}.sum {|i| i[:estimate]}
  end

  private

  def build_issue_summary(issue)
    {
      user: issue.assignee.name,
      status: issue.status.name,
      summary: "#{issue.summary.truncate(30)}(#{issue.assignee.name})",
      priority: priority(issue),
      estimate: estimate(issue),
      progress: judge_progress(issue.status.name, estimate(issue)),
      actual_hours: issue.actual_hours || 0,
      estimated_hours: issue.estimated_hours || 0,
    }
  end

  def project_id
    self.class::PROJECT_ID
  end

  def count
    self.class::COUNT
  end

  def issues
    client.get_issues(milestone_id: [milestone.id], issue_type_id: issue_type_ids.uniq, count: count).body
  end

  def milestones
    client.get_versions(project_id).body.map(&:name)
  end

  def milestone
    client.get_versions(project_id).body.select {|m| m.name == target_milestone}.first
  end

  def issue_type_ids
    client.get_issue_types(project_id).body.select {|it| it.name == 'ＰＢＩ' || it.name == '不具合' }.map(&:id)
  end

  def estimate(issue)
    issue.custom_fields.select {|cf| cf.name == '見積'}.first.value || 0
  end

  def priority(issue)
    issue.custom_fields.select {|cf| cf.name == '着手順'}.first.value || 0
  end

  def judge_progress(status, estimate)
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
