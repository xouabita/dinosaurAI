ia-dinosaur
===========

A simple script/bookmarklet to train a dinosaur to jump cactus.

Debug
-----

You can run `webpack-dev-server --watch` to serve and watch the script. Then
add the following script in your bookmarklet:

~~~js
javascript: (function () {
  var script = document.createElement('script');
  script.setAttribute('src', 'http://localhost:8080/app.js');
}());
~~~
