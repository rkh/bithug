Design Goals
============

Design goals for the Bithug refactoring:

* One config file/dsl to setup anyting (like workers, load balancer, redis, ...)
* Async/non-blocking for everything
* Clustering / worker queues
* Real time ajax updates for feed
* Webhooks / API that is GitHub compatible

Technology
----------

* Swiftiply for clustering?
* Redis for queues / data
* Grit for git integration
* EventMachine
* Thin for async requests / comet / as webserver
* Comet of some kind
* Sinatra with Haml/Compass (BigBand)
* jQuery
