# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
> ruby installed using rvm
> ruby-2.3.3@crossover

* Ruby version
> Rails 5.0.2

* System dependencies

* Configuration
> Require to change confin/database.yml depending on your mysql user name & password
>> bundle install

* Database creation
> rake db:create

* Database initialization
> rake db:seed

* How to run the test suite
> For Rspec Test Cases
>> rspec spec  --format documentation

> For Jasmine Test Cases
>> rails s
>> in the browser open localhost:3000/specs

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

> For production environments we require following environment variables
>> 1) RAILS_SERVE_STATIC_FILES

>> 2) SECRET_KEY_BASE

> Then execute following command to execute all assets file like css, javascripts, images
>> rake assets:precompile RAILS_ENV=production

> To start the server in production environment
>> rails s -e production

* Documentation
> Navigate inside project folder & Type following command from terminal
>> yard server
>
> From Browser Navigate to following url to read documentation
>> http://localhost:8808
