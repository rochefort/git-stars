# git-stars

git-stars is a command line utility to show [Your stars](https://github.com/stars).  

## Installation

    $ gem install git-stars

## Usage

git-stars use [octokit/octokit.rb](https://github.com/octokit/octokit.rb). So you can chose 3 ways to authenticate Github API.  

1. OAuth access token  
You can create access tokens through your GitHub Account Settings.  
[Creating an access token for command-line use - User Documentation](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)
And then you can use this with `-t(--token)` option.

    git stars -t your_access_token

2. basic authentication  
The second is using `-u(--user)` and `-p(--password)`.

    git stars -u user -p password

3. .netrc  
The third is using .netrc.
You can create ~/.netrc like below:
```
machine api.github.com
login your_login
password your_password
```
You can use this without option to authenticate when using .netrc.

    git stars

### list using tabular format
Default format is a tabular.

    git stars

e.g.:
![tabluar format](https://raw.githubusercontent.com/rochefort/git-stars/master/img/git-stars_no_options.png)

### list using simple format

    git stars -f simple

e.g.:
![simple format](https://raw.githubusercontent.com/rochefort/git-stars/master/img/git-stars_tabular.png)

### specify colors

Save a `some.yml` file to specify the color of columns or languages, like below:
```
columns:
  name: yellow
  stars: blue
  language:
    ruby: red
    javascript: light_white
    php: magenta
    go: green
    swift: light_blue
    objective-c: light_blue
  last_updated: white

# you can specify the following colors:
#
# black
# light_black
# red
# light_red
# green
# light_green
# yellow
# light_yellow
# blue
# light_blue
# magenta
# light_magenta
# cyan
# light_cyan
# white
# light_white
```

    git stars -y some.yml


### list all stars

    git stars -a

## Tips

### peco and hub
I like [peco/peco](https://github.com/peco/peco) and [github/hub](https://github.com/github/hub).  
You can filter git-stars results and open with browser.  
```sh
git stars -f simple --no-color | peco | awk '{print $1}' | xargs hub browse
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rochefort/git-stars.
