# AUTH Vulnerability
#COM -->
- need just to block call to endpoint if not auth
 curl 'http://127.0.0.1:8080/index.php?page=survey#' --data 'sujet=2&valeur=42' | grep 'flag is' 
