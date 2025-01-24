# Advanced Scanning Script

This script automates advanced network scanning and enumeration tasks using tools like Nmap and ARP-scan. It is designed to simplify the process of discovering devices, identifying open ports, and performing detailed enumeration of services in a network.

## Features

- **Local Network Device Discovery**: Scan for devices in the local network using ARP-scan.
- **Customizable Scan Types**:
  - Ping Scan
  - ARP Scan
  - TCP Scan
  - OS Fingerprinting
  - Full Port Scan
  - Stealth Scan
  - No Ping Scan
- **Port Enumeration**:
  - Extract and list open ports and associated services.
  - Perform detailed service or software-specific enumeration using Nmap scripts.
- **Output Handling**:
  - Save scan results to a file.
  - View or delete scan outputs directly from the script.
- **User-friendly Interface**:
  - Menu-driven inputs for seamless operation.
  - Enumeration suggestions based on discovered services.
 
## RUN 
it willbe automatic install prerequisites.
For use this tool :
sudo su
git cone https://github.com/Parnab-B/network_Scaning.git
chmod +x adv_scaning.sh
./adv_scaning.sh


Example Workflow
Discover Devices:

Choose the LAN scan type (Ping scan or No Ping scan).
Enter the IP range to scan.
Perform Advanced Scans:

Enter the target IP for detailed scanning.
Choose the desired scan type:
Ping Scan: Verify if the host is alive.
TCP Scan: Detect open TCP ports and running services.
OS Fingerprinting: Identify the target's operating system.
Full Port Scan: Scan all 65535 ports.
Stealth Scan: Perform a stealthy scan to bypass firewalls.
No Ping Scan: Scan a target without sending pings.
Handle Outputs:

Save, view, or delete scan results.
Enumerate open ports and perform service-specific enumeration using Nmap scripts.
