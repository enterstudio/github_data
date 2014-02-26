# TTY
[![Gem Version](https://badge.fury.io/rb/tty.png)][gem]
[![Build Status](https://secure.travis-ci.org/peter-murach/tty.png?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/peter-murach/tty.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/peter-murach/tty/badge.png?branch=master)][coveralls]

[gem]: http://badge.fury.io/rb/tty
[travis]: http://travis-ci.org/peter-murach/tty
[codeclimate]: https://codeclimate.com/github/peter-murach/tty
[coveralls]: https://coveralls.io/r/peter-murach/tty

Toolbox for developing CLI clients in Ruby. This library provides a fluid interface for working with terminals.

## Features

Jump-start development of your command line app:

* Table rendering with an easy-to-use API. [status: In Progress]
* Terminal output colorization.            [status: ✔ ]
* Terminal output paging.                  [status: ✔ ]
* System & command detection utilities.    [status: In Progress]
* Text manipulation(wrapping/truncation)   [status: In Progress]
* Shell user interface.                    [status: In Progress]
* File diffs.                              [status: TODO]
* Progress bar.                            [status: TODO]
* Configuration file management.           [status: TODO]
* Logging                                  [status: In Progress]
* Plugin ecosystem                         [status: TODO]
* Fully tested with major ruby interpreters.
* No dependencies to allow for easy gem vendoring.

## Installation

Add this line to your application's Gemfile:

    gem 'tty'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tty

## Usage

### Table

To instantiate table pass 2-dimensional array:

```ruby
table = TTY::Table[['a1', 'a2'], ['b1', 'b2']]
table = TTY::Table.new [['a1', 'a2'], ['b1', 'b2']]
table = TTY::Table.new rows: [['a1', 'a2'], ['b1', 'b2']]
table = TTY::Table.new ['h1', 'h2'], [['a1', 'a2'], ['b1', 'b2']]
table = TTY::Table.new header: ['h1', 'h2'], rows: [['a1', 'a2'], ['b1', 'b2']]
```

or cross header with rows inside a hash like so

```ruby
table = TTY::Table.new [{'h1' => ['a1', 'a2'], 'h2' => ['b1', 'b2']}]
```

Table behaves like an Array so `<<`, `each` and familiar methods can be used

```ruby
table << ['a1', 'a2', 'a3']
table << ['b1', 'b2', 'b3']
table << ['a1', 'a2'] << ['b1', 'b2']  # chain rows assignment

table.each { |row| ... }  # iterate over rows
table.each_with_index     # iterate over each element with row and column index
table[i, j]               # return element at row(i) and column(j)
table.row(i) { ... }      # return array for row(i)
table.column(j) { ... }   # return array for column(j)
table.column(name)        # return array for column(name), name of header
table.row_size            # return row size
table.column_size         # return column size
table.size                # return an array of [row_size, column_size]
table.border              # specify border properties
```

or pass your rows in a block

```ruby
table = TTY::Table.new  do |t|
  t << ['a1', 'a2', 'a3']
  t << ['b1', 'b2', 'b3']
end
```

#### Rendering

Once you have an instance of `TTY::Table` you can print it out to the stdout by doing:

```ruby
table.to_s

a1  a2  a3
b1  b2  b3
```

This will use so called `basic` renderer with default options.

However, you can include other customization options such as

```ruby
border         # hash of border properties out of :characters, :style, :separator keys
border_class   # a type of border to use
column_widths  # array of maximum columns widths
column_aligns  # array of cell alignments out of :left, :center and :right, default :left
filter         # a proc object that is applied to every field in a row
indent         # indentation applied to rendered table
multiline      # if true will wrap text at new line or column width,
               # when false will escape special characters
orientation    # either :horizontal or :vertical
padding        # array of integers to set table fields padding
renderer       # enforce display type out of :basic, :color, :unicode, :ascii
resize         # if true will expand/shrink table column sizes to match the width,
               # otherwise if false rotate table vertically
width          # constrain the table total width, otherwise dynamically
               # calculated from content and terminal size
```

#### Multiline

Renderer options may include `multiline` parameter. The `true` value will cause the table fields wrap at their natural line breaks or in case when the column widths are set the content will wrap.

```ruby
table = TTY::Table.new [ ["First", '1'], ["Multi\nLine\nContent", '2'], ["Third", '3']]
table.render :ascii, multiline: true
# =>
  +-------+-+
  |First  |1|
  |Multi  |2|
  |Line   | |
  |Content| |
  |Third  |3|
  +-------+-+
```

When the `false` option is specified all the special characters will be escaped and if the column widths are set the content will be truncated like so

```ruby
table = TTY::Table.new [ ["First", '1'], ["Multiline\nContent", '2'], ["Third", '3']]
table.render :ascii, multiline: false
# =>
  +------------------+-+
  |First             |1|
  |Multiline\nContent|2|
  |Third             |3|
  +------------------+-+
```

#### Border

To print border around data table you need to specify `renderer` type out of `basic`, `ascii`, `unicode`. By default `basic` is used. For instance, to output unicode border:

```ruby
table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2']
table.render :unicode
# =>
  ┌───────┬───────┐
  │header1│header2│
  ├───────┼───────┤
  │a1     │a2     │
  │b1     │b2     │
  └───────┴───────┘
```

You can also create your own custom border by subclassing `TTY::Table::Border` and implementing the `def_border` method using internal DSL methods like so:

```ruby
class MyBorder < TTY::Table::Border
  def_border do
    left         '$'
    center       '$'
    right        '$'
    bottom       ' '
    bottom_mid   '*'
    bottom_left  '*'
    bottom_right '*'
  end
end
```

Next pass the border class to your table instance `render_with` method

```ruby
table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2']
table.render_with MyBorder
# =>
  $header1$header2$
  $a1     $a2     $
  *       *       *
```

Finally, if you want to introduce slight modifications to the predefined border types, you can use table `border` helper like so

```ruby
table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2']
table.render do |renderer|
  renderer.border do
    mid          '='
    mid_mid      ' '
  end
end
# =>
  header1 header2
  ======= =======
  a1      a2
  b1      b2
```

In addition to specifying border characters you can force table to render separator line on each row like:

```ruby
table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2']]
table.render do |renderer|
  renderer.border.separator = :each_row
end
# =>
  +-------+-------+
  |header1|header2|
  +-------+-------+
  |a1     |a2     |
  +-------+-------+
  |b1     |b2     |
  +-------+-------+
```

Also to change the display color of your border do:

```ruby
table.render do |renderer|
  renderer.border.style = :red
end
```

#### Alignment

All columns are left aligned by default. You can enforce per column alignment by passing `column_aligns` option like so

```ruby
rows = [['a1', 'a2'], ['b1', 'b2']
table = TTY::Table.new rows: rows
table.render column_aligns: [:center, :right]
```

To align a single column do

```ruby
table.align_column(1, :right)
```

If you require a more granular alignment you can align individual fields in a row by passing `align` option

```ruby
table = TTY::Table.new do |t|
  t << ['a1', 'a2', 'a3']
  t << ['b1', {:value => 'b2', :align => :right}, 'b3']
  t << ['c1', 'c2', {:value => 'c3', :align => :center}]
end
```

#### Padding

By default padding is not applied. You can add `padding` to table fields like so

```ruby
heaer = ['Field', 'Type', 'Null', 'Key', 'Default', 'Extra']
rows  = [['id', 'int(11)', 'YES', 'nil', 'NULL', '']]
table = TTY::Table.new(header, rows)
table.render { |renderer| renderer.padding= [0,1,0,1] }
# =>
  +-------+---------+------+-----+---------+-------+
  | Field | Type    | Null | Key | Default | Extra |
  +-------+---------+------+-----+---------+-------+
  | id    | int(11) | YES  | nil | NULL    |       |
  +-------+---------+------+-----+---------+-------+
```

or you can set specific padding using `right`, `left`, `top`, `bottom` helpers. However, when adding top or bottom padding a `multiline` option needs to be set to `true` to allow for rows to span multiple lines. For example

```ruby
table.render { |renderer|
  renderer.multiline = true
  renderer.padding.top = 1
}
# =>
  +-----+-------+----+---+-------+-----+
  |     |       |    |   |       |     |
  |Field|Type   |Null|Key|Default|Extra|
  +-----+-------+----+---+-------+-----+
  |     |       |    |   |       |     |
  |id   |int(11)|YES |nil|NULL   |     |
  +-----+-------+----+---+-------+-----+
```

#### Filter

You can define filters that will modify individual table fields value before they are rendered. A filter can be a callable such as proc. Here's an example that formats

```ruby
table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2']
table.render do |renderer|
  renderer.filter = Proc.new do |val, row_index, col_index|
    if col_index == 1 and !(row_index == 0)
      val.capitalize
    else
      val
    end
  end
end
# =>
  +-------+-------+
  |header1|header2|
  +-------+-------+
  |a1     |A2     |
  +-------+-------+
  |b1     |B2     |
  +-------+-------+
```

To color even fields red on green background add filter like so

```ruby
table.render do |renderer|
  renderer.filter = proc do |val, row_index, col_index|
    col_index % 2 == 1 ? TTY.color.set(val, :red, :on_green) : val
  end
end
```

#### Width

To control table's column sizes pass `width`, `resize` options. By default table's natural column widths are calculated from the content. If the total table width does not fit in terminal window then the table is rotated vertically to preserve content.

The `resize` property will force the table to expand/shrink to match the terminal width or custom `width`. On its own the `width` property will not resize table but only enforce table vertical rotation if content overspills.

```ruby
header = ['h1', 'h2', 'h3']
rows   = [['aaa1', 'aa2', 'aaaaaaa3'], ['b1', 'b2', 'b3']]
table = TTY::Table.new header, rows
table.render width: 80, resize: true
# =>
  +---------+-------+------------+
  |h1       |h2     |h3          |
  +---------+-------+------------+
  |aaa1     |aa2    |aaaaaaa3    |
  |b1       |b2     |b3          |
  +---------+-------+------------+
```

### Terminal

To read general terminal properties you can use on of the helpers

```ruby
term = TTY::Terminal.new
term.width              # => 140
term.height             # =>  60
term.color?             # => true or false
term.echo(false) { }    # switch off echo for the block
term.page               # page terminal output, on non unix systems falls back to ruby implementation
```

To colorize your output do

```ruby
term.color.set 'text...', :bold, :red, :on_green    # => red bold text on green background
term.color.remove 'text...'       # strips off ansi escape sequences
term.color.code :red              # ansi escape code for the supplied color
```

Available colors are:

```ruby
black
red
green
yellow
blue
magenta
cyan
white
```

To supply background color simply prefix it with `on_`. For example a green background would be `on_green`.

To page your output do

```ruby
term.page 'long text...'
```

### Shell

Main responsibility is to interact with the prompt and provide convenience methods.

Available methods are

```ruby
shell = TTY::Shell.new
shell.ask          # print question
shell.read         # read from stdin
shell.say          # print message to stdout
shell.confirm      # print message(s) in green
shell.warn         # print message(s) in yellow
shell.error        # print message(s) in red
shell.suggest      # print suggestion message based on possible matches
shell.print_table  # print table to stdout
```

In order to ask question and parse answers:

```ruby
shell  = TTY::Shell.new
answer = shell.ask("What is your name?").read_string
```

The library provides small DSL to help with parsing and asking precise questions

```ruby
argument    # :required or :optional
character   # turn character based input, otherwise line (default: false)
clean       # reset question
default     # default value used if none is provided
echo        # turn echo on and off (default: true)
mask        # mask characters i.e '****' (default: false)
modify      # apply answer modification :upcase, :downcase, :trim, :chomp etc..
range       # specify range '0-9', '0..9', '0...9' or negative '-1..-9'
validate    # regex against which stdin input is checked
valid       # a list of expected valid options
```

You can chain question methods or configure them inside a block

```ruby
shell.ask("What is your name?").argument(:required).default('Piotr').validate(/\w+\s\w+/).read_string

shell.ask "What is your name?" do
  argument :required
  default  'Piotr'
  validate /\w+\s\w+/
  valid    ['Piotr', 'Piotrek']
  modify   :capitalize
end.read_string
```

Reading answers and converting them into required types can be done with custom readers

```ruby
read_bool       # return true or false for strings such as "Yes", "No"
read_char       # return first character
read_date       # return date type
read_datetime   # return datetime type
read_email      # validate answer against email regex
read_file       # return a File object
read_float      # return decimal or error if cannot convert
read_int        # return integer or error if cannot convert
read_multiple   # return multiple line string
read_password   # return string with echo turned off
read_range      # return range type
read_regex      # return regex expression
read_string     # return string
read_symbol     # return symbol
read_text       # return multiline string
```

For example, if we wanted to ask a user for a single digit in given range

```ruby
ask("Provide number in range: 0-9") do
  range '0-9'
  on_error :retry
end.read_int
```

on the other hand, if we are interested in range answer then

```ruby
ask("Provide range of numbers?").read_range
```

To suggest possible matches for the user input use `suggest` method like so

```ruby
shell.suggest('sta', ['stage', 'stash', 'commit', 'branch'])
# =>
  Did you mean one of these?
          stage
          stash
```

### System

```ruby
TTY::System.unix?        # check if unix platform
TTY::System.windows?     # check if windows platform
TTY::System.which(cmd)   # full path to executable if found, nil otherwise
TTY::System.exists?(cmd) # check if command is available
TTY::System.editor       # provides access to system editor
```

To set preferred editor you can either use shell environment variables such as `EDITOR` and `VISUAL` or set the command(s) manually like so

```ruby
TTY::System.editor.command('vim')
```

To open a file in your editor of choice do

```ruby
TTY::System.editor.open('file path...')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012-2013 Piotr Murach. See LICENSE for further details.
