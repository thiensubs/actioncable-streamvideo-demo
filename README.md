# Action Cable Examples

A collection of examples showcasing the capabilities of Action Cable.
*  `Live Stream Video (Or Image).`
*  `Chart Live Data.`

## Dependencies

You must have redis installed and running on the default port:6379 (or configure it in config/redis/cable.yml).

### Installing Redis
##### On Linux
* `wget http://download.redis.io/redis-stable.tar.gz`
* `tar xvzf redis-stable.tar.gz`
* `cd redis-stable`
* `make`
* `make install`

##### On Mac
* `brew install redis`

###### Note: You must have Ruby 2.2.2 (I'm using 2.5.0) installed in order to use redis

## Starting the servers

1. Run `bundle install -j 4`
2. Open up a separate terminal and run: `./bin/rails server`
3. One more terminal to run redis server: `redis-server`
4. One more terminal Run `bundle exec sidekiq`
5. One more terminal Run `anycable`
6. One more terminal Run `anycable-go --host=0.0.0.0 --port=28080 \
              --path=/cable \
              --rpc_host=0.0.0.0:50051 \
              --redis_url=redis://localhost:6379/2 \
              --redis_channel=__anycable__ \
              --debug`

    NOTE: You can use anycable-go or anycable-erlang, I choiced: anycable-go, So install follow that: https://github.com/anycable/anycable-go

7. Visit `http://localhost:3000/`


## Live Video Stream example

1. Open two browsers with separate cookie spaces (like a regular session and an incognito session).
2. Login as different people in each browser.
3. Go to the same message.
4. Now you can see video from webcam laptop stream to every member in this room.

## Chart with Live Data example

1. Open two browsers with separate cookie spaces (like a regular session and an incognito session).
2. Login as different people in each browser.
3. Click Chart with live data.
4. Now you can see the chart stream to every member in this room.

### TODO
 - [ ]  Find the way sending image via WebSocket (replace current POST).
 - [x] Upgrade Rails. (target is lasted 6)
 - [x] Upgrade Ruby. (target is 3)
 - [ ] Add End to End encrypted.

##CUSTOM IS YOUR...
You can custom it...
