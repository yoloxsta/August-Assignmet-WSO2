# Lab 4: Complete Integration Solution

## Objective
Build an end-to-end solution combining API Manager, Identity Server, and Micro Integrator.

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          End-to-End Flow                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  1. Client ──────────────► API Manager Gateway (9443/8243)             │
│         │                          │                                    │
│         │                          │ Validate token                      │
│         │                          ▼                                    │
│  2. Token ◄────────────── Identity Server (9444)                       │
│                                    │                                    │
│                                    │ Authorize                          │
│                                    ▼                                    │
│  3. Request ─────────────► Micro Integrator (8290)                     │
│         │                          │                                    │
│         │                          │ Transform/Route                     │
│         │                          ▼                                    │
│  4. Response ◄──────────── Backend Service                             │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## Exercise 4.1: Create the Integration Flow

### Step 1: Create Backend Mock Service

First, let's create a simple mock backend in Micro Integrator.

Create file: `mi/deployment/server/synapse-apis/default/CustomerAPI.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<api context="/backend/customers" name="CustomerAPI" xmlns="http://ws.apache.org/ns/synapse">
    <resource methods="GET" url-mapping="/list">
        <inSequence>
            <payloadFactory media-type="json">
                <format>
                    {
                        "customers": [
                            {"id": 1, "name": "John Doe", "email": "john@example.com"},
                            {"id": 2, "name": "Jane Smith", "email": "jane@example.com"},
                            {"id": 3, "name": "Bob Johnson", "email": "bob@example.com"}
                        ]
                    }
                </format>
                <args/>
            </payloadFactory>
            <property name="Content-Type" value="application/json" scope="transport"/>
            <respond/>
        </inSequence>
    </resource>
    
    <resource methods="GET" url-mapping="/{id}">
        <inSequence>
            <property name="id" expression="get-property('uri.var.id')" scope="default"/>
            <payloadFactory media-type="json">
                <format>
                    {
                        "customer": {
                            "id": $1,
                            "name": "Customer Name",
                            "email": "customer@example.com",
                            "status": "active"
                        }
                    }
                </format>
                <args>
                    <arg expression="get-property('id')"/>
                </args>
            </payloadFactory>
            <property name="Content-Type" value="application/json" scope="transport"/>
            <respond/>
        </inSequence>
    </resource>
</api>
```

### Step 2: Test Backend Directly
```bash
curl -k http://localhost:8290/backend/customers/list
curl -k http://localhost:8290/backend/customers/1
```

## Exercise 4.2: Secure Backend with API Manager

### Step 1: Create API in Publisher

1. Login to Publisher: https://localhost:9443/publisher
2. Create API:
   - Name: `Customer Service API`
   - Context: `/customers`
   - Version: `1.0.0`
   - Production Endpoint: `http://micro-integrator:8290/backend/customers`
   
3. Add Resources:
   - GET `/list` - Get all customers
   - GET `/{id}` - Get customer by ID

4. Publish the API

### Step 2: Configure Key Manager (Optional Advanced)

If using Identity Server as Key Manager:
1. Configure IS as Key Manager in APIM
2. Use IS OAuth2 endpoints for token validation

## Exercise 4.3: Test the Complete Flow

### Step 1: Subscribe and Get Token

```bash
# 1. Create application in DevPortal
# 2. Subscribe to Customer Service API
# 3. Generate access token
```

### Step 2: Test API Gateway

```bash
# Set your access token
export TOKEN="your_access_token"

# Get all customers through API Gateway
curl -k -X GET "https://localhost:8243/customers/1.0.0/list" \
  -H "Authorization: Bearer $TOKEN"

# Get specific customer
curl -k -X GET "https://localhost:8243/customers/1.0.0/1" \
  -H "Authorization: Bearer $TOKEN"
```

## Exercise 4.4: Add Rate Limiting

### Step 1: Create Throttling Policy

1. Login to Admin Portal: https://localhost:9443/admin
2. Go to **Throttling** → **Throttling Policies**
3. Create new policy:
   - Name: `Gold`
   - Request Count: 1000 per minute

### Step 2: Apply to Application

1. In DevPortal, go to your application
2. Change subscription throttling policy to `Gold`

## Exercise 4.5: Monitor with Logs

### Step 1: View API Manager Logs
```bash
docker logs wso2-apim -f
```

### Step 2: View Micro Integrator Logs
```bash
docker logs wso2-mi -f
```

### Step 3: Check Access Patterns
1. Make multiple API calls
2. Observe the logs for:
   - Request path
   - Response time
   - Errors

## Exercise 4.6: Add Custom Headers

### Step 1: Modify MI API to Add Headers

```xml
<inSequence>
    <!-- Add custom header for tracing -->
    <property name="X-Request-ID" expression="get-property('MessageID')" scope="transport"/>
    <property name="X-Source" value="WSO2-MI" scope="transport"/>
    
    <!-- Your existing sequence -->
    ...
</inSequence>
```

## Verification Checklist

- [ ] Backend API created in Micro Integrator
- [ ] Backend tested directly
- [ ] API created in API Manager Publisher
- [ ] API published successfully
- [ ] Application created in DevPortal
- [ ] Subscription created
- [ ] Access token generated
- [ ] API called through Gateway
- [ ] Rate limiting configured
- [ ] Logs monitored

## Architecture Summary

| Component | Role | Port |
|-----------|------|------|
| API Manager | API Gateway, Management | 9443, 8243 |
| Identity Server | Authentication, Authorization | 9444 |
| Micro Integrator | Backend Logic, Transformation | 8290 |
| MySQL | Configuration, User Data | 3306 |

## Production Considerations

1. **High Availability**
   - Run multiple instances
   - Use load balancer

2. **Security**
   - Use proper certificates
   - Configure firewall rules
   - Enable analytics

3. **Performance**
   - Tune JVM settings
   - Configure connection pools
   - Enable caching

4. **Monitoring**
   - Enable analytics
   - Set up alerting
   - Regular log review

## Troubleshooting Guide

### Issue: 401 Unauthorized
- Check token validity
- Verify client credentials
- Check token introspection

### Issue: 404 Not Found
- Verify API context path
- Check if API is published
- Verify endpoint configuration

### Issue: 503 Service Unavailable
- Check backend service status
- Verify network connectivity
- Check endpoint configuration

## Congratulations!
You have completed the WSO2 learning lab. You now understand:
- What WSO2 is and its components
- How to set up a local lab environment
- API lifecycle management
- OAuth2 and SSO configuration
- Service integration patterns

Continue exploring with the official documentation:
- https://wso2.com/documentation/
