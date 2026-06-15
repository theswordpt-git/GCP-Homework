Questions from: https://github.com/BalericaAI/SEIR-1/blob/main/weekly_lessons/weekd_VPN/test.md

1) According to RFC 4301, IPSec is to secure IP communications through authentication and encryption.
Please provide a screenshot of where IPSec VPN was configured in your GCP console:
See screenshot-1.jpg

2) According to RFC 7296, IKEv2 is used for modern IKE negotiation.
Please provide a screenshot showing where IKE version was configured in your VPN tunnel:
see screenshot-1.jpg

3) UDP 500 port is primarily used for IKE / ISAKMP negotiations.
Please provide a screenshot of your firewall or VPN tunnel configuration showing UDP 500 usage:
see screenshot-3.jpg


4) According to RFC 3948, UDP port 4500 is commonly used for NAT Traversal (NAT-T).
Please provide a screenshot of your tunnel configuration showing NAT-T related settings or active tunnel status:
see screenshot-4.jpg



5) The primary purpose of a Pre-Shared Key (PSK) in IPSec is to authenticate the communicating parties before they can exchange encrypted data; both parties must possess to establish a secure connection.
Please provide a screenshot showing where the PSK was configured in your VPN tunnel setup:
See screenshot-1.jpg

6) Encapsulating Security Payload (ESP) IPSec component is responsible for encrypting data traffic.
Please provide a screenshot of your tunnel configuration showing ESP or encryption settings:
See screenshot-6.jpg


7) The the purpose of the Cloud Router in GCP is to Exchange BGP routing information.  It automatically updates routes based on network changes, eliminating the need for manual adjustments to static routes.
Please provide a screenshot of your Cloud Router configuration:
See screenshot-7.jpg

8) The Encapsulating Security Payload (ESP) is defined in RFC 4303.
Please provide a screenshot showing IPSec tunnel encryption settings:
See screenshot-1.jpg

9) BGP operates over TCP port 179.
Please provide a screenshot showing your BGP session configuration:
See screenshot-9.jpg

10) The 169.254.x.x addresses used in HA VPN BGP sessions are link-local addresses reserved for internal, on-link communication between BGP peers when no routable IP addresses are available.
Please provide a screenshot showing your BGP peer IP addresses:
See screenshot-4.jpg

11) RFC 4271 defines the Border Gateway Protocol (BGP), which is used for exchanging routing information between autonomous systems on the Internet (usually over TCP port 179).
Please provide a screenshot showing learned or advertised BGP routes:
See screenshot-11.jpg

12) The most common cause of Phase 1 IPSec failures is a mismatch in the pre-shared key (PSK).
Please provide a screenshot showing your VPN tunnel status page:
See screenshot-4.jpg

13) Matching encryption settings is typically configured on both VPN peers.
Please provide a screenshot showing your Phase 1 or tunnel cryptographic configuration:
See screenshot-6.jpg

14) The Cloud VPN Gateway creates the public IP addresses used by the VPN tunnels.
Please provide a screenshot showing the external IPs assigned to your HA VPN Gateway:
See screenshot-4.jpg

15) The "Established" state indicates successful route exchanges in a BGP session, where routers can send and receive routing info.
Please provide a screenshot showing your BGP session state:
See screenhot-4.jpg

16) Encapsulating Security Payload (ESP) is the IPsec protocol that uses IP Protocol 50.
Please provide a screenshot or CLI output showing active IPSec traffic or tunnel details:
see screenshot-4.jpg

17) Companies often set up dual HA VPN tunnels to ensure high availability and redundancy, allowing for seamless failover in case one tunnel fails.
Please provide a screenshot showing both VPN tunnels configured in GCP: 
see screenshot-4.jpg

18) Allow IPSec traffic through NAT devices. NAT Traversal (NAT-T) is primarily used to enable secure connections, such as IPSec traffic, to pass through Network Address Translation devices.
Please provide a screenshot showing tunnel configuration or firewall rules related to NAT-T: 
see screenshot-3.jpg

19) B. A set of agreed IPSec security parameters. An SA establishes shared security attributes between two network entities to support secure communication.
Please provide a screenshot showing your VPN tunnel parameters or IPSec settings:
see screenshot-1.jpg

20) B. IKE Phase 1 → IPSec Phase 2 → BGP is the correct order for establishing IPSec and BGP.
Please provide a screenshot showing both tunnel establishment and BGP peer status in your console:
see screenshot-4.jpg



