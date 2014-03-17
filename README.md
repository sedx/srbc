# Srbc

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'srbc'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install srbc

## Usage

Usage:    You can run *.rb files, or
           other in ruby, just print "main"
           to execute "ruby main.rb".

           If in folder same files contains
           "main" (for example foo_main.rb,
           bar_main.rb and main.rb) SRBC ask
           you what file run.

           When SRBC run default MS symbol
           in console > replace with ~

           You can use other executor.
           Run "srbc -add:cucumber"
           to add new executor.
           Then run "srbc -cucumber" to start
           Smart Ruby Console with cucumber executor.


Arguments:
           -add:<exexutor>      add executor
           -<executor>          run with executor
           -help                for this help
           -list                list of executors
           no arguments         run ruby executor


 Comands:

          | @help        | this help        |
          | @list        | extension list   |
          | @exit        | exit from app    |
          | @add "*.rb"  | add extension    |

          You can shortcut commands.
          Example: @h for help

## Contributing

1. Fork it ( https://github.com/[my-github-username]/srbc/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
