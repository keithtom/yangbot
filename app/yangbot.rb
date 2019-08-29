class Yangbot
  def self.process(event_data)
    # just for debugging
    puts JSON.pretty_generate(event_data)

    case event_data['type']
    when 'team_join'
      # https://api.slack.com/events/team_join
      # team_join(event_data)
    when 'message'
      # https://api.slack.com/events/message.im
      return if bot_message?(event_data)

      # if it is a direct message to yangbot
      if event_data['channel_type'] == "im"
        im_bot(event_data)
        return
      end
    when 'app_mention'
      # someone mentioned yangbot
      # TODO: build out parsing logic to help with basic questions
      message = "Sorry, I'm just a simple bot for now."
      user_id = event_data['user']
      direct_message(user_id, message)
    when 'app_home_opened'
      # https://api.slack.com/events/app_home_opened
      # user clicked on our bot icon to DM
    else
      # message.app_home https://api.slack.com/events/message.app_home
      # https://api.slack.com/events/user_change

      # In the event we receive an event we didn't expect, we'll log it and move on.
      puts "Unexpected event:\n"
      puts JSON.pretty_generate(event_data)
    end
  end

  # Event handler for when a user joins a team
  def self.team_join(event_data)
    message = ":yangcheer: Welcome to the California Yang Gang Regional Slack Workspace! :yangcheer:
      \n
      Before you do anything, head on over to <#CLQKM7YRK|0-all-start-here> and read the workspace rules. Adhering to these rules is how we maintain order and organize effectively for Yang.
      \n
      What sets this workspace apart from others that you may be part of is that we hold ourselves to a higher standard and actively encourage participation from our fellow California volunteers. Andrew Yang isn’t going to win this election on his own. He needs our help, and we are going to deliver.
      \n
      As a member of this community, please commit a minimum of 30 minutes to phone banking this week. If you haven’t done any phone banking yet, it’s a lot easier than you think. We are trying to hit some aggressive phone banking goals that will be a LOT easier if more people are involved. Just visit <#CM233G27K|7-phone-banking> to get started.
      \n
      If you have any questions, please head over to <#CLSU38W3V|7-volunteer-support>."


      user_id = event_data["user"]["id"]
    direct_message(user_id, message)
  end

  def self.im_bot(event_data)
    blocks = [
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": ":yangcheer: Welcome to the California Yang Gang Regional Slack Workspace! :yangcheer:"
        }
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "Before you do anything, head on over to <#CLQKM7YRK|0-all-start-here> and read the workspace rules. Adhering to these rules is how we maintain order and organize effectively for Yang."
        }
      },
      {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "What sets this workspace apart from others that you may be part of is that we hold ourselves to a higher standard and actively encourage participation from our fellow California volunteers. Andrew Yang isn’t going to win this election on his own. He needs our help, and we are going to deliver."
      }
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "As a member of this community, please commit a minimum of 30 minutes to phone banking this week. If you haven’t done any phone banking yet, it’s a lot easier than you think. We are trying to hit some aggressive phone banking goals that will be a LOT easier if more people are involved. Just visit <#CM233G27K|7-phone-banking> to get started."
      }
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "If you have any questions, please head over to <#CLSU38W3V|7-volunteer-support>."
      }
    }
    ]
    user_id = event_data['user']
    direct_message_blocks(user_id, blocks)

  end


    # Send a response to an Event via the Web API.
  # You may notice that user and channel IDs may be found in
  # different places depending on the type of event we're receiving.
  def self.direct_message(user_id, message)
    client.chat_postMessage(
      as_user: 'true',
      channel: user_id,
      text: message
    )
  end

  def self.direct_message_blocks(user_id, blocks)
    client.chat_postMessage(
      as_user: 'true',
      channel: user_id,
      blocks: blocks
    )
  end

  def self.client
    $client
  end

  def self.bot_message?(event_data)
    event_data["bot_id"].present?
  end
end
