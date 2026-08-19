# Lab 2: Identity Server

## Objective
Learn to configure OAuth2 applications and Single Sign-On (SSO) using WSO2 Identity Server.

## Prerequisites
- WSO2 lab environment running
- Browser access to https://localhost:9444/carbon

## Exercise 2.1: Access Identity Server

### Step 1: Login to Management Console
1. Open: https://localhost:9444/carbon
2. Accept security warning
3. Login with:
   - Username: `admin`
   - Password: `admin`

### Step 2: Explore the Console
- Main menu includes: Main, Monitor, Configure
- Key features: Identity Providers, Service Providers, User Stores

## Exercise 2.2: Create OAuth2 Application

### Step 1: Create Service Provider
1. Go to **Main** → **Service Providers** → **Add**
2. Enter Service Provider Name: `SampleApp`
3. Click **Register**

### Step 2: Configure OAuth2
1. In the Service Provider config, expand **"Inbound Authentication Configuration"**
2. Click **"OAuth/OpenID Connect Configuration"**
3. Click **"Configure"**
4. Fill in:
   - Callbak URL: `http://localhost:8080/callback`
   - Allowed Grant Types: Check `Authorization Code`, `Refresh Token`
5. Save
6. **Copy the Client ID and Client Secret** (you'll need these)

## Exercise 2.3: Test OAuth2 Flow

### Authorization Code Flow

#### Step 1: Authorize Request
Open browser with URL (replace CLIENT_ID):
```
https://localhost:9444/oauth2/authorize?response_type=code&client_id=CLIENT_ID&scope=openid&redirect_uri=http://localhost:8080/callback
```

#### Step 2: Login and Consent
1. Login with admin/admin
2. Approve the consent for requested scopes
3. Browser redirects to callback URL with authorization code

#### Step 3: Exchange Code for Token
```bash
# Replace values
export CLIENT_ID="your_client_id"
export CLIENT_SECRET="your_client_secret"
export AUTH_CODE="authorization_code_from_redirect"

curl -k -X POST "https://localhost:9444/oauth2/token" \
  -H "Authorization: Basic $(echo -n $CLIENT_ID:$CLIENT_SECRET | base64)" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=authorization_code&code=$AUTH_CODE&redirect_uri=http://localhost:8080/callback"
```

#### Step 4: Introspect Token
```bash
export ACCESS_TOKEN="access_token_from_step_3"

curl -k -X POST "https://localhost:9444/oauth2/introspect" \
  -H "Authorization: Basic YWRtaW46YWRtaW4=" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "token=$ACCESS_TOKEN"
```

## Exercise 2.4: Configure SSO

### Step 1: Create Two Service Providers
1. Create SP1: `App1`
   - Assertion Consumer URL: `http://localhost:8081/sso`
   - Configure SAML2 or OAuth2
   
2. Create SP2: `App2`
   - Assertion Consumer URL: `http://localhost:8082/sso`
   - Configure SAML2 or OAuth2

### Step 2: Test SSO Flow
1. Login to App1
2. Open App2 in same browser session
3. You should be automatically logged in (no credentials needed)

## Exercise 2.5: User Management

### Step 1: Create New User
1. Go to **Main** → **Users and Roles** → **Add**
2. Click **"Add New User"**
3. Enter:
   - Username: `testuser`
   - Password: `Test@123`
4. Click **Finish**

### Step 2: Create Role
1. Go to **Main** → **Users and Roles** → **Add**
2. Click **"Add New Role"**
3. Role Name: `Developer`
4. Permissions: Select relevant permissions
5. Create

### Step 3: Assign Role to User
1. Go to **Main** → **Users and Roles** → **List**
2. Click **"Roles"**
3. Click on `Developer` role
4. Click **"Assign Users"**
5. Add `testuser`

## Verification Checklist

- [ ] Identity Server management console accessible
- [ ] Service Provider created
- [ ] OAuth2 application configured
- [ ] Client ID and Client Secret obtained
- [ ] Authorization code flow tested
- [ ] Token introspected successfully
- [ ] New user created
- [ ] Role created and assigned

## Useful Endpoints

| Endpoint | Purpose |
|----------|---------|
| `/oauth2/authorize` | Authorization endpoint |
| `/oauth2/token` | Token endpoint |
| `/oauth2/introspect` | Token introspection |
| `/oauth2/revoke` | Token revocation |
| `/oidc/userinfo` | User info endpoint |
| `/scim2/Users` | SCIM2 user management |

## Next Steps
Proceed to Lab 3: Micro Integrator to learn about service integration.
