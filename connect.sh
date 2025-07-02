#!/bin/bash
# This script connects to the running MS SQL Server container using sqlcmd.

# Check if the container is running
if [ ! "$(docker ps -q -f name=mssql-server)" ]; then
    echo "Error: The mssql-server container is not running."
    echo "Please start it with: docker-compose up -d"
    exit 1
fi

# Get the password from the .env file, fallback to default
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi
MSSQL_PASSWORD=${MSSQL_SA_PASSWORD:-YourStrong@Passw0rd}

# Execute the sqlcmd command
echo "Connecting to SQL Server..."
docker exec -it mssql-server /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "${MSSQL_PASSWORD}"
