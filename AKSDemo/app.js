var http = require('http');
const express = require("express");
const sql = require("mssql");

const app = express();

try {
  console.log(process.env.db_server, 'process.env.db_server');
  console.log(process.env.db_name, 'process.env.db_name');
  console.log(process.env.db_server, 'process.env.db_server');
  console.log(process.env.db_username, 'process.env.db_username');
  console.log(process.env.SA_PASSWORD, 'process.env.SA_PASSWORD');
  console.log(process.env.MSSQL_SA_PASSWORD, 'process.env.MSSQL_SA_PASSWORD');
}
catch (error) {
  console.log(error, ' got error reading env values');
}

// SQL Server configuration
var config = {
  "user": "sa", // Database username
  "password": "Prasad@123", // Database password
  "server": "4.186.8.194", // Server IP address
  "database": "AKSDemo", // Database name
  "options": {
    "encrypt": false // Disable encryption
  }
}

// Connect to SQL Server
sql.connect(config, err => {
  if (err) {
    throw err;
  }
  console.log("Connection Successful!");
});

// Define route for fetching data from SQL Server
app.get("/employees", (request, response) => {
  // Execute a SELECT query
  new sql.Request().query("SELECT * FROM Employee", (err, result) => {
    if (err) {
      console.error("Error executing query:", err);
    } else {
      console.log('sql data read - ', result.recordset);
      response.send(result.recordset); // Send query result as response
    }
  });
});


// Start the server on port 3000
app.listen(3000, () => {
  console.log("Listening on port 3000...");
});