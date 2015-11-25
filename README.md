railsready
==========

[![RailsReady Build Status - Circle CI](https://circleci.com/gh/rfsfrn/railsready/tree/master.svg?style=shield&circle-token=16fa4a8e8208d4341ffbe39e84b32c55c7060190)](https://circleci.com/gh/rfsfrn/railsready/tree/master)

Script to set up a new Ruby on Rails development environment.


Requirements
------------

* Git, 2.5+.
* Ruby, preferably version 2.2.3.
* MySQL, 5.6+ or PostgreSQL, 9.4+.


Installation
------------

### Install railsready

1. Create bin directory to add to PATH:

        $ mkdir -p ~/.bin

2. Add railsready to it:

        $ curl -so ~/.bin/railsready https://raw.githubusercontent.com/rfsfrn/railsready/master/railsready

3. Make it executable:

        $ chmod +x ~/.bin/railsready

4. Add ~/.bin to your $PATH, e.g.:

        $ echo 'export PATH=$HOME/.bin:$PATH' >> ~/.bash_profile
        $ source ~/.bash_profile


Usage
-----

### Creating the Rails Application

Paste the following commands at a Terminal prompt.
```
cd
mkdir -p Workspace/railsapps && cd $_
railsready test_app
```


Author
------

#### [rfsfrn](https://github.com/rfsfrn)


License
-------

This software is released under the **[MIT License][MIT]**, see **[LICENSE](LICENSE)**.

[MIT]: http://www.opensource.org/licenses/mit-license.php
