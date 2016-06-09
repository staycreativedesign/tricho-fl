class Admin::TeamsController < AdminsController
  def index
    @members = Team.all
  end

  def show
    find_team_member
  end

  def edit
    find_team_member
  end

  def update
    find_team_member
    @member.update_attributes(member_params)
    redirect_to admin_teams_path
    flash[:notice] = "Team member updated"
  end

  def new
    @member = Team.new
  end

  def create
    @member = Team.new(member_params)
    if @member.save
      redirect_to admin_teams_path
      flash[:notice] = "Team member created"
    end
  end

  def destroy
    find_team_member
    @member.destroy
    redirecto_to admin_teams_path
    flash[:notice] = "Team member deleted"
  end

  private

  def member_params
    params.require(:team).permit!
  end

  def find_team_member
    @member = Team.find(params[:id])
  end
end
