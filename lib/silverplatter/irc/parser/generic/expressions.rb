#--
# Copyright 2007 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++

# This file is instance_eval'ed on a SilverPlatter::IRC::Parser, so see there for
# available methods

alter_expression :nick,       /[A-Za-z\[\]\\`_^{|}][A-Za-z\d\[\]\\`_^{|}-]{0,#{isupport.nicklen-1}}/
add_expression   :cloak,      /[^\x20]+/
alter_expression :host,       /#{new_expression.hostname}|#{new_expression.hostaddr}|#{new_expression.cloak}/
