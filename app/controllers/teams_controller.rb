class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def show
    @member = Team.find(params[:id])
  end
end
