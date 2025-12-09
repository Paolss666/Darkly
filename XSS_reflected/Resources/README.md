# XSS Stored
We visit http://localhost:8080/index.php?page=media&src=nsa and we can see that the site will render the image of the nsa logo so we can try to exploit the src and try to see if the site would render anything given to src such as an ```script``` tag with an alert in it to do this we encode in base64 such as:

http://localhost:8080/index.php?page=media&src=data:text/html;base64,PHNjcmlwdD4gIGFsZXJ0KCJoZWxsbyIpIDwvc2NyaXB0Pg==

which translate to : ```<script>  alert("hello") </script>```

and we get the flag.

# PATCH

* sanitize input in query parameters.
