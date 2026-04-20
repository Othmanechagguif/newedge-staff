-- ============================================
-- NewEdge — Supabase Schema
-- Run this in Supabase SQL Editor
-- ============================================

-- Monthly reports archive
CREATE TABLE IF NOT EXISTS monthly_reports (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id TEXT NOT NULL,
  month TEXT NOT NULL,
  staff_id INTEGER NOT NULL,
  staff_name TEXT NOT NULL,
  staff_role TEXT,
  total_hours DECIMAL(6,2) DEFAULT 0,
  punctuality_score INTEGER DEFAULT 0,
  late_count INTEGER DEFAULT 0,
  absent_count INTEGER DEFAULT 0,
  avg_evaluation DECIMAL(4,2),
  eval_count INTEGER DEFAULT 0,
  advances_total DECIMAL(10,2) DEFAULT 0,
  leaves_days INTEGER DEFAULT 0,
  exceptional_leave_deduction DECIMAL(10,2) DEFAULT 0,
  gross_salary DECIMAL(10,2) NOT NULL,
  total_deductions DECIMAL(10,2) DEFAULT 0,
  net_salary DECIMAL(10,2) NOT NULL,
  performance_label TEXT,
  ai_comment TEXT,
  ai_recommendation TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Full action log (audit trail)
CREATE TABLE IF NOT EXISTS action_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id TEXT NOT NULL,
  staff_id INTEGER,
  staff_name TEXT,
  action TEXT NOT NULL,
  details TEXT,
  category TEXT,
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Revenue statistics
CREATE TABLE IF NOT EXISTS revenue_stats (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id TEXT NOT NULL,
  date DATE NOT NULL,
  revenue DECIMAL(10,2) DEFAULT 0,
  covers INTEGER DEFAULT 0,
  avg_ticket DECIMAL(8,2) DEFAULT 0,
  food_cost_pct DECIMAL(5,2) DEFAULT 0,
  labor_cost_pct DECIMAL(5,2) DEFAULT 0,
  net_margin_pct DECIMAL(5,2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(restaurant_id, date)
);

-- Invoices archive
CREATE TABLE IF NOT EXISTS invoices_archive (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id TEXT NOT NULL,
  supplier TEXT NOT NULL,
  items TEXT,
  total DECIMAL(10,2) NOT NULL,
  paid BOOLEAN DEFAULT FALSE,
  paid_date DATE,
  due_date DATE,
  anomaly BOOLEAN DEFAULT FALSE,
  anomaly_detail TEXT,
  ai_analysis TEXT,
  invoice_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- WhatsApp message log
CREATE TABLE IF NOT EXISTS whatsapp_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id TEXT NOT NULL,
  recipient_phone TEXT NOT NULL,
  recipient_name TEXT,
  message_type TEXT NOT NULL,
  message_content TEXT,
  status TEXT DEFAULT 'sent',
  sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_monthly_reports_restaurant ON monthly_reports(restaurant_id, month);
CREATE INDEX IF NOT EXISTS idx_action_logs_staff ON action_logs(staff_id, timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_revenue_stats_date ON revenue_stats(restaurant_id, date DESC);
CREATE INDEX IF NOT EXISTS idx_invoices_paid ON invoices_archive(restaurant_id, paid);

-- Row Level Security
ALTER TABLE monthly_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE action_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE revenue_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoices_archive ENABLE ROW LEVEL SECURITY;

-- Policy: only service role can write (backend only)
CREATE POLICY "Service role full access" ON monthly_reports
  FOR ALL USING (true);
CREATE POLICY "Service role full access" ON action_logs
  FOR ALL USING (true);
CREATE POLICY "Service role full access" ON revenue_stats
  FOR ALL USING (true);
CREATE POLICY "Service role full access" ON invoices_archive
  FOR ALL USING (true);

