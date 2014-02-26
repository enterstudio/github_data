# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer::Basic, 'with multiline content' do
  let(:header) { nil }
  let(:object) { described_class }
  let(:table) { TTY::Table.new header, rows }

  subject(:renderer) { object.new table }

  context 'with escaping' do
    let(:rows) { [ ["First", '1'], ["Multiline\nContent", '2'], ["Third", '3']] }

    context 'without border' do
      it "renders single line" do
        table.render(multiline: false).should == <<-EOS.normalize
          First              1
          Multiline\\nContent 2
          Third              3
        EOS
      end
    end

    context 'with column widths' do
      it "renders single line" do
        table.render(multiline: false, column_widths: [8,1]).should == <<-EOS.normalize
          First    1
          Multili… 2
          Third    3
        EOS
      end
    end

    context 'with border' do
      it "renders single line" do
        table.render(:ascii, multiline: false).should == <<-EOS.normalize
         +------------------+-+
         |First             |1|
         |Multiline\\nContent|2|
         |Third             |3|
         +------------------+-+
        EOS
      end
    end

    context 'with header' do
      let(:header) { ["Multi\nHeader", "header2"] }

      it "renders header" do
        table.render(:ascii, multiline: false).should == <<-EOS.normalize
         +------------------+-------+
         |Multi\\nHeader     |header2|
         +------------------+-------+
         |First             |1      |
         |Multiline\\nContent|2      |
         |Third             |3      |
         +------------------+-------+
        EOS
      end
    end
  end

  context 'without escaping' do
    let(:rows) { [ ["First", '1'], ["Multi\nLine\nContent", '2'], ["Third", '3']] }

    context 'without border' do
      it "renders every line" do
        table.render(multiline: true).should == <<-EOS.normalize
          First   1
          Multi   2
          Line     
          Content  
          Third   3
        EOS
      end
    end

    context 'with column widths' do
      it "renders multiline" do
        table.render(multiline: true, column_widths: [8,1]).should == <<-EOS.normalize
          First    1
          Multi    2
          Line      
          Content   
          Third    3
        EOS
      end

      it 'wraps multi line' do
        table.render(multiline: true, column_widths: [5,1]).should == <<-EOS.normalize
          First 1
          Multi 2
          Line   
          Conte  
          nt     
          Third 3
        EOS
      end
    end

    context 'with border' do
      it "renders every line" do
        table.render(:ascii, multiline: true).should == <<-EOS.normalize
         +-------+-+
         |First  |1|
         |Multi  |2|
         |Line   | |
         |Content| |
         |Third  |3|
         +-------+-+
        EOS
      end
    end

    context 'with header' do
      let(:header) { ["Multi\nHeader", "header2"] }

      it "renders header" do
        table.render(:ascii, multiline: true).should == <<-EOS.normalize
         +-------+-------+
         |Multi  |header2|
         |Header |       |
         +-------+-------+
         |First  |1      |
         |Multi  |2      |
         |Line   |       |
         |Content|       |
         |Third  |3      |
         +-------+-------+
        EOS
      end
    end
  end
end
