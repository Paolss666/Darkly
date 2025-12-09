# Stored Cross-Site Scripting Report  
**Page:** `http://localhost:8080/index.php?page=feedback`  

## Vulnerability
The feedback feature contains a **stored Cross-Site Scripting (XSS)** vulnerability.  
User-submitted feedback is stored in the database and then rendered back into the page without proper HTML escaping.  

Although the backend removes *valid, closed* HTML tags (e.g. `<h1></h1>`), it fails to sanitize **unclosed tags**, allowing them to pass through and break the page's HTML structure.

for example:
``` html
<svg/onload=alert('XSS')>a
```

### PATCH

Better parsing or sanitize of the user input.
Another way is to escape the characters that might be interpreted by the browser as html tags, you can do this by encoding when displaying or when storing the feedback from the user.


