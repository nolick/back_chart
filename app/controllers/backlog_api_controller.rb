class BacklogApiController < ApplicationController
  require 'backlog_kit'

  def index
    client = BacklogKit::Client.new(
      space_id: 'rebecca',
      api_key: 'KR3zcYkiA0mdoeKuIEICfYaYxvVwAiX7xEtLh9GjLQnv4MJDkbdYCgpkibf9sROQ',
    )
    render json: client.get_versions(projectIdOrKey: 39284)
    versions = client.get('projects/39284/versions')
    versions.body.select {|b| b.name == "2017_08_02"}
  end
end
