require 'state_machines-activerecord'

# Adds a generic implementation for sending messages between users
module HasMessages
  MESSAGE_TOPIC_FIELD_DELIMITER = "-"

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
    def has_messages
      has_many  :messages, -> { where(:hidden_at => nil).order('messages.created_at DESC') },
                  :as => :sender,
                  :class_name => 'Message'
      has_many  :received_messages, -> { includes('message')
                    .where('message_recipients.hidden_at IS NULL AND messages.state = ?', 'sent')
                    .order('messages.created_at DESC') },
                  :as => :receiver,
                  :class_name => 'MessageRecipient'

      include HasMessages::HasMessagesInstanceMethods
    end

    def acts_as_message_topic
      has_many  :topical_messages, -> { order('messages.created_at DESC').where(:hidden_at => nil) },
                  :as => :topic,
                  :class_name => 'Message'

      include HasMessages::ActsAsMessageTopicInstanceMethods
    end
  end

  module HasMessagesInstanceMethods
    # Composed messages that have not yet been sent.  These consists of all
    # messages that are currently in the "unsent" state.
    def unsent_messages
      messages.with_state(:unsent)
    end

    def unread_messages
      received_messages.with_state(:unread)
    end

    # Composed messages that have already been sent.  These consists of all
    # messages that are currently in the "queued" or "sent" states.
    def sent_messages
      messages.with_states(:queued, :sent)
    end
  end

  module ActsAsMessageTopicInstanceMethods
    def topical_messages_for(receiver, recipient_state = nil)
      recipients_filter = MessageRecipient.with_receiver(receiver)
      recipients_filter = recipients_filter.with_state(recipient_state) unless recipient_state.nil?
      recipients_filter.with_topic(self)
    end

    def unread_topical_messages_for(receiver)
      topical_messages_for(receiver, :unread)
    end

    def mark_topical_messages_read_for(receiver)
      MessageRecipient.where(message_id: self.topical_messages).with_receiver(receiver).update_all(state: "read")
    end

    def message_topic_field
      "#{self.class.to_s}#{HasMessages::MESSAGE_TOPIC_FIELD_DELIMITER}#{self.id}"
    end
  end
end


ActiveRecord::Base.class_eval do
  extend HasMessages::MacroMethods
end

require 'has_messages/models/message.rb'
require 'has_messages/models/message_recipient.rb'
