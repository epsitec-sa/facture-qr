// pull in desired CSS/SASS files
//require ('./styles/style.css');

// inject bundled Elm app into div#main
var Elm = require("../elm/Main");
var app = Elm.Main.embed(document.getElementById("main"));

function getUrlParam(paramName) {
  try {
    var urlStr = "";
    if (window && window.location && window.location.href) {
      urlStr = window.location.href;
    } else if (document && document.location && document.location.href) {
      urlStr = document.location.href;
    }

    var url = new URL(urlStr);
    var value = null;

    if (!url) {
      console.log("error: url is undefined");

      app.ports.urlParamReceived.send({
        name: paramName,
        value: null,
      });
    }

    if (url.searchParams) {
      value = url.searchParams.get(paramName);
    } else {
      var URLSearchParams = require("url-search-params");
      value = new URLSearchParams(url).get(paramName);
    }

    app.ports.urlParamReceived.send({
      name: paramName,
      value: value,
    });
  } catch (err) {
    console.log("error: " + err.message || err);
    console.log(err.stack);

    app.ports.urlParamReceived.send({
      name: paramName,
      value: null,
    });
  }
}

app.ports.binaryFileRead.subscribe(function (binaryFile) {
  var encodedContent = new Buffer(binaryFile.content, "latin1").toString(
    "base64"
  );

  app.ports.fileBase64Encoded.send({
    content: encodedContent,
    fileName: binaryFile.fileName,
  });
});

app.ports.getUrlParams.subscribe(function (paramNames) {
  for (let paramName of paramNames) {
    getUrlParam(paramName);
  }
});

app.ports.title.subscribe(function (str) {
  document.title = str;
});

app.ports.scrollTo.subscribe(function (args) {
  var parentId = ("#" + args[0]).replace(/\./g, "\\.");
  var childId = ("#" + args[1]).replace(/\./g, "\\.");

  function elementScrolledIntoView() {
    var parentBottom = $(parentId).height();
    var childTop = $(childId).position().top;

    return childTop >= 0 && childTop < parentBottom;
  }

  try {
    if (!elementScrolledIntoView()) {
      $(parentId).scrollTop(0);

      var position = $(childId).position().top;
      $(parentId).scrollTop(position);
    }
  } catch (err) {
    // do nothing
  }
});

app.ports.downloadFile.subscribe(function (args) {
  const content = args[0];
  const mimeType = args[1];
  const filename = args[2];

  const a = document.createElement("a"); // Create "a" element
  const blob = new Blob([content], { type: mimeType }); // Create a blob (file-like object)
  const url = URL.createObjectURL(blob); // Create an object URL from blob

  a.setAttribute("href", url); // Set "a" element link
  a.setAttribute("download", filename); // Set download filename

  a.click(); // Start downloading
});
