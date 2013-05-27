#!/bin/sh

set +e

solr_responding() {
  port=$1
  curl -o /dev/null "http://localhost:$port/solr/admin/ping" > /dev/null 2>&1
}

wait_until_solr_responds() {
  port=$1
  i=0
  while ! solr_responding $1 ; do
    /bin/echo -n "$i."
    sleep 1
    i=$((i+1))
    if [ $i -eq 15 ]
    then
      /bin/echo -n "Solr didn't start before 15 seconds"
      break
    fi
  done
}


bundle install --quiet --path vendor/bundle
/bin/echo -n "Starting Solr on port 8983 for specs..."
if [ -f sunspot-solr.pid ]; then bundle exec sunspot-solr stop || true; fi

git clone https://github.com/sunspot/sunspot.git
sunspot/sunspot-solr start -p 8983 -d /tmp/solr
wait_until_solr_responds 8983
/bin/echo "done."
