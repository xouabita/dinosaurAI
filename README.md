dinosaurAI
==========

![screenshot](http://i.imgur.com/oIFahNy.png?1)

Disclaimer
----------

_This project is heavily inspired by [IAMDinosaur](https://github.com/ivanseidel/IAMDinosaur). Go check it._

Install
-------

1. You need to have nodejs and coffee-script installed
2. Run `npm i`

Run
---

You need to run `webpack-dev-server --watch` to serve and watch the script. Then
add the following script in your bookmarklet:

~~~js
javascript: (function () {
  var script = document.createElement('script');
  script.setAttribute('src', 'http://localhost:8080/app.js');
  document.body.appendChild(script);
}());
~~~

Also, if you want to save the genomes, you can run `coffee server.coffee`

Once it is done, turn off your internet and click on your bookmarklet when you see the dinosaur.
