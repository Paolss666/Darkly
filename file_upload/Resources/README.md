# Vulnerability File Upload Verification

### File Upload Verification

url: `http://localhost:8080/?page=upload#`

The only kind of file that is allowed to be uploaded are the .jpeg
we could try to upload a malicious file like a reverse shell a script.php but it would fail.

But when intercepting  the request with burpsuit, we can see that one difference in the request is the content-type set on the client side of the app
to `image/jpeg` when sending a .jpeg and to `application/x-php` when sending a .php.

so we can upload this .php file and precise manually the content-type to `image/jpeg` and we would get the flag: 
`46910d9ce35b385885a9f7e2b336249d622f29b267a1771fbacf52133beddba8`


cmd: 
``` bash
curl -X POST "http://localhost:8080/?page=upload" \
  -H "Cookie: I_am_admin=68934a3e9455fa72420237eb05902327" \
  -F "MAX_FILE_SIZE=100000" \
  -F "uploaded=@PATH_TO_FILE;filename=FILENAME.php;type=image/jpeg" \
  -F "Upload=Upload" \
| grep flag


 ```
# Flag

* Sanitize ensure the filetype matches the content-type of the request
