# WSO2 သင်ကြားရေး Lab

## WSO2 ဆိုတာဘာလဲ။

WSO2 ဆိုတာ **open-source middleware platform** တစ်ခုဖြစ်ပြီး အောက်ပါအရာများအတွက် အသုံးပြုနိုင်ပါတယ် -

- **API Management** - API များကို ဒီဇိုင်းဆွဲ၊ ထုတ်ဝေ၊ လုံခြုံစွာ စီမံခန့်ခွဲခြင်း
- **Identity & Access Management** - Single Sign-On (SSO), OAuth2, OpenID Connect
- **Integration** - စနစ်များ၊ ဝန်ဆောင်မှုများကို ချိတ်ဆက်ခြင်း
- **Enterprise Service Bus (ESB)** - မက်ဆေ့ဂျ် လမ်းကြောင်း၊ ပြောင်းလဲ၊ ပေါင်းစပ်ခြင်း

## WSO2 ကိုဘာလို့သုံးသင့်တာလဲ။

### အကျိုးကျေးဇူးများ -

1. **100% Open Source** - Vendor lock-in မရှိပါ
2. **Enterprise Ready** - Fortune 500 ကုမ္ပဏီများက အသုံးပြုနေပါပြီ
3. **Unified Platform** - Middleware လိုအပ်ချက်အားလုံး တနေရာတည်းမှာ
4. **Cloud Native** - Docker, Kubernetes နှင့် အဆင်ပြေ
5. **API-First** - ခေတ်မီ API economy အတွက် ပြင်ဆင်ထား
6. **AI Ready** - MCP (Model Context Protocol), LLM integration ကို ပံ့ပိုး

### Core Products များ -

| Product | ရည်ရွယ်ချက် |
|---------|-------------|
| **API Manager (APIM)** | API lifecycle အပြည့်အစုံ စီမံခန့်ခွဲခြင်း |
| **Identity Server (IS)** | IAM, SSO, OAuth2, OpenID Connect |
| **Micro Integrator (MI)** | ပေါ့ပါးသော integration runtime |
| **Enterprise Integrator (EI)** | Full-featured ESB |

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

## Component များအကြား Connection Flow

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                        API Request Flow (ဥပမာ)                                  │
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

---

## Quick Start

### လိုအပ်ချက်များ -

- Docker Desktop တပ်ဆင်ထားရမည်
- Docker Compose တပ်ဆင်ထားရမည်
- RAM 8GB+ ရှိရမည်
- Ports 9443, 9444, 8290, 3306 မှာ အခြား program များ မနေရ

### Lab စတင်ခြင်း -

```powershell
# Quick Start (API Manager တစ်ခုတည်း)
cd wso2-lab
.\start-quick.ps1

# သို့မဟုတ် Full Lab
docker-compose -f docker-compose.yml up -d
```

### Access URLs -

| Service | URL | Credentials |
|---------|-----|-------------|
| API Publisher | https://localhost:9443/publisher | admin/admin |
| API DevPortal | https://localhost:9443/devportal | admin/admin |
| API Admin | https://localhost:9443/admin | admin/admin |
| Identity Server | https://localhost:9444/carbon | admin/admin |
| Micro Integrator | https://localhost:9445/carbon | admin/admin |

---

## Lab Exercises

### Lab 1 - API Manager အခြေခံများ
- API အသစ်တစ်ခု ဖန်တီးခြင်း
- API ကို publish လုပ်ခြင်း
- API ကို subscribe လုပ်ခြင်း
- API ကို test လုပ်ခြင်း

### Lab 2 - Identity Server
- SSO စီစဉ်ခြင်း
- OAuth2 application တပ်ဆင်ခြင်း
- Token-based authentication test လုပ်ခြင်း

### Lab 3 - Integration
- Integration service တစ်ခု ဖန်တီးခြင်း
- Micro Integrator မှာ deploy လုပ်ခြင်း
- API အဖြစ် ထုတ်ဖော်ပြခြင်း

### Lab 4 - Complete Solution
- အပိုင်းအစများအားလုံးကို ပေါင်းစပ်ခြင်း
- End-to-end integration solution

---

## Visual Guide - Portal များ

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                        WSO2 API Manager Portals                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                         Publisher Portal                                 │   │
│  │  ┌───────────────────────────────────────────────────────────────────┐  │   │
│  2  │  • API များကို ဒီဇိုင်းဆွဲရန်                                        │  │   │
│  │  │  • API များကို စီမံခန့်ခွဲရန်                                        │  │   │
│  │  │  • API documentation ရေးသားရန်                                   │  │   │
│  │  │  • API ကို publish လုပ်ရန်                                         │  │   │
│  │  └───────────────────────────────────────────────────────────────────┘  │   │
│  │                              │                                          │   │
│  │                              │ Publish API                              │   │
│  │                              ▼                                          │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                        Developer Portal                                  │   │
│  │  ┌───────────────────────────────────────────────────────────────────┐  │   │
│  │  │  • API များကို ရှာဖွေရန်                                           │  │   │
│  │  │  • API များကို subscribe လုပ်ရန်                                   │  │   │
│  │  │  • API keys ရယူရန်                                                │  │   │
│  │  │  • API ကို test လုပ်ရန်                                            │  │   │
│  │  └───────────────────────────────────────────────────────────────────┘  │   │
│  │                              │                                          │   │
│  │                              │ Use API                                  │   │
│  │                              ▼                                          │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                          Admin Portal                                    │   │
│  │  ┌───────────────────────────────────────────────────────────────────┐  │   │
│  │  │  • Users နှင့် Roles စီမံခန့်ခွဲရန်                              │  │   │
│  │  │  • Throttling policies သတ်မှတ်ရန်                               │  │   │
│  │  │  • Analytics ကြည့်ရှုရန်                                          │  │   │
│  │  │  • System configuration လုပ်ရန်                                   │  │   │
│  │  └───────────────────────────────────────────────────────────────────┘  │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Troubleshooting

### Container status စစ်ဆေးခြင်း -

```powershell
docker ps
```

### Logs ကြည့်ခြင်း -

```powershell
docker logs wso2-apim-quickstart
```

### Restart လုပ်ခြင်း -

```powershell
docker restart wso2-apim-quickstart
```

### Clean up လုပ်ခြင်း -

```powershell
docker-compose -f docker-compose.quickstart.yml down -v
```

---

## အသုံးများသော Commands

| Command | ရည်ရွယ်ချက် |
|---------|-------------|
| `docker ps` | Container များ ကြည့်ရန် |
| `docker logs <container>` | Logs ကြည့်ရန် |
| `docker restart <container>` | Restart လုပ်ရန် |
| `docker-compose up -d` | Services စတင်ရန် |
| `docker-compose down` | Services ရပ်ရန် |

---

## အထူးသတိပြုရန်

1. **Certificate Warning** - Browser မှာ certificate warning ပေါ်လာမည်။ "Advanced" → "Proceed to localhost" ကို နှိပ်ပါ။
2. **Startup Time** - WSO2 စတင်ရန် 2-3 မိနစ် ခန့် စောင့်ရန် လိုပါမည်။
3. **Default Password** - `admin/admin` ကို production မှာ ပြောင်းရန် မမေ့ပါနှင့်။
