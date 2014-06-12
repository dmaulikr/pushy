/*
var cradle = require('cradle');

var connection = new(cradle.Connection)('https://cdb.forskningsdata.se', 443, {
      auth: { username: 'sounduser', password: '7i2pzeDadaiC' }
  }).database('soundscape');
*/

var http = require('http');
var https = require('https');
var qs = require('querystring');


   var headers = {
     'Content-Type': 'application/json',
     'Authorization': 'Basic ' + new Buffer('sounduser:7i2pzeDadaiC').toString('base64')
   };

   var options = {
     host: 'cdb.forskningsdata.se',
     port: 443,
     path: '/soundscape/_design/add/_update/measurement',
     method: 'POST',
     headers: headers
   };

function post(url) {

   var d = qs.parse(url.substring(url.indexOf('?')+1));

   var data = JSON.stringify({
     user: d.u,
     decibel: parseFloat(d.p),
     pos: d.la + "," + d.lo 
   });

   console.log(data);

   var req = https.request(options, function(res) {
      res.on('data', function(data) {
        console.log(data.toString());
      });
   });
   req.on('error', function(e){ console.log(e);});
   req.write(data);
   req.end();
}

post('http://127.0.0.1/figaro?u=robert&a=-56.0004&p=37.0345&la=57.12356&lo=12.42');

http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World\n');
  console.log('received ->' + req.url);
  post(req.url);
}).listen(1337, '127.0.0.1');
console.log('Server running at http://127.0.0.1:1337/');
