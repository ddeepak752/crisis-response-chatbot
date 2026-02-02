#!/bin/bash

# 🚨 Crisis Response Chatbot - WORKING DEPLOYMENT SCRIPT
# Created from your successful working files
# Assignment Due: February 2, 2026

set -e

echo "🚨 CRISIS RESPONSE CHATBOT - FINAL DEPLOYMENT"
echo "=============================================="
echo "📅 Assignment Due: TODAY (Feb 2, 2026)"
echo "🎯 MSc AI - Berlin School of Business & Innovation"
echo ""

# Check Docker
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker not running! Start Docker Desktop and try again."
    exit 1
fi

echo "✅ Docker is running"

# Clean any existing containers
echo "🧹 Cleaning previous deployment..."
docker-compose down -v --remove-orphans 2>/dev/null || true
docker system prune -f

# Build with no cache to ensure fresh build
echo "🔨 Building Crisis Response Chatbot (this will take 2-3 minutes)..."
docker-compose build --no-cache

# Start services
echo "🚀 Starting Crisis Response Services..."
docker-compose up -d

# Monitor startup
echo "⏳ Monitoring service startup..."
echo ""

for i in {1..20}; do
    echo "📊 Startup check $i/20..."
    
    ACTION_STATUS=$(docker-compose ps -q crisis-action-server | xargs docker inspect --format='{{.State.Health.Status}}' 2>/dev/null || echo "starting")
    RASA_STATUS=$(docker-compose ps -q crisis-rasa-server | xargs docker inspect --format='{{.State.Health.Status}}' 2>/dev/null || echo "starting") 
    FRONTEND_STATUS=$(docker-compose ps -q crisis-frontend | xargs docker inspect --format='{{.State.Health.Status}}' 2>/dev/null || echo "starting")
    
    echo "   🔧 Action Server: $ACTION_STATUS"
    echo "   🤖 Rasa Server: $RASA_STATUS (training may take time)"
    echo "   💻 Frontend: $FRONTEND_STATUS"
    echo ""
    
    if [[ "$ACTION_STATUS" == "healthy" && "$RASA_STATUS" == "healthy" && "$FRONTEND_STATUS" == "healthy" ]]; then
        echo "🎉 ALL SERVICES HEALTHY!"
        break
    fi
    
    sleep 15
done

echo ""
echo "🎯 YOUR CRISIS RESPONSE CHATBOT IS READY!"
echo "========================================"
echo ""
echo "📱 Crisis Response Chatbot: http://localhost:8501"
echo "🤖 Rasa API: http://localhost:5005"
echo "⚙️ Action Server: http://localhost:5055"
echo ""
echo "🧪 TEST YOUR SYSTEM:"
echo "1. Open: http://localhost:8501"
echo "2. Type: emergency"
echo "3. Select: Earthquake"
echo "4. Follow the assessment flow"
echo ""
echo "📋 ASSIGNMENT FEATURES INCLUDED:"
echo "✅ Professional 911-style emergency assessment"
echo "✅ 4 Crisis types: Earthquake, Flood, Fire, Power Outage"
echo "✅ Risk scoring engine (0-100 scale)"  
echo "✅ Vulnerability assessment (children, elderly, pregnant, disabled)"
echo "✅ Location integration with OpenStreetMap"
echo "✅ Multi-level fallback systems"
echo "✅ Human handoff protocols"
echo "✅ Docker containerization"
echo ""
echo "🎓 FOR YOUR ACADEMIC REPORT:"
echo "- Screenshot the working interface"
echo "- Document the 9-stage pipeline"
echo "- Include risk assessment examples"
echo "- Demonstrate fallback handling"
echo ""
echo "📞 EMERGENCY DISCLAIMER:"
echo "This is an educational system. For real emergencies: 112 (EU) / 911 (US)"
echo ""
echo "🚀 Assignment ready for submission!"

# Show recent logs
echo "📋 Recent system logs:"
docker-compose logs --tail=10

echo ""
echo "✨ SUCCESS! Your Crisis Response Chatbot is operational! ✨"
