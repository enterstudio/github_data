# encoding: utf-8

require 'spec_helper'

describe GithubCLI::Commands::Blobs do
  let(:format) { {'format' => 'table'} }
  let(:user)   { 'peter-murach' }
  let(:repo)   { 'github_cli' }
  let(:sha)    { '3a0f86fb8db8eea7ccbb9a95f325ddbedfb25e15' }
  let(:api_class) { GithubCLI::Blob }

  it "invokes blob:get" do
    api_class.should_receive(:get).with(user, repo, sha, {}, format)
    subject.invoke "blob:get", [user, repo, sha]
  end

  it "invokes blob:create" do
    api_class.should_receive(:create).with(user, repo, {}, format)
    subject.invoke "blob:create", [user, repo]
  end

  it "invokes blob:create --encoding" do
    api_class.should_receive(:create).with(user, repo, {'encoding'=>'utf-8'}, format)
    subject.invoke "blob:create", [user, repo], :encoding => 'utf-8'
  end
end
