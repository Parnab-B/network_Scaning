output_file="scan_output.txt"

handle_output() {
    echo "Do you want to save or remove the output?"
    read -p "1. Save
2. Remove
====> " choice
    case "$choice" in
        1)
            read -p "Enter a file name to save the output: " filename
            mv "$output_file" "$filename"
            output_file="$filename"  # Update the global variable
            echo "File saved as $filename."
            ;;
        2)
            rm -f "$output_file"
            echo "Output removed successfully."
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}

port_enumeration() {
    while true; do
        echo "Extracting open ports and services from scan output..."
        open_ports_with_services=$(grep "open" "$output_file" | awk -F '[ /]+' '{print $1 "/" $2 " - " $NF}' | sort -u)

        if [ -z "$open_ports_with_services" ]; then
            echo "No open ports found. Exiting."
            return
        fi

        echo "Open Ports and Services:"
        echo "$open_ports_with_services"

        # Prompt user for a port to enumerate
        read -p "Choose a port for enumeration from the list above (enter the port number) or press 'q' to quit: " port

        if [ "$port" = "q" ]; then
            echo "Exiting port enumeration."
            break
        fi

        # Extract service and software details for the selected port
        service=$(grep "$port/tcp" "$output_file" | awk '{print $3}')
        software=$(grep "$port/tcp" "$output_file" | awk '{print $NF}')

        echo "Selected Port: $port"
        echo "Service: ${service:-unknown}"
        echo "Software: ${software:-unknown}"

        # Identify relevant scripts
        service_scripts=$(ls /usr/share/nmap/scripts | grep -i "$service" | wc -l)
        software_scripts=$(ls /usr/share/nmap/scripts | grep -i "$software" | wc -l)
        used_scripts=""
        enum_type=""

        if [ "$service_scripts" -gt "$software_scripts" ]; then
            echo "Performing service-related enumeration."
            enum_type="service-related"
            used_scripts=$(ls /usr/share/nmap/scripts | grep -i "$service" | tr '\n' ',' | sed 's/,$//')
            sudo nmap -sV -p "$port" --script="$used_scripts" "$ip"
        elif [ "$software_scripts" -gt "$service_scripts" ]; then
            echo "Performing software-related enumeration."
            enum_type="software-related"
            used_scripts=$(ls /usr/share/nmap/scripts | grep -i "$software" | tr '\n' ',' | sed 's/,$//')
            sudo nmap -sV -p "$port" --script="$used_scripts" "$ip"
        else
            echo "Performing default enumeration."
            enum_type="default"
            used_scripts="default scripts (-sC -sV)"
            sudo nmap -sC -sV -p "$port" "$ip"
        fi

        # Display the type of enumeration and scripts used
        echo -e "\n=== Enumeration Summary ==="
        echo "Port: $port"
        echo "Service: ${service:-unknown}"
        echo "Software: ${software:-unknown}"
        echo "Enumeration Type: $enum_type"
        echo "Scripts Used: $used_scripts"
        echo "===========================\n"
    done
}

view_output() {
    if [ "$seeout" = "1" ]; then
        cat "$output_file"
    else
        echo "You chose not to view the output."
    fi
}

echo "Hello sir, Welcome to advanced scanning using Nmap"
echo "Installing necessary tools, please wait..."
sudo apt update && sudo apt install -y nmap arp-scan gedit

echo "Scanning the local network for devices (ARP scan)..."
sudo arp-scan -l

echo "Sir, what type of LAN scan you want to do?"
read -p "1. Ping scan
2. No ping scan
====> " scan

case "$scan" in
    1)
        echo "You chose ping scanning."
        nmap -sn 192.168.1.0/24
        ;;
    2)
        echo "You chose no ping scanning."
        nmap -sn 192.168.1.0/24 -Pn
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo "Enter an IP address for advanced scanning:"
read -p "==> " ip

echo "What type of scan do you want to do?"
read -p "1. Ping Scan
2. ARP Scan
3. TCP Scan
4. OS Fingerprinting
5. Full Port Scan
6. Stealth Scan
7. No Ping Scan
====> " type

case "$type" in
    1)
        echo "Ping Scanning: Identifying live hosts in the network."
        echo "please wait it may take few minutes..."
        ping -c 4 "$ip" > "$output_file"
        ;;
    2)
        echo "ARP Scan: Discovering devices on the local network."
        echo "please wait it may take few minutes..."
        arp-scan --localnet > "$output_file"
        ;;
    3)
        echo "TCP Scan: Identifying open ports on devices."
        read -p "Enter a port number: " numport
        echo "please wait it may take few minutes..."
        sudo nmap -sT -p "$numport" -O -sV -T5 "$ip" > "$output_file"
        ;;
    4)
        echo "OS Fingerprinting: Determining the operating system of a device."
        echo "please wait it may take few minutes..."
        nmap -O "$ip" > "$output_file"
        ;;
    5)
        echo "Full Port Scan: Scanning all 65535 ports."
        echo "please wait it may take few minutes..."
        nmap -p- "$ip" -Pn > "$output_file"
        ;;
    6)
        echo "Stealth Scan: Scanning ports without completing the TCP handshake."
        read -p "Enter a port number: " numport
        echo "please wait it may take few minutes..."
        nmap -sS -p "$numport" -v "$ip" > "$output_file"
        ;;
    7)
        echo "No Ping Scan: Scanning without pinging the target."
        read -p "Enter a port number: " numport
        echo "please wait it may take few minutes..."
        nmap -p "$numport" -Pn -v "$ip" > "$output_file"
        ;;
    *)
        echo "Invalid scan type."
        exit 1
        ;;
esac

read -p "Scan completed. Press 1 to view output, 2 to skip: " seeout
view_output
handle_output

read -p "Do you want to enumerate open ports? (y/n): " enumerate_choice
if [ "$enumerate_choice" = "y" ]; then
    port_enumeration
fi

echo "Thank you for using advanced scanning. Goodbye!"  

