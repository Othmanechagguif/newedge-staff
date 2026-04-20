# NewEdge — Architecture Complète

## 🏗️ Stack Technique

```
┌─────────────────────────────────────────────────────────────┐
│                     FRONTEND (3 apps)                        │
│                                                              │
│  newedge-manager    newedge-staff      newedge-qr            │
│  Vercel (private)   Vercel (private)   Firebase Hosting      │
│  app.newedge.ma     staff.newedge.ma   menu.newedge.ma       │
└────────┬───────────────────┬──────────────────┬─────────────┘
         │                   │                  │
         ▼                   ▼                  ▼
┌─────────────────────────────────────────────────────────────┐
│                      BACKEND SERVICES                        │
│                                                              │
│  Firebase Firestore     Supabase PostgreSQL                  │
│  (temps réel)           (rapports & analytics)               │
│                                                              │
│  Firebase Auth          Firebase Storage                     │
│  (login manager)        (photos plats, justificatifs)        │
└────────┬───────────────────────────────────────────────────-┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│                        APIS EXTERNES                         │
│                                                              │
│  Claude API (Anthropic)    WhatsApp Business API             │
│  - Rapport IA mensuel      - Alertes manager                 │
│  - Chat client QR          - Confirmations congés            │
│  - Analyse factures        - Rappels pointage                │
│  - Insights équipe         - Notifications clients           │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Structure des Repos

```
GitHub/
├── newedge-manager/     (PRIVATE)
│   ├── index.html
│   ├── README.md
│   └── .env.example
│
├── newedge-staff/       (PRIVATE)
│   ├── index.html
│   ├── README.md
│   └── .env.example
│
└── newedge-qr/          (PUBLIC)
    ├── index.html
    ├── README.md
    └── .env.example
```

## 🔥 Firebase — Structure Firestore

```
restaurants/
└── {restaurantId}/
    ├── settings/
    │   ├── general        — nom, adresse, WiFi IP
    │   ├── staffPins      — {staffId: "1234"}
    │   └── leaveQuotas    — {staffId: 30}
    │
    ├── staff/
    │   └── {staffId}/
    │       ├── profile    — nom, rôle, salaire, couleur
    │       ├── status     — statut live (in/out/break/leave)
    │       └── ponctualite— onTime, late, absent counters
    │
    ├── shifts/
    │   └── {staffId}/
    │       └── week       — [{day, start, end, rest}]
    │
    ├── clockings/
    │   └── {clockingId}/  — staffId, action, timestamp, late
    │
    ├── requests/
    │   └── {requestId}/   — type(advance/leave), staffId, amount/days, status
    │
    ├── evaluations/
    │   └── {evalId}/      — staffId, date, score, comment
    │
    ├── notifications/
    │   └── {staffId}/
    │       └── {notifId}/ — type, text, read, timestamp
    │
    ├── tasks/
    │   └── {staffId}/
    │       └── {taskId}/  — text, prio, done
    │
    ├── menu/
    │   └── {itemId}/      — name, price, category, available, emoji
    │
    ├── tables/
    │   └── {tableId}/     — num, status, guests, server, alert
    │
    └── invoices/
        └── {invoiceId}/   — supplier, total, paid, date, anomaly
```

## 🗄️ Supabase — Tables PostgreSQL

```sql
-- Rapports mensuels archivés
CREATE TABLE monthly_reports (
  id UUID PRIMARY KEY,
  restaurant_id TEXT,
  month TEXT,
  staff_id INTEGER,
  staff_name TEXT,
  total_hours DECIMAL,
  punctuality_score INTEGER,
  avg_evaluation DECIMAL,
  advances_total DECIMAL,
  leaves_days INTEGER,
  gross_salary DECIMAL,
  deductions DECIMAL,
  net_salary DECIMAL,
  ai_comment TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Log complet des actions (audit trail)
CREATE TABLE action_logs (
  id UUID PRIMARY KEY,
  restaurant_id TEXT,
  staff_id INTEGER,
  action TEXT,
  details TEXT,
  timestamp TIMESTAMP DEFAULT NOW()
);

-- Statistiques CA (pour graphiques avancés)
CREATE TABLE revenue_stats (
  id UUID PRIMARY KEY,
  restaurant_id TEXT,
  date DATE,
  revenue DECIMAL,
  covers INTEGER,
  avg_ticket DECIMAL,
  food_cost_pct DECIMAL
);

-- Factures archivées
CREATE TABLE invoices_archive (
  id UUID PRIMARY KEY,
  restaurant_id TEXT,
  supplier TEXT,
  total DECIMAL,
  paid BOOLEAN,
  paid_date DATE,
  anomaly BOOLEAN,
  ai_analysis TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

## 🔑 Variables d'Environnement

```env
# Firebase
FIREBASE_API_KEY=xxx
FIREBASE_AUTH_DOMAIN=newedge-xxx.firebaseapp.com
FIREBASE_PROJECT_ID=newedge-xxx
FIREBASE_STORAGE_BUCKET=newedge-xxx.appspot.com
FIREBASE_MESSAGING_SENDER_ID=xxx
FIREBASE_APP_ID=xxx

# Supabase
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=xxx
SUPABASE_SERVICE_KEY=xxx

# Claude API
ANTHROPIC_API_KEY=sk-ant-xxx

# WhatsApp Business API
WHATSAPP_TOKEN=xxx
WHATSAPP_PHONE_ID=xxx
WHATSAPP_VERIFY_TOKEN=xxx

# App Config
RESTAURANT_ID=newedge-tanger-01
MANAGER_EMAIL=manager@newedge.ma
```

## 📡 WhatsApp — Messages Automatiques

```
Alertes Manager (via WhatsApp):
  → Employé en retard : "⏰ Youssef — retard 20min (shift 10:00)"
  → SOS reçu : "🆘 URGENT — Sara Idrissi a besoin d'aide"
  → Nouvelle demande : "💰 Karim demande avance 1500 MAD"
  → Absent : "🚨 Omar absent — shift 08:00 non couvert"

Notifications Staff (via WhatsApp):
  → Congé approuvé : "✅ Votre congé du 15-20 juin est approuvé"
  → Avance accordée : "💰 Avance 800 MAD accordée — déduite en fin de mois"
  → Rappel pointage : "⏰ N'oubliez pas de pointer votre arrivée"
```

## 🔄 Flow de Données — Temps Réel

```
Staff pointe → Firebase Firestore → Manager voit en live
Manager approuve → Firebase → Staff reçoit notification
Manager modifie shift → Firebase → Staff voit nouveau planning
Client scanne QR → Firebase (menu live) → Client voit dispo réelle
```

## 💰 Coûts Estimés (par mois)

| Service | Plan | Coût |
|---------|------|------|
| Vercel | Hobby (gratuit) | 0 MAD |
| Firebase | Spark (gratuit) | 0 MAD |
| Supabase | Free tier | 0 MAD |
| Claude API | Pay per use (~$5/mois) | ~50 MAD |
| WhatsApp API | Meta Cloud API | ~100 MAD |
| Domaine .ma | Annuel | ~17 MAD/mois |
| **TOTAL** | | **~167 MAD/mois** |

## 🚀 Roadmap

| Phase | Description | Statut |
|-------|-------------|--------|
| 1 | HTML statique sur Vercel | ✅ Done |
| 2 | Firebase Firestore + Auth | 🔄 Next |
| 3 | Supabase rapports + domaine .ma | ⏳ Soon |
| 4 | WhatsApp API + Claude API | ⏳ Soon |
| 5 | PWA installable iOS/Android | ⏳ Planned |
| 6 | CMI Payment (QR client ordering) | ⏳ Planned |

