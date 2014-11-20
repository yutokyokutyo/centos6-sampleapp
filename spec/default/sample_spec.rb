require 'spec_helper'

## パッケージ集
describe package('git') do
  it { should be_installed }
end
describe package('nodejs') do
  it { should be_installed }
end
describe package('gcc') do
  it { should be_installed }
end
describe package('gcc-c++') do
  it { should be_installed }
end
describe package('openssl') do
  it { should be_installed }
end
describe package('openssl-devel') do
  it { should be_installed }
end
describe package('readline') do
  it { should be_installed }
end
describe package('readline-devel') do
  it { should be_installed }
end
describe package('libxml2.x86_64') do
  it { should be_installed }
end
describe package('libxml2-devel') do
  it { should be_installed }
end
describe package('libxslt') do
  it { should be_installed }
end
describe package('libxslt-devel') do
  it { should be_installed }
end
describe package('sqlite.x86_64') do
  it { should be_installed }
end
describe package('sqlite-devel.x86_64') do
  it { should be_installed }
end

# rbenvがあることを確かめる
describe command('/home/vagrant/.rbenv/bin/rbenv -v') do
  its(:stdout) { should match /rbenv 0.4.0/}
end

# rbenvの環境設定
describe file('/home/vagrant/.bash_profile') do
  it { should contain('export PATH="$HOME/.rbenv/bin:$PATH"')}
  it { should contain('eval "$(rbenv init -)"')}
end

# rubybuildがあることを確かめる
describe file('/home/vagrant/.rbenv/plugins/ruby-build') do
  it { should be_directory }
end

# Rubyがあることを確かめる
describe command('/home/vagrant/.rbenv/shims/ruby -v') do
  its(:stdout) { should match /ruby 2.1.4/ }
end
# Rubyがsampleappでどのバージョンで動いているのか(補足)
# describe command('rbenv version /home/vagrant/sample_app') do
#   its(:stdout) { should match /2.1.4/ }
# end

# rubygemsがあることを確かめる
describe file('/home/vagrant/.rbenv/versions/2.1.4/lib/ruby/gems') do
  it { should be_directory }
end

# bundlerがあることを確かめる
describe command('/home/vagrant/.rbenv/shims/bundle -v') do
  its(:stdout) { should match /Bundler version 1.7.4/ }
end

# ポートは3000番で動く！
describe port(3000) do
  it { should be_listening.with('tcp') }
end

# iptablesファイルで3000番ポートの解放をしていることを確かめる
describe service('iptables') do
  it { should be_running }
  # it { should be_enebled }
end
describe iptables do
  it { should have_rule('-A INPUT -p tcp -m tcp --dport 3000 -j ACCEPT') }
end

# 自分のMyappのディレクトリがあることを確かめる(sample_appどうしよう)
describe file('/home/vagrant/sample_app') do
  it { should be_directory }
end

# Gemファイルを確認することでgemがインストールされていることを確認する
describe file('/home/vagrant/sample_app/Gemfile') do
  it { should contain('sqlite3').from(/^group :development, :test do/).to(/^end/) }
  it { should contain('rails') }
  it { should contain('libv8') }
  it { should contain('therubyracer', :platforms => :ruby ) }
  it { should contain('execjs') }
  it { should contain('nokogiri') }
end

# DB上でテーブルが作成されていることを確かめる(sample_appって名前は冪等性ではないかも)
describe file('/home/vagrant/sample_app/db/migrate') do
  it { should be_directory }
end

# Railsサーバーが起動していることを確かめる(後々nohupで実装をする)
describe service('rails') do
  it { should be_running }
end
