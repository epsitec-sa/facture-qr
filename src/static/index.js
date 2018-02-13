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

app.ports.title.subscribe (function (str) {
  document.title = str;
});

app.ports.scrollTo.subscribe (function (args) {
  try {
    var parentId = ('#' + args[0]).replace (/\./g, '\\.');
    var childId = ('#' + args[1]).replace (/\./g, '\\.');

    $ (parentId).scrollTop ();

    console.dir ($ (childId).position ().top);
    $ (parentId).scrollTop ($ (childId).position ().top);
  } catch (err) {
    // do nothing
  }
});
