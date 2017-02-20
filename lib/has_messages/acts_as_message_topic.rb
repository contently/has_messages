require 'state_machines-activerecord'

# Adds a generic implementation for sending messages between users
module ActsAsMessageTopic
  module MacroMethods
    # Creates the following message associations:
    # * +messages+ - Messages that were composed and are visible to the owner.
    #   Mesages may have been sent or unsent.
    # * +received_messages - Messages that have been received from others and
    #   are visible.  Messages may have been read or unread.
    #
    # == Creating new messages
    #
    # To create a new message, the +messages+ association should be used,
    # for example:
    #
    #   user = User.find(123)
    #   message = user.messages.build
    #   message.subject = 'Hello'
    #   message.body = 'How are you?'
    #   message.to User.find(456)
    #   message.save
    #   message.deliver
    #
    # == Drafts
    #
    # You can get the drafts for a particular user by using the +unsent_messages+
    # helper method.  This will find all messages in the "unsent" state.  For example,
    #
    #   user = User.find(123)
    #   user.unsent_messages
    #
    # You can also get at the messages that *have* been sent, using the +sent_messages+
    # helper method.  For example,
    #
    #  user = User.find(123)
    #  user.sent_messages
    def acts_as_message_topic
      has_many  :messages,
                  :as => :topic,
                  :class_name => 'Message',
                  :conditions => {:hidden_at => nil},
                  :order => 'messages.created_at DESC'

      include ActsAsMessageTopic::InstanceMethods
    end
  end

  module InstanceMethods
    def messages_for(receiver, recipient_state = nil)
      recipients_filter = MessageRecipient.with_receiver(receiver)
      recipients_filter = recipients_filter.with_state(recipient_state) unless recipient_state.nil?
      messages.includes(:recipients) & recipients_filter
    end
  end
end

require 'has_messages/models/message.rb'
require 'has_messages/models/message_recipient.rb'
