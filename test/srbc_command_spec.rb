require 'rspec'
require_relative '../lib/srbc/srbc_command'

describe SrbcCommand do
  include SrbcCommand

  it 'srbc should exit when command e or exit' do
    command ="e"
    srbc_command(command)
    $x.should eq false
    $x = true
    command = 'exit'
    srbc_command command
    $x.should eq false
  end





end