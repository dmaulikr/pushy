//set username and password here before starting!
var credentials = 'username:password';

process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

var http = require('http');
var https = require('https');
var qs = require('querystring');


   var headers = {
     'Content-Type': 'application/json',
     'Authorization': 'Basic ' + new Buffer(credentials).toString('base64')
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

http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Ok\n');
  console.log('received ->' + req.url);
  post(req.url);
}).listen(1337);
console.log('Server running...');
