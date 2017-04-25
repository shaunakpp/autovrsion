# Autovrsion

A command line tool for simple auto versioning of files using Rugged and Listen.

## Installation

Add this line to your application's Gemfile:
~~~
gem 'autovrsion'
~~~
And then execute:
~~~
$ bundle
~~~
Or install it yourself as:

~~~
$ gem install autovrsion
~~~

## Pre-requisities
install Git:

https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

install Ruby:

https://www.ruby-lang.org/en/downloads/
https://www.ruby-lang.org/en/installation/

## Usage

~~~
$ autovrsion <command>
~~~
for working on current directory

~~~
$ autovrsion <command> </path/to/your/directory>
~~~
for working on a specific directory

Commands:
1. `create` - used to create a new git repository or re-initialize an existing one.
2. `start` - start listening to file system changes and auto commit any change.commits would be created after every file addition, modification and/or deletion.
3. `display` - display the versions in the repository.
4. `check` - access a particular version.
5. `reset` - used after the check command, it resets to the latest version in the repository.
6. `rewind` - permanently rewind to a previous version(WARNING! any changes after the rewound version are permanently lost)

## Command Usage

~~~
$ autovrsion create
$ autovrsion create </path/to/repository>
~~~
initialize your repository at current directory or specified directory

~~~
$ autovrsion start
$ autovrsion start </path/to/repository>
~~~
This will start the listener which will auto-commit after every change detected in the directory

~~~
$ autovrsion display
$ autovrsion display </path/to/repository>
~~~
Shows a list of all versions in the directory.

~~~
$ autovrsion check
$ autovrsion check </path/to/repository>
~~~
Enter the version number to access a particular version(always use `reset` after this command).

~~~
$ autovrsion reset
$ autovrsion reset </path/to/repository>
~~~
Reset to latest version.

~~~
$ autovrsion rewind
$ autovrsion rewind </path/to/repository>
~~~
Permanently rewind to a particular version. All versions above the specified versions are removed permanently !
