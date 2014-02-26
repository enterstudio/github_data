# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Row, '#==' do
  let(:attributes) { [:id] }
  let(:data) { ['1'] }
  let(:object) { described_class.new(data, attributes) }

  subject { object == other }

  context 'with the same object' do
    let(:other) { object }

    it { should be_true }

    it 'is symmetric' do
      should eql(other == object)
    end
  end

  context 'with an equivalent object' do
    let(:other) { object.dup }

    it { should be_true }

    it 'is symmetric' do
      should eql(other == object)
    end
  end

  context 'with an equivalent object of subclass' do
    let(:other) { Class.new(described_class).new(data, :attributes => attributes) }

    it { should be_true }

    it 'is symmetric' do
      should eql(other == object)
    end
  end

  context 'with an object having a different attributes' do
    let(:other_attributes) { [:text] }
    let(:other) { described_class.new(data, :attributes => other_attributes) }

    it { should be_true }

    it 'is symmetric' do
      should eql(other == object)
    end
  end

  context 'with an object having a different attributes' do
    let(:other_data) { [2] }
    let(:other) { described_class.new(other_data, :attributes => attributes) }

    it { should be_false }

    it 'is symmetric' do
      should eql(other == object)
    end
  end

  context 'with an equivalent object responding to_ary' do
    let(:other) { data }

    it { should be_true }

    it 'is symmetric' do
      should eql(other == object)
    end
  end
end
