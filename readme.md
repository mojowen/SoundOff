# Sound Off

Sound Off is a civic engagment tool built for [Headcount](http://www.headcount.org/) that makes it super easy to tweet at your elected representatives.

It's built on some amazing open source technologies like:

 * Ruby on Rails
 * Angular JS
 * Event Machine

And uses some amazing API's like:

 * Sunlight's Open Congress
 * Twitter

Currently in development - check [the website](http://soundoffatcongress.org) for our current progress. [Issues / Features tracked in github](/issues)

## Standing It Up

You'll want to run `rake db:seed` after the usual (`bundle install; rake db:migrate`) to seed the database with representatives.

## Deploying

`rake deploy` is a useful tool to pre generate all of the SoundOff's assets, commit them to a throwaway branch, and deploy that branch to Heroku.
