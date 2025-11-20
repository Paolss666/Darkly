# Exploit

A vulnerability exists on the following page:
http://localhost:8080/index.php?page=survey

On this page, users are allowed to assign a grade to each user, with a value expected to be between **1 and 10**.  
However, the grade value can be **manually modified using browser inspection tools**, allowing a user to submit a grade **greater than 10**, bypassing the intended client‑side restriction.

This occurs because the application relies solely on client-side validation and does not enforce limits on the backend.

---

# Patch

To properly fix this issue:

- **Never trust user input.** Client-side values can always be manipulated.
- **Validate the grade on the backend** to ensure it remains within the allowed range:
  - `grade >= 1`
  - `grade <= 10`

Any grade outside this range should be rejected before processing or storing it.  
Server-side validation ensures the rules cannot be bypassed by modifying values in the browser.
