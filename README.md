# README

```
remote:        Have you run rails webpacker:install ?
remote:        Make sure the bin directory or binstubs are not included in .gitignore
remote:        Exiting!
remote: 
remote:  !
remote:  !     Precompiling assets failed.
remote:  !
remote:  !     Push rejected, failed to compile Ruby app.
remote: 
remote:  !     Push failed
remote: Verifying deploy...
remote: 
remote: ! Push rejected to flats-tracker.
```
To resolve it run `bundle exec rails webpacker:binstubs`
