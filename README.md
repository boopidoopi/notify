# Notify

Simple mechanism of publishing/subscribing for activerecord models

## Installation

Add this line to your application's Gemfile:

    gem 'notify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install notify


## Basic Usage
Using the notify:

    class Model < ActiveRecord::Base
      include Notify
      tracked :on => {
        :create => :create_channel,
        :update => {[
          :update_channel => proc { |m| some_condition }
        ]},
        :destroy => [:destroy_channel, :some_other_channel]
      }
    end

    Model.subscribe(:create_channel) do |model|
      # some actions
    end

    Model.subscribe(:update_channel) do |model|
      # some actions
    end

    Model.subscribe(:destroy_channel) do |model|
      # some actions
    end


## Contributing

1. Fork it ( https://github.com/[my-github-username]/notify/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

