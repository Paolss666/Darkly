# INTEGER INPUT VALIDATION
- In the survey page, the inputs provided by the grade section are up to 10, and the form is submitted with a POST request to the server with the grade and the userid as the form body without any authentication.
- It is possible to overflow this value by handcrafting the POST with curl bypassing the frontend restriction.

----- curl -X POST http://localhost:8080/\?page\=survey  -H "Content-Type: application/x-www-form-urlencoded"  -d "sujet=2&valeur=100000000000" | grep flag ----- 
