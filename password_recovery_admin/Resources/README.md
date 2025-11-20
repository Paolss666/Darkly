# Exploit

A vulnerability exists on the following page:

http://localhost:8080/index.php?page=recover


When inspecting this page, you can see a **hidden input tag** containing the email address to which the password‑recovery process is sent.  
This hidden value can be **modified directly in the browser**, allowing an attacker to change it to their own email address.  
Once submitted, the system sends the recovery information — including the flag — to the attacker’s chosen email.

This happens because the application trusts the hidden field instead of validating or determining the recovery target on the server side.

---

# Patch

To fix this issue:

- **Sensitive information should never be stored in hidden fields.**  
  Hidden fields are still fully editable by the user.

- **This recovery form appears to be intended only for the admin user.**  
  The admin’s recovery email should **not** be present in the HTML at all.

- **The recovery process should not default to the admin account.**  
  The page should provide a visible and empty input field where the user enters the username or email they want to recover.

- **All validation and target resolution must be done on the backend**, not in the client.

By removing sensitive data from client-side controls and validating everything on the server, this class of vulnerability is fully prevented.

