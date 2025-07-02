# MS SQL Server Docker Container

This repository contains a Docker setup for Microsoft SQL Server with data persistence.

## Features

- MS SQL Server 2022 Express Edition
- Data persistence through Docker volumes
- Easy configuration through environment variables
- Docker Compose for simplified deployment

## Quick Start

### Using Docker Compose (Recommended)

1. **Clone and navigate to the directory**
   ```bash
   cd /path/to/your/project
   ```

2. **Create environment file**
   ```bash
   cp .env.example .env
   ```
   
3. **Edit the `.env` file and set a strong password**
   ```bash
   nano .env
   ```
   
4. **Start the SQL Server container**
   ```bash
   docker-compose up -d
   ```

### Using Docker Build and Run

1. **Build the image**
   ```bash
   docker build -t mssql-custom .
   ```

2. **Run the container**
   ```bash
   docker run -d \
     --name mssql-server \
     -e ACCEPT_EULA=Y \
     -e MSSQL_SA_PASSWORD=YourStrong@Passw0rd \
     -p 1433:1433 \
     -v mssql_data:/var/opt/mssql/data \
     -v mssql_log:/var/opt/mssql/log \
     -v mssql_backup:/var/opt/mssql/backup \
     mssql-custom
   ```

## Configuration

### Environment Variables

- `ACCEPT_EULA`: Must be set to `Y` to accept the End-User License Agreement
- `MSSQL_SA_PASSWORD`: Password for the SA account (must meet complexity requirements)
- `MSSQL_PID`: SQL Server edition (Express, Developer, Standard, Enterprise, or ProductID)
- `MSSQL_TCP_PORT`: TCP port for SQL Server (default: 1433)

### Password Requirements

The SA password must meet the following requirements:
- At least 8 characters long
- Contains characters from at least 3 of these categories:
  - Uppercase letters (A-Z)
  - Lowercase letters (a-z)
  - Numbers (0-9)
  - Special characters (!@#$%^&*()_+-=[]{}|;':\",./<>?)

## Data Persistence

The following directories are mounted as volumes for data persistence:
- `/var/opt/mssql/data` - Database files
- `/var/opt/mssql/log` - Transaction log files
- `/var/opt/mssql/backup` - Backup files

## Connecting to SQL Server

### Connection Details
- **Server**: localhost (or your Docker host IP)
- **Port**: 1433
- **Username**: sa
- **Password**: (as set in your environment variables)

### Using SQL Server Management Studio (SSMS)
1. Server type: Database Engine
2. Server name: localhost,1433 (or your-docker-host-ip,1433)
3. Authentication: SQL Server Authentication
4. Login: sa
5. Password: Your configured password

### Using sqlcmd
```bash
# Connect from within the container
docker exec -it mssql-server /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'YourStrong@Passw0rd'

# Connect from host (if sqlcmd is installed)
sqlcmd -S localhost,1433 -U sa -P 'YourStrong@Passw0rd'
```

## Management Commands

### View container logs
```bash
docker-compose logs -f mssql
```

### Stop the container
```bash
docker-compose down
```

### Remove everything (including volumes)
```bash
docker-compose down -v
```

### Backup database
```bash
# Example backup command
docker exec mssql-server /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'YourStrong@Passw0rd' -Q "BACKUP DATABASE [YourDatabase] TO DISK = '/var/opt/mssql/backup/YourDatabase.bak'"
```

## Security Notes

1. **Change the default password** - Never use the example password in production
2. **Use environment files** - Keep sensitive data in `.env` files that are not committed to version control
3. **Network security** - Consider using Docker networks and firewall rules
4. **Regular updates** - Keep the SQL Server image updated

## Troubleshooting

### Container won't start
- Check if the password meets complexity requirements
- Ensure port 1433 is not already in use
- Check Docker logs: `docker-compose logs mssql`

### Can't connect to SQL Server
- Verify the container is running: `docker ps`
- Check if the port is accessible: `telnet localhost 1433`
- Verify credentials and connection string

### Data not persisting
- Ensure volumes are properly mounted
- Check volume permissions
- Verify volume paths in docker-compose.yml

## License

This project uses Microsoft SQL Server, which requires accepting the Microsoft SQL Server End-User License Agreement.
