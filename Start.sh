
cd ~/OSINT/Sketchy
virtualenv sketchenv
source sketchenv/bin/activate
python manage.py create_db
redis-server &
celery -A sketchy.celery worker &

python manage.py runserver --host 0.0.0.0 --port 8000 &

cd ~/OSINT/Scumblr

~/.rvm/gems/ruby-2.2.0/bin/sidekiq -l log/sidekiq.log & 
~/.rvm/gems/ruby-2.2.0/bin/rails s &

cd ~/OSINT/Osint

rails s -p 4567 &
