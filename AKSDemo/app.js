const express = require("express");
const sql = require("mssql");

const app = express();

try {
  console.log(process.env.DB_SERVER, 'process.env.DB_SERVER');
  console.log(process.env.DB_NAME, 'process.env.DB_NAME');
  console.log(process.env.DB_USERNAME, 'process.env.DB_USERNAME');
  console.log(process.env.MSSQL_SA_PASSWORD, 'process.env.MSSQL_SA_PASSWORD');
}
catch (error) {
  console.log(error, '- got error reading env values');
}

// SQL Server configuration
const config = {
  "user": process.env.DB_USERNAME, // Database username
  "password": process.env.MSSQL_SA_PASSWORD, // Database password
  "server": process.env.DB_SERVER, // Server IP address
  "database": process.env.DB_NAME, // Database name
  "options": {
    "encrypt": false // Disable encryption
  }
}

// Connect to SQL Server
sql.connect(config, err => {
  if (err) {
    console.log(err, "- error connecting to database");
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