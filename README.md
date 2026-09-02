# WSO2 Learning Lab

## What is WSO2?

WSO2 is an **open-source middleware platform** that provides a complete suite for:
- **API Management** - Design, publish, secure, and manage APIs
- **Identity & Access Management** - Single Sign-On (SSO), OAuth2, OpenID Connect
- **Integration** - Connect systems, services, and applications
- **Enterprise Service Bus (ESB)** - Message routing, transformation, orchestration

## Why WSO2?

### Key Benefits:
1. **100% Open Source** - No vendor lock-in, full transparency
2. **Enterprise Ready** - Used by Fortune 500 companies
3. **Unified Platform** - All middleware needs in one place
4. **Cloud Native** - Docker, Kubernetes ready
5. **API-First** - Built for modern API economy
6. **AI Ready** - Supports MCP (Model Context Protocol), LLM integration

### Core Products:
| Product | Purpose |
|---------|---------|
| **API Manager (APIM)** | Full API lifecycle management |
| **Identity Server (IS)** | IAM, SSO, OAuth2, OpenID Connect |
| **Micro Integrator (MI)** | Lightweight integration runtime |
| **Enterprise Integrator (EI)** | Full-featured ESB with data integration |
---
## Lab Architecture
```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           WSO2 Local Lab Environment                            │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│    ┌─────────────────────────────────────────────────────────────────────┐     │
│    │                        Your Computer (Localhost)                     │     │
│    │  ┌───────────────────────────────────────────────────────────────┐  │     │
│    │  │                    Web Browser                                │  │     │
│    │  │                                                               │  │     │
│    │  │   https://localhost:9443/publisher  ──▶ API Publisher         │  │     │
│    │  │   https://localhost:9443/devportal  ──▶ API Developer Portal  │  │     │
│    │  │   https://localhost:9443/admin      ──▶ API Admin Portal      │  │     │
│    │  │   https://localhost:9444/carbon     ──▶ Identity Server       │  │     │
│    │  │   https://localhost:9445/carbon     ──▶ Micro Integrator      │  │     │
│    │  └───────────────────────────────────────────────────────────────┘  │     │
│    │                              │                                       │     │
│    │                              │ HTTPS (9443, 9444, 9445)             │     │
│    │                              ▼                                       │     │
│    │  ┌───────────────────────────────────────────────────────────────┐  │     │
│    │  │                    Docker Containers                          │  │     │
│    │  │                                                               │  │     │
│    │  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │  │     │
│    │  │  │ API Manager │  │  Identity   │  │   Micro     │          │  │     │
│    │  │  │   (APIM)    │  │   Server    │  │ Integrator  │          │  │     │
│    │  │  │  Port: 9443 │  │  Port: 9444 │  │  Port: 8290 │          │  │     │
│    │  │  │  Port: 8280 │  │             │  │  Port: 9445 │          │  │     │
│    │  │  │  Port: 8243 │  │             │  │             │          │  │     │
│    │  │  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘          │  │     │
│    │  │         │                │                │                  │  │     │
│    │  │         │                │                │                  │  │     │
│    │  │         └────────────────┼────────────────┘                  │  │     │
│    │  │                          │                                   │  │     │
│    │  │                          ▼                                   │  │     │
│    │  │  ┌───────────────────────────────────────────────────────┐  │  │     │
│    │  │  │              MySQL Database (Port: 3306)              │  │  │     │
│    │  │  │                                                       │  │  │     │
│    │  │  │   ┌─────────────┐ ┌─────────────┐ ┌─────────────┐   │  │  │     │
│    │  │  │   │  apim_db    │ │   um_db     │ │   reg_db    │   │  │  │     │
│    │  │  │   │ (API Config)│ │ (User Mgmt) │ │ (Registry)  │   │  │  │     │
│    │  │  │   └─────────────┘ └─────────────┘ └─────────────┘   │  │  │     │
│    │  │  └───────────────────────────────────────────────────────┘  │  │     │
│    │  └───────────────────────────────────────────────────────────────┘  │     │
│    └─────────────────────────────────────────────────────────────────────┘     │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```
---

## Component Connection Flow

### API Request Flow

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                        API Request Flow (Example)                                │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌──────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐  │
│  │          │     │              │     │              │     │              │  │
│  │  Client  │────▶│   API        │────▶│   Identity   │────▶│  Backend     │  │
│  │  (App)   │     │   Gateway    │     │   Server     │     │  Service     │  │
│  │          │     │  (APIM)      │     │  (Auth)      │     │              │  │
│  └──────────┘     └──────────────┘     └──────────────┘     └──────────────┘  │
│       │                  │                    │                    │          │
│       │                  │                    │                    │          │
│       │    1. API Call   │                    │                    │          │
│       │    with Token    │                    │                    │          │
│       │─────────────────▶│                    │                    │          │
│       │                  │                    │                    │          │
│       │                  │  2. Validate Token │                    │          │
│       │                  │───────────────────▶│                    │          │
│       │                  │                    │                    │          │
│       │                  │  3. Token Valid    │                    │          │
│       │                  │◀───────────────────│                    │          │
│       │                  │                    │                    │          │
│       │                  │  4. Forward Request                    │          │
│       │                  │───────────────────────────────────────▶│          │
│       │                  │                    │                    │          │
│       │                  │  5. Response       │                    │          │
│       │                  │◀───────────────────────────────────────│          │
│       │                  │                    │                    │          │
│       │  6. API Response │                    │                    │          │
│       │◀─────────────────│                    │                    │          │
│       │                  │                    │                    │          │
│  └──────────┘     └──────────────┘     └──────────────┘     └──────────────┘  │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### API Manager Portal Flow

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                        WSO2 API Manager Portals                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                         Publisher Portal                                 │   │
│  │  ┌───────────────────────────────────────────────────────────────────┐  │   │
│  │  │  • Design APIs                                                     │  │   │
│  │  │  • Manage APIs                                                     │  │   │
│  │  │  • Write API documentation                                         │  │   │
│  │  │  • Publish APIs                                                    │  │   │
│  │  └───────────────────────────────────────────────────────────────────┘  │   │
│  │                              │                                          │   │
│  │                              │ Publish API                              │   │
│  │                              ▼                                          │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                        Developer Portal                                  │   │
│  │  ┌───────────────────────────────────────────────────────────────────┐  │   │
│  │  │  • Discover APIs                                                   │  │   │
│  │  │  • Subscribe to APIs                                               │  │   │
│  │  │  • Get API keys                                                    │  │   │
│  │  │  • Test APIs                                                       │  │   │
│  │  └───────────────────────────────────────────────────────────────────┘  │   │
│  │                              │                                          │   │
│  │                              │ Use API                                  │   │
│  │                              ▼                                          │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                          Admin Portal                                    │   │
│  │  ┌───────────────────────────────────────────────────────────────────┐  │   │
│  │  │  • Manage Users and Roles                                          │  │   │
│  │  │  • Define Throttling policies                                      │  │   │
│  │  │  • View Analytics                                                  │  │   │
│  │  │  • Configure System                                                │  │   │
│  │  └───────────────────────────────────────────────────────────────────┘  │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```
### API Lifecycle Flow

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                          API Lifecycle in WSO2                                   │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│    ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐    │
│    │         │    │         │    │         │    │         │    │         │    │
│    │ CREATE  │───▶│ PUBLISH │───▶│SUBSCRIBE│───▶│  USE    │───▶│ RETIRE  │    │
│    │         │    │         │    │         │    │         │    │         │    │
│    └────┬────┘    └────┬────┘    └────┬────┘    └────┬────┘    └────┬────┘    │
│         │              │              │              │              │          │
│         │              │              │              │              │          │
│         ▼              ▼              ▼              ▼              ▼          │
│    ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐    │
│    │Publisher│    │Publisher│    │ DevPortal│    │ Gateway │    │Publisher│    │
│    │ Portal  │    │ Portal  │    │         │    │         │    │ Portal  │    │
│    └─────────┘    └─────────┘    └─────────┘    └─────────┘    └─────────┘    │
│                                                                                 │
│    1. API Designer creates API definition                                       │
│    2. Publisher publishes API to make it available                              │
│    3. Developer subscribes to get API keys                                      │
│    4. Application calls API through Gateway                                     │
│    5. Publisher retires API when no longer needed                               │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### Integration Architecture

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                     Micro Integrator Integration Flow                            │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │
│  │                         Micro Integrator                                  │  │
│  │                                                                          │  │
│  │   ┌─────────────────────────────────────────────────────────────────┐   │  │
│  │   │                    Integration Layer                              │   │  │
│  │   │                                                                  │   │  │
│  │   │   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐          │   │  │
│  │   │   │  Proxy      │   │  Message    │   │  Data       │          │   │  │
│  │   │   │  Services   │   │  Transform  │   │  Mapper     │          │   │  │
│  │   │   └─────────────┘   └─────────────┘   └─────────────┘          │   │  │
│  │   │                                                                  │   │  │
│  │   └─────────────────────────────────────────────────────────────────┘   │  │
│  │                                   │                                     │  │
│  │                 ┌─────────────────┼─────────────────┐                   │  │
│  │                 │                 │                 │                   │  │
│  │                 ▼                 ▼                 ▼                   │  │
│  │   ┌───────────────────────────────────────────────────────────────┐    │  │
│  │   │                    Connectors                                  │    │  │
│  │   │                                                                │    │  │
│  │   │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐     │    │  │
│  │   │  │  HTTP  │ │  JMS   │ │  File  │ │  DB    │ │  SOAP  │     │    │  │
│  │   │  └────────┘ └────────┘ └────────┘ └────────┘ └────────┘     │    │  │
│  │   │                                                                │    │  │
│  │   │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐     │    │  │
│  │   │  │  REST  │ │ Email  │ │  FTP   │ │  SAP   │ │ Kafka  │     │    │  │
│  │   │  └────────┘ └────────┘ └────────┘ └────────┘ └────────┘     │    │  │
│  │   │                                                                │    │  │
│  │   └───────────────────────────────────────────────────────────────┘    │  │
│  │                                   │                                     │  │
│  └───────────────────────────────────┼─────────────────────────────────────┘  │
│                                      │                                        │
│              ┌───────────────────────┼───────────────────────┐                │
│              │                       │                       │                │
│              ▼                       ▼                       ▼                │
│    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐         │
│    │   Legacy        │    │   Database      │    │   Cloud         │         │
│    │   Systems       │    │                 │    │   Services      │         │
│    └─────────────────┘    └─────────────────┘    └─────────────────┘         │
│                                                                                │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Quick Start

### Prerequisites:
- Docker Desktop installed
- Docker Compose installed
- 8GB+ RAM available
- Ports 9443, 9444, 8290, 3306 available

### Start the Lab:

**Quick Start (API Manager only):**
```powershell
cd wso2-lab
.\start-quick.ps1
```

**Full Lab (All components):**
```powershell
docker-compose -f docker-compose.yml up -d
```

### Access Consoles:
| Service | URL | Default Credentials |
|---------|-----|---------------------|
| API Manager Publisher | https://localhost:9443/publisher | admin/admin |
| API Manager DevPortal | https://localhost:9443/devportal | admin/admin |
| API Manager Admin | https://localhost:9443/admin | admin/admin |
| Identity Server | https://localhost:9444/carbon | admin/admin |
| Micro Integrator | https://localhost:9445/carbon | admin/admin |

---

## Lab Exercises

### Lab 1: API Manager Basics
- Create and publish a simple API
- Subscribe to an API
- Test API invocation

### Lab 2: Identity Server
- Configure SSO
- Set up OAuth2 application
- Test token-based authentication

### Lab 3: Integration
- Create a simple integration service
- Deploy to Micro Integrator
- Expose as API

### Lab 4: Complete Solution
- Combine all components
- End-to-end integration

---

## Troubleshooting

### Check container status:
```powershell
docker ps
```

### View logs:
```powershell
docker logs wso2-apim-quickstart
```

### Restart services:
```powershell
docker restart wso2-apim-quickstart
```

### Clean up:
```powershell
docker-compose -f docker-compose.quickstart.yml down -v
```

---

## Common Commands

| Command | Purpose |
|---------|---------|
| `docker ps` | List running containers |
| `docker logs <container>` | View container logs |
| `docker restart <container>` | Restart a container |
| `docker-compose up -d` | Start services |
| `docker-compose down` | Stop services |

---

## Notes

1. **Certificate Warning** - Your browser will show a certificate warning. Click "Advanced" → "Proceed to localhost" to continue.
2. **Startup Time** - WSO2 takes 2-3 minutes to fully start. Wait for the container to show "healthy" status.
3. **Default Password** - Change the default `admin/admin` password in production environments.
