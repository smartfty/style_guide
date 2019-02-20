## SuckerPunch 

Sucker Punch — a single-process Ruby asynchronous processing library that runs with your existing app’s process.
Gem is built on top of concurrent-ruby and have no dependencies with any data storage, what is both an advantage and a disadvantage.
Running in the application process really simplifies the deployment process, but If the web processes are restarted with jobs remaining in the queue, they will be lost. Also, since all state persistence is in memory, Sucker Punch can operate extremely fast on small tasks. But if the application implies a large number background jobs, Sucker Punch turns out to be the wrong decision, because you’ll need to write your own logic of monitoring/restarting jobs.