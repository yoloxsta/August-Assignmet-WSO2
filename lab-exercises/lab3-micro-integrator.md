# Lab 3: Micro Integrator

## Objective
Learn to create and deploy integration services using WSO2 Micro Integrator.

## Prerequisites
- WSO2 lab environment running
- Basic understanding of REST APIs

## Exercise 3.1: Understanding Micro Integrator

### What is Micro Integrator?
- Lightweight ESB runtime
- Designed for microservices architecture
- Supports message routing, transformation, orchestration
- Configuration-driven (XML-based)

### Key Concepts
| Concept | Description |
|---------|-------------|
| **Proxy Service** | Exposes a service endpoint |
| **API** | REST API definition |
| **Inbound Endpoint** | Receives messages |
| **Message Mediators** | Process messages |
| **Endpoints** | Backend service connections |

## Exercise 3.2: Deploy a Sample API

### Step 1: Create Integration Project
We'll create a simple API that:
1. Receives a request
2. Logs the message
3. Transforms it
4. Sends to backend
5. Returns response

### Step 2: Create the API Definition

Create file: `mi/deployment/server/synapse-apis/default/SampleAPI.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<api context="/sample" name="SampleAPI" xmlns="http://ws.apache.org/ns/synapse">
    <resource methods="GET" url-mapping="/hello">
        <inSequence>
            <!-- Log incoming request -->
            <log level="custom">
                <property name="message" value="Received hello request"/>
            </log>
            
            <!-- Create response -->
            <payloadFactory media-type="json">
                <format>{"message": "Hello from WSO2 Micro Integrator!", "timestamp": "$1"}</format>
                <args>
                    <arg expression="get-property('SYSTEM_DATE')"/>
                </args>
            </payloadFactory>
            
            <!-- Set response headers -->
            <property name="Content-Type" value="application/json" scope="transport"/>
            <property name="HTTP_SC" value="200" scope="axis2"/>
            
            <!-- Send response -->
            <respond/>
        </inSequence>
        <outSequence/>
        <faultSequence>
            <log level="full">
                <property name="ERROR" value="Error occurred in SampleAPI"/>
            </log>
            <respond/>
        </faultSequence>
    </resource>
</api>
```

### Step 3: Copy to Container
```bash
# Create the synapse-apis directory
mkdir -p mi/deployment/server/synapse-apis/default

# The file will be mounted and picked up by MI
```

### Step 4: Test the API
```bash
curl -k -X GET "http://localhost:8290/sample/hello"
```

Expected response:
```json
{
  "message": "Hello from WSO2 Micro Integrator!",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

## Exercise 3.3: Create a Proxy Service

### Step 1: Create Proxy Service Definition

Create file: `mi/deployment/server/synapse-configs/default/proxy-services/WeatherProxy.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<proxy name="WeatherProxy" startOnLoad="true" transports="http https" xmlns="http://ws.apache.org/ns/synapse">
    <target>
        <inSequence>
            <!-- Log incoming request -->
            <log level="custom">
                <property name="FLOW" value="WeatherProxy - IN"/>
            </log>
            
            <!-- Extract city from query param -->
            <property name="city" expression="$url:city" scope="default" type="STRING"/>
            
            <!-- Log the city -->
            <log level="custom">
                <property expression="get-property('city')" name="City"/>
            </log>
            
            <!-- Call weather API (mock endpoint) -->
            <call>
                <endpoint key="WeatherEndpoint"/>
            </call>
        </inSequence>
        <outSequence>
            <!-- Transform response -->
            <payloadFactory media-type="json">
                <format>
                    {
                        "service": "WeatherProxy",
                        "data": $1
                    }
                </format>
                <args>
                    <arg evaluator="json" expression="$"/>
                </args>
            </payloadFactory>
            
            <!-- Send response -->
            <send/>
        </outSequence>
        <faultSequence>
            <log level="full">
                <property name="ERROR" value="Error in WeatherProxy"/>
            </log>
            <payloadFactory media-type="json">
                <format>{"error": "Service temporarily unavailable"}</format>
                <args/>
            </payloadFactory>
            <property name="HTTP_SC" value="503" scope="axis2"/>
            <respond/>
        </faultSequence>
    </target>
</proxy>
```

### Step 2: Create Endpoint Definition

Create file: `mi/deployment/server/synapse-configs/default/endpoints/WeatherEndpoint.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<endpoint name="WeatherEndpoint" xmlns="http://ws.apache.org/ns/synapse">
    <http method="GET" uri-template="http://wttr.in/{uri.var.city}?format=j1">
        <suspendOnFailure>
            <progressionOnFailure>true</progressionOnFailure>
        </suspendOnFailure>
        <markForSuspension>
            <retriesBeforeSuspension>3</retriesBeforeSuspension>
            <retryDelay>1000</retryDelay>
        </markForSuspension>
    </http>
</endpoint>
```

### Step 3: Test the Proxy
```bash
curl -k "http://localhost:8290/services/WeatherProxy?city=London"
```

## Exercise 3.4: Message Transformation

### Step 1: Create Transformation API

Create file that transforms XML to JSON:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<api context="/transform" name="TransformAPI" xmlns="http://ws.apache.org/ns/synapse">
    <resource methods="POST" url-mapping="/xml2json">
        <inSequence>
            <!-- Log original message -->
            <log level="full">
                <property name="step" value="Original XML"/>
            </log>
            
            <!-- Transform XML to JSON -->
            <property name="messageType" value="application/json" scope="axis2"/>
            <property name="ContentType" value="application/json" scope="axis2"/>
            
            <!-- Send transformed response -->
            <respond/>
        </inSequence>
    </resource>
</api>
```

### Step 2: Test Transformation
```bash
curl -k -X POST "http://localhost:8290/transform/xml2json" \
  -H "Content-Type: application/xml" \
  -d '<person><name>John</name><age>30</age><city>New York</city></person>'
```

Expected response:
```json
{
  "person": {
    "name": "John",
    "age": "30",
    "city": "New York"
  }
}
```

## Exercise 3.5: Health Check

### Step 1: Check MI Health
```bash
curl -k http://localhost:8290/health
```

### Step 2: View Deployed Services
```bash
# List deployed APIs
curl -k -u admin:admin https://localhost:9445/restapis

# List proxy services
curl -k -u admin:admin https://localhost:9445/services
```

## Common Mediators

| Mediator | Purpose |
|----------|---------|
| `<log>` | Log messages |
| `<property>` | Set/get properties |
| `<payloadFactory>` | Create/transform payloads |
| `<call>` | Invoke backend services |
| `<send>` | Send messages |
| `<respond>` | Return response |
| `<filter>` | Conditional routing |
| `<switch>` | Content-based routing |
| `<sequence>` | Invoke sequences |
| `<foreach>` | Iterate over collections |

## Verification Checklist

- [ ] Micro Integrator running on port 8290
- [ ] Sample API created and tested
- [ ] Proxy service deployed
- [ ] Message transformation working
- [ ] Health check endpoint responding

## Troubleshooting

### Check MI Logs
```bash
docker logs wso2-mi -f
```

### Check Deployed Artifacts
```bash
# Enter container
docker exec -it wso2-mi bash

# Navigate to deployment folder
cd /home/wso2carbon/wso2mi-4.3.0/repository/deployment/server
```

### Common Errors
1. **Port already in use** - Change port in docker-compose.yml
2. **Artifact not loaded** - Check XML syntax, restart container
3. **Backend unreachable** - Verify endpoint URL, check network

## Next Steps
Combine Lab 1, 2, and 3 to build a complete integration solution:
1. Expose APIs through API Manager
2. Secure with Identity Server
3. Implement logic in Micro Integrator
