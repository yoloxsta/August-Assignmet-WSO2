# Common WSO2 Lab Commands - Windows PowerShell

# ============================================
# QUICK START (API Manager Only)
# ============================================

# Start quick start environment
.\start-quick.ps1

# Check if API Manager is running
docker ps | Select-String wso2

# View API Manager logs
docker logs wso2-apim-quickstart -f

# Stop quick start
docker-compose -f docker-compose.quickstart.yml down

# ============================================
# FULL LAB ENVIRONMENT
# ============================================

# Start all services
.\quick-start.ps1

# Or manually
docker-compose up -d

# Check status of all services
docker-compose ps

# View logs for specific service
docker-compose logs -f apim
docker-compose logs -f identity-server
docker-compose logs -f micro-integrator

# Stop all services
docker-compose down

# Stop and remove volumes (clean slate)
docker-compose down -v

# ============================================
# TESTING
# ============================================

# Run environment test
.\test-environment.ps1

# Test API Manager is responding
Invoke-WebRequest -Uri "https://localhost:9443/carbon" -SkipCertificateCheck

# Test Micro Integrator health
Invoke-WebRequest -Uri "http://localhost:8290/health"

# ============================================
# TROUBLESHOOTING
# ============================================

# Check container logs
docker logs wso2-apim
docker logs wso2-is
docker logs wso2-mi
docker logs wso2-mysql

# Enter container shell
docker exec -it wso2-apim bash
docker exec -it wso2-mi bash

# Check container resource usage
docker stats --no-stream

# Restart a specific service
docker-compose restart apim

# ============================================
# API TESTING (after setup)
# ============================================

# Get OAuth token (replace CLIENT_ID and CLIENT_SECRET)
$credentials = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("CLIENT_ID:CLIENT_SECRET"))
$headers = @{
    "Authorization" = "Basic $credentials"
    "Content-Type" = "application/x-www-form-urlencoded"
}
$body = "grant_type=password&username=admin&password=admin&scope=apim:api_view"
$token = Invoke-RestMethod -Uri "https://localhost:9443/oauth2/token" -Method POST -Headers $headers -Body $body -SkipCertificateCheck
$token.access_token

# Call API through gateway (replace ACCESS_TOKEN and API_PATH)
$headers = @{
    "Authorization" = "Bearer ACCESS_TOKEN"
}
Invoke-RestMethod -Uri "https://localhost:8243/API_PATH" -Headers $headers -SkipCertificateCheck

# ============================================
# CLEANUP
# ============================================

# Remove all containers
docker-compose down

# Remove all containers and volumes
docker-compose down -v

# Remove all WSO2 images
docker rmi wso2/wso2am:4.5.0
docker rmi wso2/wso2is:6.1.0
docker rmi wso2/wso2mi:4.3.0

# Full cleanup (containers, volumes, images)
docker-compose down -v
docker system prune -f
