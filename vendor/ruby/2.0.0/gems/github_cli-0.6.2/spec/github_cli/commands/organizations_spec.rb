# encoding: utf-8

require 'spec_helper'

describe GithubCLI::Commands::Organizations do
  let(:format) { {'format' => 'table'} }
  let(:user)   { 'peter-murach' }
  let(:org)    { 'github' }
  let(:api_class) { GithubCLI::Organization }

  it "invokes org:list" do
    api_class.should_receive(:list).with({}, format)
    subject.invoke "org:list", []
  end

  it "invokes org:list --user" do
    api_class.should_receive(:list).with({'user' => user}, format)
    subject.invoke "org:list", [], {:user => user}
  end

  it "invokes org:get" do
    api_class.should_receive(:get).with(org, {}, format)
    subject.invoke "org:get", [org]
  end

  it "invokes org:edit" do
    api_class.should_receive(:edit).with(org, {'name' => 'new'}, format)
    subject.invoke "org:edit", [org], {'name' => 'new'}
  end
end
