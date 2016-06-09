class Admin::EventsController < AdminsController
  def index
    @events = Event.all
  end

  def show
    find_event
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to admin_events_path
      flash[:notice] = "Event Created"
    else
      render :new
      flash[:notice] = "Event not created, please try again."
    end
  end

  def edit
    find_event
  end

  def update
    find_event
    @event.update_attributes(event_params)
    redirect_to admin_events_path
    flash[:notice] = "Event updated"
  end

  def destroy
    find_event
    @event.destroy
    redirect_to admin_events_path
    flash[:notice] = "Event Deleted"
  end

  private

  def find_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit!
  end
end
