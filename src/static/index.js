// pull in desired CSS/SASS files
//require ('./styles/style.css');

// inject bundled Elm app into div#main
var Elm = require ('../elm/Main');
var app = Elm.Main.embed (document.getElementById ('main'));

app.ports.binaryFileRead.subscribe (function (binaryFile) {
  var encodedContent = new Buffer (binaryFile.content, 'latin1').toString (
    'base64'
  );

  app.ports.fileBase64Encoded.send ({
    content: encodedContent,
    fileName: binaryFile.fileName,
  });
});

app.ports.getUrlParam.subscribe (function (paramName) {
  try {
    var url = new URL(window.location.href);
    var c = null;

    if (url && url.searchParams) {
      c = url.searchParams.get(paramName);
    } else {
      var URLSearchParams = require('url-search-params');
      c = new URLSearchParams(url).get(paramName);
    }

    app.ports.urlParamReceived.send ({
      name: paramName,
      value: c
    });
  } catch(err) {
    console.log(err)

    app.ports.urlParamReceived.send ({
      name: paramName,
      value: null
    });
  }
});


app.ports.title.subscribe (function (str) {
  document.title = str;
});

app.ports.scrollTo.subscribe (function (args) {
  var parentId = ('#' + args[0]).replace (/\./g, '\\.');
  var childId = ('#' + args[1]).replace (/\./g, '\\.');

  function elementScrolledIntoView () {
    var parentBottom = $ (parentId).height ();
    var childTop = $ (childId).position ().top;

    return childTop >= 0 && childTop < parentBottom;
  }

  try {
    if (!elementScrolledIntoView ()) {
      $ (parentId).scrollTop (0);

      var position = $ (childId).position ().top;
      $ (parentId).scrollTop (position);
    }
  } catch (err) {
    // do nothing
  }
});
