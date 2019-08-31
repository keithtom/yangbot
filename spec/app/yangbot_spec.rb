require File.expand_path '../../spec_helper.rb', __FILE__
require_relative '../../app/yangbot'

describe Yangbot do
  context "when a new user joins" do
    # https://api.slack.com/events/team_join
    let(:event_data) { { "type" => "team_join", "user" => { "id" => "ABC123" } } }
    let(:client) { double('client') }

    it "should send the welcome message to the new user" do
      expect(Yangbot).to receive(:direct_message_blocks)
      Yangbot.process(event_data)
    end
  end
end
