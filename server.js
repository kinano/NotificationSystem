// Create the server:
var app = require('http').createServer(handler),
  io = require('socket.io').listen(app),
  fs = require('fs'),
  mysql = require('mysql'),
  connectionsArray = [],
  // MySQL DB connection:
  connection = mysql.createConnection({
    host: 'localhost',
    user: 'notification_sys',
    password: 'Password123',
    database: 'notification_system',
    port: 3306
  }),
  // Polling interval:
  POLLING_INTERVAL = 1000,
  pollingTimer;

// Connect to the DB:
connection.connect(function(err) {
  if (err) {
    console.log(err);
  }
});

// Listen on port 8000:
app.listen(8000);

// once the server is up, we can load our client.html page
function handler(req, res) {
  fs.readFile(__dirname + '/client.html', function(err, data) {
    if (err) {
      console.log(err);
      res.writeHead(500);
      return res.end('Error loading client.html');
    }
    res.writeHead(200);
    res.end(data);
  });
}

// Main function:
var pollingLoop = function() {  
  var query = connection.query('call get_pending_notifications'),
    // The records array will contain the db results:
    records = []; 
  // setting the query listeners
  query
    .on('error', function(err) {
      // Handle error, and 'end' event will be emitted after this as well
      console.log(err);
      updateSockets(err);
    })
    .on('result', function(record) {
    console.log('record = ' + JSON.stringify(record));
      // ignore empty records:
      if(record.fieldCount != 0){
        records.push(record);
      }
    })
    .on('end', function() {
      // Run the polling program only if there are listening clients:
      if (connectionsArray.length) {
        pollingTimer = setTimeout(pollingLoop, POLLING_INTERVAL);
        updateSockets({
          records: records
        });
      } else {
        console.log('The server timer was stopped because there are no more socket connections on the app')
      }
    });
};

// creating a new websocket to keep the content updated without any AJAX request
io.sockets.on('connection', function(socket) {
  console.log('Number of connections:' + connectionsArray.length);
  if (!connectionsArray.length) {
    pollingLoop();
  }

  socket.on('disconnect', function() {
    var socketIndex = connectionsArray.indexOf(socket);
    console.log('socketID = %s got disconnected', socketIndex);
    if (~socketIndex) {
      connectionsArray.splice(socketIndex, 1);
    }
  });
  console.log('A new socket is connected!');
  connectionsArray.push(socket);
});

var updateSockets = function(data) {
  // adding the time of the last update
  data.time = new Date();
  console.log('Pushing new data to the clients connected ( connections amount = %s ) - %s', connectionsArray.length , data.time);
  // sending new data to all the sockets connected
  connectionsArray.forEach(function(tmpSocket) {
    tmpSocket.volatile.emit('notification', data);
  });
};

console.log('Please use your browser to navigate to http://localhost:8000/NotificationSystem');