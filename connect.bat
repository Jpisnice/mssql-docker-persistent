@echo off
REM This script connects to the running MS SQL Server container using sqlcmd (Windows)

REM Set default password
set MSSQL_PASSWORD=YourStrong@Passw0rd

REM Try to read password from .env if it exists
if exist .env (
    for /f "usebackq tokens=1,2 delims==" %%A in ('.env') do (
        if "%%A"=="MSSQL_SA_PASSWORD" set MSSQL_PASSWORD=%%B
    )
)

REM Check if the container is running
docker ps -q -f name=mssql-server >nul 2>&1
if errorlevel 1 (
    echo Error: The mssql-server container is not running.
    echo Please start it with: docker compose up -d
    exit /b 1
)

REM Connect using sqlcmd inside the container
echo Connecting to SQL Server...
docker exec -it mssql-server \
    sqlcmd -S localhost -U sa -P "%MSSQL_PASSWORD%"
