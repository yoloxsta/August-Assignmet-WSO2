# Lab 1: API Manager Basics

## Objective
Learn to create, publish, subscribe to, and test APIs using WSO2 API Manager.

## Prerequisites
- WSO2 lab environment running
- Browser access to https://localhost:9443/publisher

## Exercise 1.1: Create a Sample API

### Step 1: Access the Publisher Portal
1. Open browser and go to: https://localhost:9443/publisher
2. Accept the security warning (self-signed certificate)
3. Login with credentials:
   - Username: `admin`
   - Password: `admin`

### Step 2: Create a New API
1. Click **"Create API"**
2. Select **"Design a New REST API"**
3. Fill in the details:
   - Name: `Phone Verification API`
   - Context: `/phoneverify`
   - Version: `1.0.0`
   - Endpoint: `http://ws.cdyne.com/phoneverify/phoneverify.asmx` (example public service)
   
4. Click **"Create"**

### Step 3: Design the API
1. Navigate to **"API Definition"** tab
2. Add a new resource:
   - Path: `/verify/{phoneNumber}`
   - Method: GET
   - Description: Verify a phone number
3. Save the API

### Step 4: Configure Endpoints
1. Go to **"Endpoints"** tab
2. Add production endpoint:
   - URL: `http://ws.cdyne.com/phoneverify/phoneverify.asmx`
3. Save

## Exercise 1.2: Publish the API

### Step 1: Lifecycle Management
1. Go to **"Lifecycle"** tab
2. Click **"Publish"** to make the API available
3. Confirm the publication

### Step 2: Verify in DevPortal
1. Open: https://localhost:9443/devportal
2. Login as `admin/admin`
3. You should see the "Phone Verification API" listed

## Exercise 1.3: Subscribe to the API

### Step 1: Create an Application
1. In DevPortal, go to **"Applications"**
2. Click **"Add New Application"**
3. Enter details:
   - Name: `Phone App`
   - Description: `Application for phone verification`
4. Save

### Step 2: Subscribe
1. Go to **"APIs"** in DevPortal
2. Click on "Phone Verification API"
3. Click **"Subscribe"**
4. Select:
   - Application: Phone App
   - Throttling Policy: Unlimited
5. Subscribe

### Step 3: Generate Keys
1. Go to **"Applications"** → **"Phone App"**
2. Click **"Production Keys"** tab
3. Click **"Generate Keys"**
4. Copy the **Access Token**

## Exercise 1.4: Test the API

### Option 1: Using Built-in Console
1. In DevPortal, go to the API
2. Click **"Try Out"** tab
3. Select the application
4. Authorize with the access token
5. Test the `/verify/{phoneNumber}` endpoint
   - Example: `phoneNumber` = `18005551234`

### Option 2: Using curl
```bash
# Get access token first (use the token from previous step)
export ACCESS_TOKEN="YOUR_ACCESS_TOKEN"

# Call the API
curl -k -X GET "https://localhost:8243/phoneverify/1.0.0/verify/18005551234" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "accept: application/json"
```

## Verification Checklist

- [ ] API created in Publisher
- [ ] API published successfully
- [ ] API visible in DevPortal
- [ ] Application created
- [ ] Subscription created
- [ ] Access token generated
- [ ] API invoked successfully

## Common Issues

### Certificate Error
- Use `-k` flag with curl to skip certificate verification
- Accept browser security warning for self-signed cert

### 401 Unauthorized
- Check that token is valid and not expired
- Verify Authorization header format: `Bearer <token>`

### API Not Found
- Ensure API is published (not just created)
- Check the correct context and version in URL

## Next Steps
Proceed to Lab 2: Identity Server to learn about OAuth2 and SSO.
