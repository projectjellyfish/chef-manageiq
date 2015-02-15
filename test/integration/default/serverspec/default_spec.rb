#
# Cookbook Name:: manageiq
# Recipe:: default
#
# Copyright (C) 2015 Booz Allen Hamilton
#

require "spec_helper"

describe port(3000) do
  it "ManageIQ is listening" do
    expect(subject).to be_listening
  end
end
