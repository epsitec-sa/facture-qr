// pull in desired CSS/SASS files
//require( './styles/main.scss' );

// inject bundled Elm app into div#main
var Elm = require ('../elm/Main');
var app = Elm.Main.embed (document.getElementById ('main'));

app.ports.binaryFileRead.subscribe (function (binaryFile) {
  var encodedContent = btoa (
    String.fromCharCode.apply (null, new Uint8Array (binaryFile.content))
  );

  app.ports.fileEncoded.send ({
    content: encodedContent,
    fileName: binaryFile.fileName,
  });
});
