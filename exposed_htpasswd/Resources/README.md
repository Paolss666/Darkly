# Exploit

First, i used Use Python-based tools -> "disearch" which is a Web Content Scanner, it looks for existing (and/or hidden) Web Objects. I used the following command "python3 dirsearch.py -u http://localhost:8080". With the scan result, we can see two files interesting : robots.txt

In robots.txt, we have the folder .hidden and whatever, we will only use the content inside whatever for this exercise. In this folder, we have the file htpasswd, who contain the string "root:437394baff5aa33daa618be47b75cb49". We decrypt the password who is "qwerty123@" in md5 (md5decrypt.net). But where we are going to use this login ? Well, we found the admin section before and we are going to use it there. After typing the login, we get the flag d19b4823e0d5600ceed56d5e896ef328d7a2b9e7ac7e80f4fcdb9b10bcb3e7ff

# Patch
Be careful with robots.txt content and don't use MD5 ffs 