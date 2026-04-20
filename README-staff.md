# NewEdge Staff App

> Secure staff-facing app for clock-in/out, leave requests, salary advances, and personal dashboard — NewEdge Restaurant, Tanger.

## 🔐 Access
- **URL**: `https://newedge-staff.vercel.app`
- **Visibility**: Private — staff only (shared internally)
- **Security**: WiFi verification + 4-digit PIN per employee

## 👥 Demo PINs
| Employee | Role | PIN |
|----------|------|-----|
| Youssef Alami | Serveur | `1111` |
| Fatima Benali | Serveur | `2222` |
| Karim Tazi | Cuisine | `3333` |
| Sara Idrissi | Caisse | `4444` |
| Omar Chraibi | Cuisine | `5555` |

> PINs are configured by the manager in the Manager Dashboard → More → WiFi & PINs

## 📋 Features
- **WiFi Verification** — access restricted to restaurant network (configurable IP)
- **PIN Authentication** — 4-digit personal code per employee, 3 attempts then 30s lockout
- **Clock In/Out** — with live timer, break tracking, and punctuality score
- **Today's Shift** — displays manager-assigned schedule
- **Task Management** — daily tasks assigned by manager, departure locked until complete
- **Salary Advance Requests** — max 50% monthly salary, pending until manager approves
- **Leave Requests** — 4 types: annual (paid), exceptional (deducted), sick, unpaid
- **Personal Account** — gross salary, deductions, net pay, evaluations history
- **Messages** — real-time notifications from manager (warnings, tasks, evaluations)
- **Planning** — personal weekly schedule (manager-defined, private per employee)
- **SOS Button** — instant alert to manager

## 🔒 Security Flow
```
Open App
  → WiFi Check (restaurant IP or demo mode)
    → Select Profile
      → Enter 4-digit PIN
        → Personal Dashboard (isolated per employee)
```

Each employee sees ONLY their own data — planning, messages, salary, requests.

## 🗺️ Deployment

| Phase | Status | Description |
|-------|--------|-------------|
| Phase 1 | ✅ Live | Static HTML on Vercel |
| Phase 2 | 🔄 Next | Firebase Firestore real-time sync |
| Phase 3 | ⏳ Planned | Custom domain `staff.newedge.ma` |
| Phase 4 | ⏳ Planned | PWA installable on iOS home screen |

## 🔥 Firebase Integration (Phase 2)

```javascript
// Real-time clock-in sync example
db.collection('restaurants/newedge/clockings').add({
  staffId: current.id,
  action: 'in',
  timestamp: firebase.firestore.FieldValue.serverTimestamp(),
  late: isLate
});
```

## 🛠️ Stack
- **Frontend**: Vanilla HTML/CSS/JS — single file, zero dependencies
- **Fonts**: DM Sans + DM Serif Display (Google Fonts)
- **Backend**: Firebase (Phase 2)
- **Hosting**: Vercel

## 📁 Related Repos
- [newedge-manager](https://github.com/yourusername/newedge-manager) — Manager dashboard
- [newedge-qr](https://github.com/yourusername/newedge-qr) — Public client QR interface

---
Built by **NewEdge** · Tanger, Morocco · 2025
