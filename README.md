# Crisis Response Chatbot - AI-Powered Emergency Assessment System

A professional emergency response chatbot built with Rasa NLU, Python custom actions, and Streamlit UI - deployed on HuggingFace Spaces.

**🔗 Live Demo**: [https://huggingface.co/spaces/ddeepak752/crisis_chatbot](https://huggingface.co/spaces/ddeepak752/crisis_chatbot)

**🎨 System Design**: [View Pipeline Flow Charts](https://www.figma.com/design/0du3hBR8zhH6titGlkSefa/Crisis-Response-Chatbot----Desh-Deepak-?node-id=0-1&t=OcXx79Spxy3KWKQv-1)

---

## 🚨 System Overview

This chatbot provides professional emergency assessment following 911-style dispatch protocols:

1. **Crisis Type Detection** → Earthquake, Flood, Fire, Power Outage
2. **Location Collection** → Geocoding via OpenStreetMap Nominatim
3. **People & Vulnerability Assessment** → Count, age groups, medical needs
4. **Immediate Danger Triage** → Binary safety evaluation
5. **Risk Scoring Engine** → Quantified 0-100 risk calculation
6. **Crisis-Specific Guidance** → Tailored safety protocols
7. **Human Handoff** → Emergency service escalation

---

## 🎯 Key Features

### Professional Emergency Protocols
- **911-Style Assessment Flow**: Crisis type → Location → People → Danger → Risk
- **Vulnerability-Weighted Prioritization**: Children, elderly, disabled, pregnant receive higher priority
- **Multi-Turn Adaptive Questioning**: Conversation complexity adjusts to user stress levels

### Technical Capabilities
- **Risk Scoring Algorithm**: Combines crisis severity + people count + vulnerabilities + mobility + injuries
- **Location Verification**: Nominatim geocoding with shelter suggestions
- **Fallback Intelligence**: Stress-aware conversation recovery
- **Form-Based Data Collection**: Rasa forms ensure complete information gathering

### Safety Features
- **Critical Risk Auto-Escalation**: High-risk situations trigger immediate emergency dispatch
- **Context Preservation**: All user data maintained throughout conversation
- **Emergency Override**: Immediate human handoff available at any point

---

## 📊 Supported Crisis Types

### 🏠 Earthquake Emergency
- Active shaking detection
- Post-earthquake safety assessment
- Aftershock preparation
- Building damage evaluation

### 🌊 Flood Emergency
- Water level assessment
- Evacuation route planning
- Rising water danger protocols
- Shelter location guidance

### 🔥 Fire Emergency
- Smoke/flame detection
- Evacuation route assessment
- Air quality monitoring
- Fire spread evaluation

### ⚡ Power Outage Emergency
- Medical equipment dependency check
- Temperature regulation concerns
- Food safety guidance
- Generator safety protocols

---

## 🏗️ System Architecture

**Technology Stack:**
- **NLU Engine**: Rasa Open Source 3.1
- **Dialogue Management**: Rasa Core with forms and rules
- **Custom Actions**: Python 3.10 with Nominatim geocoding
- **Frontend**: Streamlit with crisis-optimized UI
- **Deployment**: HuggingFace Spaces (Docker container)

**Service Communication:**
```
User → Streamlit UI (Port 7860)
         ↓
    Rasa Server (Port 5005)
         ↓
    Action Server (Port 5055)
         ↓
    Nominatim API (Geocoding)
```

---

## 📁 Project Structure

```
crisis-chatbot/
├── app.py                          # Streamlit frontend
├── start.sh                        # Service orchestration script
├── Dockerfile                      # Container configuration
├── requirements.txt                # Python dependencies
├── README.md                       # This file
└── rasa_project/                   # Rasa chatbot core
    ├── domain.yml                  # Intents, slots, responses, actions
    ├── config.yml                  # NLU pipeline configuration
    ├── endpoints.yml               # Action server connection
    ├── credentials.yml             # Channel credentials
    ├── data/
    │   ├── nlu.yml                # 300+ training examples
    │   ├── stories.yml            # Conversation flows
    │   └── rules.yml              # Deterministic behavior
    ├── actions/
    │   └── actions.py             # Custom Python actions
    └── models/                     # Trained models (generated)
```

---

## 🔧 How It Works

### 1. Crisis Detection
User input → Rasa NLU → Intent classification (report_earthquake, report_flood, etc.)

### 2. Form Activation
Intent detected → `crisis_form` activated → Collects 5 required slots:
- Location (with geocoding verification)
- People count
- Vulnerability status
- Mobility status  
- Injury status

### 3. Risk Calculation
Form complete → `action_calculate_risk_level` executes:
```python
risk_score = crisis_base_score 
           + people_multiplier 
           + vulnerability_score 
           + mobility_penalty 
           + injury_penalty
           
risk_level = CRITICAL (76-100) | HIGH (51-75) | MEDIUM (26-50) | LOW (0-25)
```

### 4. Response Delivery
Risk level determined → `action_finish_and_guide` provides:
- Crisis-specific safety protocols
- Shelter suggestions (if location verified)
- Emergency contact information
- Next action options

---

## 🎨 UI Design Principles

### Crisis-Optimized Interface
- **High-Contrast Colors**: Emergency red, safe green, info blue
- **Large Touch Targets**: Designed for stressed users
- **Minimal Cognitive Load**: Simple choices, clear instructions
- **Always-Visible Emergency Button**: Immediate 112/911 access

### Adaptive Complexity
- **Quick Reply Buttons**: Context-aware suggestions
- **Progress Indicators**: Show conversation stage
- **Risk Assessment Panel**: Real-time priority display
- **Emergency Contacts**: Persistent 112/911 visibility

---

## 📈 Risk Assessment Matrix

| Factor | Score Impact | Examples |
|--------|--------------|----------|
| **Crisis Type** | 15-30 points | Earthquake: 30, Flood: 25, Fire: 30, Power: 15 |
| **People Count** | 0-20 points | 1 person: 0, 2-3: 5-10, 4-5: 15, 6+: 20 |
| **Vulnerabilities** | 0-60 points | Each child/elderly/pregnant/medical: +15 |
| **Mobility** | 0-20 points | Cannot move: +20, Unsure: +10, Can move: 0 |
| **Injuries** | 0-25 points | Injured: +25, Unsure: +10, None: 0 |

**Total Risk Score**: 0-100 (capped)

**Priority Levels**:
- 🔴 **CRITICAL** (76-100): Immediate emergency dispatch
- 🟠 **HIGH** (51-75): Priority guidance + operator standby
- 🟡 **MEDIUM** (26-50): Detailed self-help guidance
- 🟢 **LOW** (0-25): Information delivery + monitoring

---

## 🔐 Data & Privacy

- **No Data Persistence**: Conversations are session-based, no storage
- **Location Privacy**: Geocoding via OpenStreetMap (no API keys)
- **Session Isolation**: Each user has independent conversation state
- **No Personal Identifiers**: No names, emails, or contact info collected

---

## 🚀 Local Development

### Prerequisites
- Python 3.10+
- Rasa Open Source 3.1+

### Installation
```bash
# Clone repository
git clone https://github.com/yourusername/crisis-chatbot.git
cd crisis-chatbot

# Install dependencies
pip install -r requirements.txt
pip install -r rasa_project/actions/requirements.txt

# Train Rasa model
cd rasa_project
rasa train

# Start Action Server (Terminal 1)
rasa run actions --port 5055

# Start Rasa Server (Terminal 2)
rasa run --enable-api --cors "*" --port 5005

# Start Streamlit (Terminal 3)
cd ..
streamlit run app.py --server.port 8501
```

### Access Locally
- **Chatbot UI**: http://localhost:8501
- **Rasa API**: http://localhost:5005

---

## 📚 Academic Context

**Course**: MSc Artificial Intelligence - Advanced Conversational UI Design and Chatbot Development  
**Institution**: Berlin School of Business & Innovation (BSBI)  
**Assignment**: Crisis Response Chatbot for Emergency Information Management  
**Grade Weight**: 100%

### Learning Objectives Demonstrated
✅ Innovative conversational UI design with crisis-adapted patterns  
✅ Research-backed emergency communication protocols  
✅ Professional NLU integration with Rasa  
✅ Custom action development with risk assessment algorithms  
✅ Deployment and production readiness on cloud platform  

---

## 🆘 Emergency Disclaimer

**⚠️ CRITICAL: This is an educational training system**

**For REAL emergencies, immediately call:**
- 🇪🇺 **Europe**: **112**
- 🇺🇸 **US/Canada**: **911**
- 🇬🇧 **UK**: **999**
- 🇦🇺 **Australia**: **000**

This chatbot provides **guidance only** - it does NOT replace professional emergency services.

---

## 🚢 Deployment Journey

### Docker Containerization
Successfully created Docker containers with multi-service orchestration:
- **Dockerfile.rasa**: Rasa server container
- **Dockerfile.actions**: Custom actions server container  
- **Dockerfile.streamlit**: Frontend UI container
- **docker-compose.yml**: Service orchestration

**Status**: ✅ Fully functional locally with Docker Compose  
**HuggingFace Decision**: Not deployed due to file structure conflicts between Docker multi-container setup and HuggingFace Spaces single-container architecture. HuggingFace Spaces required consolidated deployment script (`start.sh`) instead of Docker Compose orchestration.

### AWS EC2 Deployment Attempt
Attempted deployment on AWS EC2 instance:
- **Instance Type**: t2.micro (Free Tier)
- **RAM**: 1GB
- **Issue**: Insufficient memory for Rasa model training and concurrent service execution

**Constraint**: Rasa training requires ~2GB RAM minimum. Action server + Rasa server + Streamlit needed ~3GB combined. Free tier t2.micro with 1GB RAM caused out-of-memory errors during model training.

**Resolution**: Migrated to HuggingFace Spaces which provides adequate compute resources for all services in single container.

### Final Deployment: HuggingFace Spaces
- **Platform**: HuggingFace Spaces (Docker-based)
- **Container**: Single unified container with service orchestration via `start.sh`
- **Resources**: Sufficient RAM for training + runtime (4GB+ available)
- **Advantages**:
  - Zero infrastructure management
  - Automatic HTTPS and domain
  - Built-in CI/CD pipeline
  - Free hosting for public spaces
  - Community visibility

---

## 📄 License

Educational project - MSc AI coursework

---

## 👨‍💻 Author

**Desh Deepak**  
MSc Artificial Intelligence Student  
Berlin School of Business & Innovation

**Project Links:**
- 🌐 **Live Demo**: [HuggingFace Spaces](https://huggingface.co/spaces/ddeepak752/crisis_chatbot)
- 🎨 **System Design**: [Figma Flow Charts](https://www.figma.com/design/0du3hBR8zhH6titGlkSefa/Crisis-Response-Chatbot----Desh-Deepak-?node-id=0-1&t=OcXx79Spxy3KWKQv-1)
- 💻 **Source Code**: [GitHub Repository](#)

---

## 🙏 Acknowledgments

- **Rasa Open Source**: NLU and dialogue management framework
- **OpenStreetMap Nominatim**: Geocoding and location verification
- **Streamlit**: Rapid UI development framework
- **HuggingFace Spaces**: Cloud deployment platform
- **BSBI Faculty**: Course guidance and feedback

---
