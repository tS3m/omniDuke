#!/usr/bin/env ruby
require 'net/imap'

source = Net::IMAP.new('imap.duke.edu')
p source
source.capability
source.authenticate('LOGIN','','')
