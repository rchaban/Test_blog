class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include FriendshipHelper

  helper_method :mailbox
  
  private
 
  def mailbox
    @mailbox ||= current_user.mailbox
  end
end
