sidekiq: bundle exec sidekiq
resque: env TERM_CHILD=1 bundle exec rake resque:work QUEUE='*' CONCURRENCY=11
web: bundle exec rails server thin -p $PORT -e $RACK_ENV  CONCURRENCY=2