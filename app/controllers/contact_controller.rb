class ContactController < ApplicationController
def new
    @message = Message.new
end

  def create
      @message = Message.new(contact_params)
      UserMailer.welcome_email(@message).deliver
      redirect_to(root_path, :notice => "Message was successfully sent.")
  end

end

def contact_params
    params.require(:message).permit!
  end