# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Visits::Group do
  describe '#call' do
    let(:time_threshold_minutes) { 30 }
    let(:merge_threshold_minutes) { 15 }

    subject(:group) do
      described_class.new(time_threshold_minutes:, merge_threshold_minutes:)
    end

    context 'when points are too far apart' do
      it 'groups points into separate visits' do
        points = [
          build(:point, latitude: 0, longitude: 0, timestamp: 1.day.ago),
          build(:point, latitude: 0.00001, longitude: 0.00001, timestamp: 1.day.ago + 5.minutes),
          build(:point, latitude: 0.00002, longitude: 0.00002, timestamp: 1.day.ago + 10.minutes),
          build(:point, latitude: 0.00003, longitude: 0.00003, timestamp: 1.day.ago + 15.minutes),
          build(:point, latitude: 0.00004, longitude: 0.00004, timestamp: 1.day.ago + 20.minutes),
          build(:point, latitude: 0.00005, longitude: 0.00005, timestamp: 1.day.ago + 25.minutes),
          build(:point, latitude: 0.00006, longitude: 0.00006, timestamp: 1.day.ago + 30.minutes),
          build(:point, latitude: 0.00007, longitude: 0.00007, timestamp: 1.day.ago + 35.minutes),
          build(:point, latitude: 0.00008, longitude: 0.00008, timestamp: 1.day.ago + 40.minutes),
          build(:point, latitude: 0.00009, longitude: 0.00009, timestamp: 1.day.ago + 45.minutes),
          build(:point, latitude: 0.0001,  longitude: 0.0001,  timestamp: 1.day.ago + 50.minutes),
          build(:point, latitude: 0.00011, longitude: 0.00011, timestamp: 1.day.ago + 55.minutes),
          build(:point, latitude: 0.00011, longitude: 0.00011, timestamp: 1.day.ago + 95.minutes),
          build(:point, latitude: 0.00011, longitude: 0.00011, timestamp: 1.day.ago + 100.minutes),
          build(:point, latitude: 0.00011, longitude: 0.00011, timestamp: 1.day.ago + 105.minutes)
        ]
        expect(group.call(points)).to \
          eq({
               "#{time_formatter(1.day.ago)} - #{time_formatter(1.day.ago + 55.minutes)}" => points[0..11],
            "#{time_formatter(1.day.ago + 95.minutes)} - #{time_formatter(1.day.ago + 105.minutes)}" => points[12..-1]
             })
      end
    end
  end

  def time_formatter(time)
    Time.zone.at(time).strftime('%Y-%m-%d %H:%M')
  end
end
