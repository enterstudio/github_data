# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Validatable do
  let(:described_class) { Class.new { include TTY::Table::Validatable } }
  let(:rows) { [['a1', 'a2'], ['b1']] }
  subject { described_class.new }

  it 'raises no exception' do
    rows[1] << ['b2']
    expect { subject.assert_row_sizes(rows) }.not_to raise_error
  end

  it 'raises exception for mismatched rows' do
    expect { subject.assert_row_sizes(rows) }.
      to raise_error(TTY::Table::DimensionMismatchError)
  end
end
