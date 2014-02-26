# encoding: utf-8

require 'spec_helper'

describe GithubCLI::Util, '#convert_values' do
  let(:values) { [true, {:a => false }, 'string']}

  it { expect(subject.convert_values(values)).to include(["false"]) }

  it { expect(subject.convert_values(values)).to include("true") }

  it { expect(subject.convert_values(values)).to include("string") }

end # convert_values
