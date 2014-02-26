# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer::Basic, 'truncation' do
  let(:header) { ['header1', 'head2', 'h3'] }
  let(:rows) { [['a1111111', 'a222', 'a3333333'], ['b111', 'b2222222', 'b333333']]}
  let(:table) { TTY::Table.new header, rows }

  subject { described_class.new(table, options) }

  context 'without column widths' do
    let(:options) { {} }

    it "doesn't shorten the fields" do
      subject.render.should == <<-EOS.normalize
        header1  head2    h3      
        a1111111 a222     a3333333
        b111     b2222222 b333333 
      EOS
    end
  end

  context 'with column widths' do
    let(:options) { { column_widths: [3, 5, 7] } }

    it 'shortens the fields' do
      subject.render.should == <<-EOS.normalize
        he… head2 h3     
        a1… a222  a33333…
        b1… b222… b333333
      EOS
    end
  end
end
