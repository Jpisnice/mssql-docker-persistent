# MS SQL Server Docker Container

This repository contains a Docker setup for Microsoft SQL Server with data persistence.

## Features

- MS SQL Server 2022 Express Edition
- Data persistence through Docker volumes
- Easy configuration through environment variables
- Docker Compose for simplified deployment
- Includes `sqlcmd` for command-line interaction
- Helper script (`connect.sh`) for easy connection
- Example initialization script (`init.sql`)

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
   
4. **Build and start the SQL Server container**
   ```bash
   docker compose up --build -d
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
  - Special characters (!@#$%^&*()_+-=[]{}|;'\",./<>?)

## Data Persistence

The following directories are mounted as volumes for data persistence:
- `/var/opt/mssql/data` - Database files
- `/var/opt/mssql/log` - Transaction log files
- `/var/opt/mssql/backup` - Backup files

## Connecting to SQL Server

### Using the Connection Script (Recommended)

A helper script is provided for convenience:

- **Linux/macOS:**
  1. Make the script executable:
     ```bash
     chmod +x connect.sh
     ```
  2. Run the script:
     ```bash
     ./connect.sh
     ```
     This will open an interactive `sqlcmd` session.

- **Windows:**
  1. Double-click `connect.bat` or run it from Command Prompt:
     ```bat
     connect.bat
     ```
     This will open an interactive `sqlcmd` session in the container.

### Using SQL Server Management Studio (SSMS)

To connect to the SQL Server instance running in Docker using SSMS:

1. **Start the container** (if not already running):
   ```bash
   docker compose up -d
   ```
2. **Open SQL Server Management Studio (SSMS)** on your Windows machine.
3. **Connect to the server:**
   - **Server type:** Database Engine
   - **Server name:** `localhost,1433` (or use your Docker host's IP, e.g., `192.168.x.x,1433` if connecting from another machine)
   - **Authentication:** SQL Server Authentication
   - **Login:** `sa`
   - **Password:** The value you set for `MSSQL_SA_PASSWORD` in your `.env` file (default: `YourStrong@Passw0rd`)
4. **Click Connect.**

If you have issues connecting from another machine, ensure port 1433 is open and accessible on your Docker host.

### Using sqlcmd Manually

You can also connect manually using `docker exec`:
```bash
# Connect from your host machine
docker exec -it mssql-server sqlcmd -S localhost -U sa -P 'YourStrong@Passw0rd'
```

## Database Initialization

An example script `init.sql` is provided to create a sample database and table.

To run the script:
```bash
docker exec -i mssql-server sqlcmd -S localhost -U sa -P 'YourStrong@Passw0rd' < init.sql
```
This will:
1. Create a database named `TestDB`.
2. Create a table named `Employees`.
3. Insert a sample record into the `Employees` table.

## Management Commands

### View container logs
```bash
docker compose logs -f mssql
```

### Stop the container
```bash
docker compose down
```

### Remove everything (including volumes)
```bash
docker compose down -v
```

### Backup database
```bash
# Example backup command
docker exec mssql-server sqlcmd -S localhost -U sa -P 'YourStrong@Passw0rd' -Q "BACKUP DATABASE [TestDB] TO DISK = '/var/opt/mssql/backup/TestDB.bak'"
```

## Security Notes

1. **Change the default password** - Never use the example password in production
2. **Use environment files** - Keep sensitive data in `.env` files that are not committed to version control
3. **Network security** - Consider using Docker networks and firewall rules
4. **Regular updates** - Keep the SQL Server image updated

## Troubleshooting

### Container won't start or is in a restart loop

- **Permission Errors (`Access is denied.`):** The container might not have permission to write to the mounted volumes. Ensure that `user: "0:0"` is set in the `docker-compose.yml` file to run the container as root.
- **Build Errors:** If the Docker build fails, it could be due to issues with package installation. Ensure that `gnupg` is installed and that the correct Ubuntu version is specified in the `Dockerfile` for the Microsoft package repository.
- **Password Complexity:** Ensure the `MSSQL_SA_PASSWORD` meets the complexity requirements.
- **Port Conflicts:** Make sure port 1433 is not already in use on your host machine.
- **Check Logs:** Always check the container logs for specific error messages: `docker-compose logs mssql`

### Can't connect to SQL Server

- **Container Status:** Verify the container is running with `docker ps`.
- **Port Accessibility:** Check if the port is accessible from your host: `telnet localhost 1433`.
- **Credentials:** Double-check the server name, username, and password in your connection string.
