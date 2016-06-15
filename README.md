## [Scrumtious](https://scrumtio.us)
*A simple online scrumboard, great for small, agile scrum teams*

---

###### Built with:
- [MongoDB](https://www.mongodb.org/)
- [Redis](http://redis.io/)
- [Flask](http://flask.pocoo.org/)
- [Socket.IO](http://socket.io/)
- [CoffeeScript](http://coffeescript.org/)
- [JQuery](https://jquery.com/)
- [Materialize](http://materializecss.com/)

### Contributions
For the Python part, a `virtualenv` makes the most sense. To install the necessary Python packages hit `$ pip install -r requirements.txt`.

As for configuration, the application is hosted on [Heroku](https://www.heroku.com/home), so use of the [Heroku toolbelt](https://toolbelt.heroku.com/)'s `$ heroku local` along with a `.env` file best simulates the production environment. The `cakefile`, however, is set up to run without `heroku`.

For the application to access Mongo and Redis in your local environment, add a `.env` file to the repo root like this:
``` bash
DEBUG=TRUE
PYTHONUNBUFFERED=TRUE
MONGODB_URI='mongodb://localhost:27017/scrumtious'
REDISCLOUD_URL='redis://localhost:6379/0'
```
If you are using `cake run`, add an `export` to each line of the above config file.

MongoDB downloads are available [here](https://docs.mongodb.com/manual/installation/).

Redis downloads are available [here](http://redis.io/download).

If you have [Node](https://nodejs.org/en/) already installed, you can install the  [CoffeeScript](http://coffeescript.org/) compiler with `$ npm install -g coffee-script`.

From there, you can hit `$ cake` to get more information on building/testing.

###### When Contributing:
- *[`TODO`](http://scrumtio.us/Scrumtious/db5f1e5b6be063a498a80e1cea8cb6e7fe2137af)*
- Contact [Andy](https://andrewdbooth.me) for information on where to help.
- Checkout and make pull requests to `dev`.
