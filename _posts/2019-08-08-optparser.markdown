---
layout: post
title:  "Optparse - CLI done properly"
date:   2019-08-18 9:33:52 +0100
categories: ruby programming optparse
---

The purpose of programming anything is to make tasks easier to the user. With the capabilities that modern hardware and vast body of
programming knowledge offers us majority of concievable can be solved swiftly with the few line of code.

However solving the problem programatically is only the initial step
to success. We need to take into consideration how our user will interact with provided software to get the work done. Even the best solution will be rejected by the end user when he does not feel that the system he uses is sufficiently interactive and intuitive.

A program or a part of the software responsible for interacting with the user is commonly called an interface. There are many types of interfaces but for us IT professionals the most vital one is the textual command line interface.

There is a particular module in the Ruby standard library (with its equivalent also present in Python) which rarely receives the attention it deserves. Which is a pity since it makes standardisation of your CLI programs a fairly easy task.

https://ruby-doc.org/stdlib-2.6.1/libdoc/optparse/rdoc/OptionParser.html

This article presents some of the cooler features of the module which you can implement in your own CLI based programs:

The full example containing all the features described in the article can be found at:

https://rubygems.org/gems/dummy_parser

### Basics

One of the basic features of a CLI program is a command to print its version it can be used for CI tools or simply to determine more easily whether some features (or bugs) are in this version of your program. It is customary to create a `version.rb` file containing the constant designing the current version of software.

dummy_parser/version.rb
```ruby
module DummyParser
  VERSION = '1.0.1'
end
```

This version has to be provided to the user - usual CLI params to display version of the software are `-v`* and `--version`.

This feature can be enabled in just a few lines with use of 'optparse' module:

```ruby
#! /usr/bin/env ruby
# frozen_sting_literal: true

require 'dummy_parser'
require 'optparse'

OptionParser.new do |opts|
  opts.on('-v', '--version', 'Prints the current version of dummy parser') do
    puts(DummyParser::VERSION)
  end
end.parse!
```

To briefly comment on what each line of the code does:

In lines:

```ruby
require 'dummy_parser'
require 'optparse'
```

we require dummy_parser module which is the module containing the current version of our program and optparse module with OptionParser class which is the main engine handling our CLI params.

```ruby
OptionParser.new do |opts|
```

Then we create a new instance of OptionParses and pass a block to it in which we will define bindings to particular params.

```ruby
 opts.on('-v', '--version', 'Prints the current version of dummy parser') do
    puts(DummyParser::VERSION)
  end
```

Binding is done with `on` method. If you are drawing parallels to JS onEvent methods that is correct - they basically implement the same Listener / Observer pattern.

In the params we provide the shorthand CLI param, its extended version, and description of the option. We also provide the block to determine what action should be taken should the parameter be provided to the script.

On the last line we close the block and run `parse!` method to trigger the param parsing.

```ruby
end.parse!
```

Let's give it a go:
```
dummy_parser --version
```

And viola we have our version:

```
1.0.1
```

Another extermely common parameter for CLI programs is `-h` or `--help` param. It usually prints to the console a message containing the correct parameter syntax for the program and list of options one can provide to the program.

Implementing such feature with optparse is also a trivial task.

```ruby
OptionParser.new do |opts|
opts.banner = 'Dummy program showcasing optparse module'
  opts.on('-v', '--version', 'Prints the current version of dummy parser') do
    puts(DummyParser::VERSION)
  end
  opts.on('-h', '--help', 'Prints this help message') do
    puts(opts)
  end
end.parse!
```

As you see we added two things to our OptionParser instance:

```ruby
opts.banner = 'Dummy program showcasing optparse module'
```

We defined banner attribute which will be printed as the first line of the help message.

```ruby
opts.on('-h', '--help', 'Prints this help message') do
    puts(opts)
end
```

We also addded another listener that will accept `-h` and `--help` methods and print the help message. We get the help message by printing the OptParser itself.

The resultant help message can be seen below:

```
dummy_parser -h
```

```
Dummy program showcasing optparse module
    -v, --version                    Prints the current version of dummy parser
    -h, --help                       Prints this help message
```

Sometimes aside from changing the way the program operates the attributes allow us to pass data to parameterise the execution of the program. Optparse allows for few kinds of such parameters.

```ruby
OptionParser.new do |opts|

...

  opts.on('-g [USER]', '--greet [USER]', 'Greets the user before exiting') do |user|
    puts("Hello #{user || 'User'}!")
  end

...

end.parse!
```

The example above shows an option with non-mandatory parameter (which is signigied by square brackets). This method will simply greet the person with the name provided, or in case the option was not parametrised it will just greet the user:
]```
dummy_parser --greet Greg
```

```
Hello Greg!
```

Optparser supports also other ways of passing params - with = and [-no] syntax:


```ruby
OptionParser.new do |opts|

...

  # Numeric input with = sign
  opts.on('-n=[NUM]', '--number=[NUM]', Integer, 'Prints the happy number') do |happy|
    puts("The happy number is #{happy}")
  end
  # Boolean input
  opts.on('-s', '--[no-]smile', 'Determines the mood of the printed face') do |smile|
    puts(": - #{ smile ? ')' : '(' }")

...

end.parse!
```

In `--number` option the third parameter comes before the description - this is the type to which the input is supposed to be cast - if the casting is unsuccessful the OptParser will raise and error.

Some examples of running the above:

```
dummy_parser --no-smile
```

```
: - (
```

```
dummy_parser --number=99
```

```
The happy number is 99
```

And in the last set of examples I would like to showcase three other OptParser features which you may find useful in your program:

```ruby


...
# Mandatory Args:
OptionParser.new do |opts|
  opts.on('-l LIKE', '--like LIKE', TrueClass, 'Tell me if you enjoyed this article') do |like|
    puts("#{like ? 'Thanks' : 'Apologies' }")
  end

  # Aborting :
  opts.on('--abort', 'Stops the program') do
    opts.abort('Aborting...')
  end

  # Empty param
  opts.on('-b')
...

end.parse!(into: params)
```

First is mandatory options - mandatory options cannot be run without the param. If such a scenario occurs the OptionParser will raise an error.

```
dummy_parser --like +
```

```
Thanks
```

Error:

```
dummy_parser --like
```

```
Traceback (most recent call last):
        4: from /home/jan/.rvm/gems/ruby-2.6.3/bin/ruby_executable_hooks:24:in `<main>'
        3: from /home/jan/.rvm/gems/ruby-2.6.3/bin/ruby_executable_hooks:24:in `eval'
        2: from /home/jan/.rvm/gems/ruby-2.6.3/bin/dummy_parser:23:in `<main>'
        1: from /home/jan/.rvm/gems/ruby-2.6.3/bin/dummy_parser:23:in `load'
/home/jan/.rvm/gems/ruby-2.6.3/gems/dummy_parser-1.0.1/bin/dummy_parser:44:in `<top (required)>': missing argument: --like (OptionParser::MissingArgument)
```

Second is the abort method - it allows you to exit parsing if certain param is provided ignoring all the program that happens after it (params passed before it will have their working).

```
 dummy_parser  --abort -v
```

```
Dummy Parser: Aborting...
```

```
 dummy_parser -v --abort
```

```
1.0.1
Dummy Parser: Aborting...
```

Third and to me the most interesting one is the listeners without the block. It has no block so its execution will have no effect. However it can be captured for further processing into a Hash using the :into option of `parse!` method. Those params can be later passed to the deeper logic of your program to affect its execution. (The params are put into the predefined Hash - which I have wiped out from the article so far for all the curious souls running the tutorial along the gem to discover ;) )

```
dummy_parser -g Ann -b
```

```
Hello Ann!
{:greet=>nil, :b=>true}
```

Note that params that have a block are already handled and they are wiped from the output. This is one of the advantages the blockless options have.

This is as far as this article goes. Feel free to play around with dummy_parser, and check out the documentation for optparser for more of its cool features and options:

https://ruby-doc.org/stdlib-2.6.1/libdoc/optparse/rdoc/OptionParser.html

Cheers,


* `-v` can also sometimes signify `verbose` execution mode




