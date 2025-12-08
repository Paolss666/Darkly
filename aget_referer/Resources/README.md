# Exploit
We visit the url "/index.php?page=e43ad1fdc54babe674da7c7b8f0127bde61de3fbe01def7d00f151c2fcca6d1c" (link in bottom of main page). We check the source code of the page and we can see the following comments : 
1. "You must cumming from : "https://www.nsa.gov/" to go to the next step"
2. "Let's use this browser : "ft_bornToSec". It will help you a lot."

We deduce these comments refer to the "user agent" and "referer" send in the http headers.
So we send this http headers:
#  curl 'http://localhost:8080/index.php?page=b7e44c7a40c5f80139f0a50f3650fb2bd8d00b0d24667c4c2ca32c88e13b758f' -H 'User-Agent: ft_bornToSec' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' --compressed -H 'Referer: https://www.nsa.gov/' -H 'Connection: keep-alive' -H 'Cookie: I_am_admin=68934a3e9455fa72420237eb05902327'



# HTTP Headers Explanation: User-Agent and Referer

## Command Analysis
```bash
curl 'http://localhost:8080/index.php?page=b7e44c7a40c5f80139f0a50f3650fb2bd8d00b0d24667c4c2ca32c88e13b758f' \
  -H 'User-Agent: ft_bornToSec' \
  -H 'Referer: https://www.nsa.gov/' \
  -H 'Cookie: I_am_admin=68934a3e9455fa72420237eb05902327'
```

## User-Agent Header

**Header:**
```
User-Agent: ft_bornToSec
```

**What it does:** Identifies the client (browser, bot, application) making the request to the server.

**Normal content:** Information about the browser, operating system, version, etc.
- Normal example: `Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/91.0.4472.124`

**In this case:** `ft_bornToSec` is a custom value, likely required by a CTF (Capture The Flag) challenge or a security check on the server. The server probably verifies that the User-Agent is exactly this value before allowing access to the resource.

## Referer Header

**Header:**
```
Referer: https://www.nsa.gov/
```

**What it does:** Tells the server which page/URL the request came from (the previous page where you clicked the link).

**Normal purposes:**
- Analytics (knowing where users come from)
- Security checks (CSRF protection)
- Session management

**In this case:** The server probably checks that the request "appears" to come from `https://www.nsa.gov/`. This is a security check (although easily bypassable, as you're doing with curl).

---

## Security Note

**Important:** Both of these headers can be easily spoofed by the client, as demonstrated with this curl command. They are not reliable security mechanisms but are often used in CTF challenges or as a first level of "security through obscurity".

In this curl command, you're simulating being a specific client (`ft_bornToSec`) coming from the NSA website to bypass these checks! 🔒

## Additional Headers in the Command

- **Cookie:** `I_am_admin=68934a3e9455fa72420237eb05902327` - Session/authentication cookie claiming admin privileges
- **Accept headers:** Specify what content types the client can handle
- **Connection:** `keep-alive` - Maintains persistent connection for better performance



# Fixing User-Agent and Referer Spoofing Vulnerabilities

## The Problem

The current implementation relies on easily spoofable HTTP headers for security:
- **User-Agent:** Can be set to any value by the client
- **Referer:** Can be forged or omitted entirely
- **Cookie:** Without proper validation, can be manipulated

These are **NOT** reliable security mechanisms and can be bypassed with simple tools like curl.

## How to Fix This Vulnerability

### 1. Never Rely on User-Agent for Security

**BAD (Current vulnerable code):**
```php
if ($_SERVER['HTTP_USER_AGENT'] !== 'ft_bornToSec') {
    die('Access denied');
}
```

**GOOD (Remove this check entirely):**
- User-Agent should only be used for analytics or compatibility detection
- Never use it as an authentication or authorization mechanism

### 2. Never Rely on Referer for Security

**BAD (Current vulnerable code):**
```php
if ($_SERVER['HTTP_REFERER'] !== 'https://www.nsa.gov/') {
    die('Access denied');
}
```

**GOOD (Use proper CSRF protection):**
```php
// Generate CSRF token on form page
session_start();
$_SESSION['csrf_token'] = bin2hex(random_bytes(32));

// In your form
echo '<input type="hidden" name="csrf_token" value="' . $_SESSION['csrf_token'] . '">';

// Validate on submission
if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
    die('CSRF token validation failed');
}
```

**GOOD (Proper session management):**
```php
session_start();

// During login, set session variable
if (validate_credentials($username, $password)) {
    $_SESSION['user_id'] = $user_id;
    $_SESSION['is_admin'] = true;
    session_regenerate_id(true); // Prevent session fixation
}

// Check authentication
if (!isset($_SESSION['is_admin']) || $_SESSION['is_admin'] !== true) {
    die('Access denied');
}
```

### 4. Implement Proper Authorization

```php
// Check if user has permission for this specific resource
function check_permission($user_id, $resource_id) {
    // Query database to verify user has access
    $stmt = $pdo->prepare("SELECT COUNT(*) FROM permissions WHERE user_id = ? AND resource_id = ?");
    $stmt->execute([$user_id, $resource_id]);
    return $stmt->fetchColumn() > 0;
}

if (!check_permission($_SESSION['user_id'], $resource_id)) {
    http_response_code(403);
    die('Forbidden: You do not have permission to access this resource');
}
```

### 5. Use Cryptographically Secure Tokens

```php
// Generate secure tokens
function generate_secure_token() {
    return bin2hex(random_bytes(32)); // 64 character hex string
}

// For API authentication
$api_token = generate_secure_token();
// Store hashed version in database
$hashed_token = password_hash($api_token, PASSWORD_ARGON2ID);
```

### 6. Implement Rate Limiting

```php
// Prevent brute force attacks
function check_rate_limit($identifier) {
    $cache_key = "rate_limit:" . $identifier;
    $attempts = apcu_fetch($cache_key) ?: 0;
    
    if ($attempts > 5) {
        http_response_code(429);
        die('Too many requests. Try again later.');
    }
    
    apcu_store($cache_key, $attempts + 1, 300); // 5 minute window
}

check_rate_limit($_SERVER['REMOTE_ADDR']);
```

## Summary of Fixes

| Vulnerability | Bad Practice | Good Practice |
|---------------|--------------|---------------|
| User-Agent Check | Checking for specific User-Agent | Remove check entirely, never use for security |
| Referer Check | Validating HTTP_REFERER | Use CSRF tokens instead |
| Cookie Authentication | Predictable cookie values | Server-side sessions with secure tokens |
| Authorization | Client-side checks | Server-side role verification |
| Input Validation | Trusting user input | Whitelist validation |
| Transport Security | HTTP | HTTPS with secure cookie flags |
| Brute Force | No protection | Rate limiting |

## Key Principles

1. **Never trust client-side data** - All headers can be spoofed
2. **Use server-side validation** - Check permissions on every request
3. **Implement defense in depth** - Multiple layers of security
4. **Use cryptographically secure tokens** - Random, unpredictable values
5. **Follow principle of least privilege** - Only grant necessary permissions
6. **Always use HTTPS** - Encrypt data in transit
7. **Keep sessions secure** - Proper session management and regeneration