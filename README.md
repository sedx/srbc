# Srbc
SmartRuByConsole its executable gem for simple runing gem scripts.

You can run *.rb files, or other in ruby, just type "main" to execute "ruby main.rb".

If in folder same files contains "main" (for example main_foo.rb, main_bar.rb and main.rb) SRBC ask you what file run.

When SRBC run, default MS symbol in console > replace with~. Every line will start with R :  R - is first letter of current executor.

You can use other executor. Run "srbc -add:cucumber" to add new executor. Then run "srbc -cucumber" to start Smart Ruby Console with cucumber executor.

## Installation

Add this line to your application's Gemfile:

    gem 'srbc'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install srbc

## Usage

Arguments:
           -add:<exexutor>      add executor
           -<executor>          run with executor
           -help                for this help
           -list                list of executors
           no arguments         run ruby executor


 Comands:

      shortcut     command           description
      _________________________________________________
     |   @h   | @help        | this help               |
     |   @l   | @list        | extension list          |
     |   @e   | @exit        | exit from app           |
     |   --   | @add "*.rb"  | add extension           |
     |   @c   | @current     | current executor        |
     |   --   | @#<executor> | hot change executor     |
     |        |              | if executor not exits   |
     |        |              | will created new        |
     |   --   | @delete <exc>| delete executor         |
     |   --   | !<command>   | run program. use when   |
     |        |              | have same name programm |
     |        |              | and file, like pnig.rb  |
     __________________________________________________


## Contributing

1. Fork it ( https://github.com/[my-github-username]/srbc/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
