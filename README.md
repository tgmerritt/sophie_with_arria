# README

This is a sample implementation of UneeQ's digital human inside a Rails 6 setup.

### The app requires the following versions:

- Ruby 2.6.3p62 (if using rbenv, install with `rbenv install 2.6.3`)
- Rails 6.0.0 (`gem install rails -v 6.0.0`)

### Database

The app uses postgresql in order to store a token used for authentication with the UneeQ platform. You will need to be sure Postgres is installed and running - I use Homebrew `brew install psql` At the end of the postgres installation, you'll be asked to start psql now or every time at login. For instructions, check out this [blog post](https://chartio.com/resources/tutorials/how-to-start-postgresql-server-on-mac-os-x/)

### Setup

- `git clone` this project
- `cd sophie_with_arria`
- Good idea to make sure homebrew is up-to-date -- `brew update`
- Create and migrate the database -- `rails db:create db:migrate`
- Delete the credentials.yml.enc file in config/ - the master.key it was encrypted with is NOT checked into this project's source control, so you will not be able to see it's contents (by design). Once you have deleted the file...
- MODIFY your config/credentials.yml.enc file `EDITOR=vim rails credentials:edit` This command will create master.key and config/credentials.yml.enc so that you can add environment variables. See [this gist for a longer explanation](https://gist.github.com/db0sch/19c321cbc727917bc0e12849a7565af9)
- You will need to add the following values into the file:

```
customer_jwt_secret
fm_workspace
workspace_id
fm_api_key
```

You will need to contact UneeQ for API and Secret token if you do not have them already.

### Ready to go

You should be ready to fire up the rails server ( `rails s`) and access the app at http://localhost:3000

You should see a welcome page and a spinner at the bottom - the page will ask if it's ok to use your browser's location - you should say yes, but if you feel uncomfortable with geolocation, you can bypass this page manually by navigating to http://localhost:3000/conversations
