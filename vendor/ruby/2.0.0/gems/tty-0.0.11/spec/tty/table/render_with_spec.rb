# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, '#render_with' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows)   { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }
  let(:table)  { described_class.new header, rows }

  context 'with invalid border class' do
    it "doesn't inherit from TTY::Table::Border" do
      expect { table.render_with String }.to raise_error(TTY::TypeError)
    end

    it "doesn't implement def_border" do
      klass = Class.new(TTY::Table::Border)
      expect { table.render_with klass }.to raise_error(TTY::NoImplementationError)
    end
  end

  context 'with complete border' do
    before {
      class MyBorder < TTY::Table::Border
        def_border do
          top          '='
          top_mid      '*'
          top_left     '*'
          top_right    '*'
          bottom       '='
          bottom_mid   '*'
          bottom_left  '*'
          bottom_right '*'
          mid          '='
          mid_mid      '*'
          mid_left     '*'
          mid_right    '*'
          left         '$'
          center       '$'
          right        '$'
        end
      end
    }

    it 'displays custom border' do
      table.render_with(MyBorder).should == <<-EOS.normalize
        *==*==*==*
        $h1$h2$h3$
        *==*==*==*
        $a1$a2$a3$
        $b1$b2$b3$
        *==*==*==*
      EOS
    end
  end

  context 'with incomplete border' do
    before {
      class MyBorder < TTY::Table::Border
        def_border do
          bottom       ' '
          bottom_mid   '*'
          bottom_left  '*'
          bottom_right '*'
          left         '$'
          center       '$'
          right        '$'
        end
      end
    }

    it 'displays border' do
      table.render_with(MyBorder).should == <<-EOS.normalize
        $h1$h2$h3$
        $a1$a2$a3$
        $b1$b2$b3$
        *  *  *  *
      EOS
    end
  end

  context 'with renderer' do
    before {
      class MyBorder < TTY::Table::Border
        def_border do
          left  '|'
          right '|'
        end
      end
    }

    it 'displays border' do
      result = table.render_with MyBorder do |renderer|
        renderer.border.style = :red
      end
      result.should == <<-EOS.normalize
        \e[31m|\e[0mh1\e[31m\e[0mh2\e[31m\e[0mh3\e[31m|\e[0m
        \e[31m|\e[0ma1\e[31m\e[0ma2\e[31m\e[0ma3\e[31m|\e[0m
        \e[31m|\e[0mb1\e[31m\e[0mb2\e[31m\e[0mb3\e[31m|\e[0m
      EOS
    end
  end
end # render_with
