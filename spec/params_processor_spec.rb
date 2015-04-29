require_relative 'spec_helper'

describe ParamsProcessor do
  let(:data) do
    {
      token:        'KjRUKVRBoQVerm6bJTymvOe0',
      team_id:      'T0001',
      team_domain:  'example',
      channel_id:   'C2147483705',
      channel_name: 'other_channel',
      user_id:      'U2147483697',
      user_name:    'Steve',
      command:      '/late',
      text:         '10AM'
    }
  end

  let(:subject) { described_class.new(data) }

  it 'parses user name' do
    expect(subject.user_name).to eq('Steve')
  end

  it 'parses message text' do
    expect(subject.text).to eq('10AM')
  end

  it 'parses default channel' do
    expect(subject.channel).to eq('#announcements')
  end

  it 'parses custom channel' do
    channel_data = data
    channel_data[:text] = '10AM #other_channel'
    parser = described_class.new(channel_data)
    expect(parser.channel).to eq('#other_channel')
  end

  it 'parses no text' do
    channel_data = data
    channel_data[:text] = nil
    parser = described_class.new(channel_data)
    expect(parser.channel).to eq('#announcements')
    expect(parser.text).to eq('')
  end

  it 'parses timeoff text for one day' do
    timeoff_data = data
    timeoff_data[:text] = "Monday"
    parser = described_class.new(timeoff_data)
    expect(parser.timeoff_text).to eq('Monday')
  end

  it 'parses timeoff text for two days with a space' do
    timeoff_data = data
    timeoff_data[:text] = "Monday, Tuesday"
    parser = described_class.new(timeoff_data)
    expect(parser.timeoff_text).to eq('Monday through Tuesday')
  end

  it 'parses timeoff text for two days without a space' do
    timeoff_data = data
    timeoff_data[:text] = 'Monday,Wednesday'
    parser = described_class.new(timeoff_data)
    expect(parser.timeoff_text).to eq 'Monday through Wednesday'
  end

end