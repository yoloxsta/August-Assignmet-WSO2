# WSO2 Lab Quick Start Script for Windows
# Run this script to start the WSO2 lab environment

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "   WSO2 Lab Environment Setup" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
Write-Host "Checking Docker status..." -ForegroundColor Yellow
$dockerStatus = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker is not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop and try again." -ForegroundColor Red
    exit 1
}
Write-Host "Docker is running." -ForegroundColor Green
Write-Host ""

# Check if Docker Compose is available
Write-Host "Checking Docker Compose..." -ForegroundColor Yellow
$composeVersion = docker-compose --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker Compose is not available!" -ForegroundColor Red
    exit 1
}
Write-Host "Docker Compose found: $composeVersion" -ForegroundColor Green
Write-Host ""

# Create necessary directories
Write-Host "Creating directories..." -ForegroundColor Yellow
$directories = @(
    "apim\deployment",
    "apim\logs",
    "is\deployment", 
    "is\logs",
    "mi\deployment\server\synapse-apis\default",
    "mi\deployment\server\synapse-configs\default\proxy-services",
    "mi\deployment\server\synapse-configs\default\endpoints",
    "mi\logs"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "Created: $dir" -ForegroundColor Gray
    }
}
Write-Host "Directories ready." -ForegroundColor Green
Write-Host ""

# Pull Docker images
Write-Host "Pulling WSO2 Docker images (this may take a few minutes)..." -ForegroundColor Yellow
docker-compose pull

# Start the containers
Write-Host "Starting WSO2 containers..." -ForegroundColor Yellow
docker-compose up -d

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "   WSO2 Lab Starting Up!" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Services are starting. Please wait 2-5 minutes for full startup." -ForegroundColor Yellow
Write-Host ""
Write-Host "Access URLs:" -ForegroundColor White
Write-Host "  API Manager Publisher:  https://localhost:9443/publisher" -ForegroundColor White
Write-Host "  API Manager DevPortal: https://localhost:9443/devportal" -ForegroundColor White
Write-Host "  API Manager Admin:     https://localhost:9443/admin" -ForegroundColor White
Write-Host "  Identity Server:       https://localhost:9444/carbon" -ForegroundColor White
Write-Host "  Micro Integrator:      http://localhost:8290" -ForegroundColor White
Write-Host ""
Write-Host "Default credentials: admin / admin" -ForegroundColor Yellow
Write-Host ""
Write-Host "To check status:" -ForegroundColor White
Write-Host "  docker-compose ps" -ForegroundColor Gray
Write-Host ""
Write-Host "To view logs:" -ForegroundColor White
Write-Host "  docker-compose logs -f" -ForegroundColor Gray
Write-Host ""
Write-Host "To stop:" -ForegroundColor White
Write-Host "  docker-compose down" -ForegroundColor Gray
Write-Host ""
