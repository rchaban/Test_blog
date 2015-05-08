class MailboxController < ApplicationController
  before_action :authenticate_user!
 
  def inbox
    @inbox = mailbox.inbox
    @active = :inbox
  end
 
  def sent
    @sent = mailbox.sentbox
    @active = :sent
  end
 
  def trash
    @trash = mailbox.trash
    @active = :trash
  end

  def unread_messages_count
    # how to get the number of unread messages for the current user
    # using mailboxer
    mailbox.inbox(:unread => true).count(:id, :distinct => true)
  end

end
