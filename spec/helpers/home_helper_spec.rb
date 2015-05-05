require 'rails_helper'
require 'pry'

describe HomeHelper do
  describe '#tabs_for_talk_groups' do
    context 'there are two talk groups' do
      let(:talk_group_one) { double(id: 1, date: Date.parse("2014-03-04")) }
      let(:talk_group_two) { double(id: 2, date: Date.parse("2014-03-05")) }
      let(:talk_groups) { [talk_group_one, talk_group_two] }

      context 'when today is not one of conference days' do
        before do
          allow(Date).to receive(:today).and_return(Date.new(2014, 3, 27))
        end

        it 'should set active on first days schedule' do
          expect { |b| helper.tabs_for_talk_groups(talk_groups, &b) }.to yield_successive_args([talk_group_one, true],
                                                                                               [talk_group_two, false])
        end
      end

      context 'today is first day of conference' do
        before do
          allow(Date).to receive(:today).and_return(Date.new(2014, 3, 4))
        end

        it 'should set active on first days schedule' do
          expect { |b| helper.tabs_for_talk_groups(talk_groups, &b) }.to yield_successive_args([talk_group_one, true],
                                                                                               [talk_group_two, false])
        end
      end

      context 'when today is second day of conference' do
        before do
          allow(Date).to receive(:today).and_return(Date.new(2014, 3, 5))
        end

        it 'should set active on second days schedule' do
          expect { |b| helper.tabs_for_talk_groups(talk_groups, &b) }.to yield_successive_args([talk_group_one, false],
                                                                                               [talk_group_two, true])
        end
      end
    end
  end
end
