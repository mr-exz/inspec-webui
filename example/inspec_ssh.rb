# encoding: utf-8

title 'sshd checks'

control "sshd installed" do
  describe service('sshd') do
    it { should be_installed }
  end
end

control "sshd enabled" do
  describe service('sshd') do
    it { should be_enabled }
  end
end

control "sshd running" do
  describe service('sshd') do
    it { should be_running }
  end
end

control "sshd listen 22 port" do
  describe port(22) do
    it { should be_listening }
  end
end

