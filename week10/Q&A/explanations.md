# DNS and SSL/TLS


## Traceroute vs Dig

### Traceroute

*   Shows the path data takes from your computer to a server.
*   Lists all the routers (hops) along the way.
*   Helps spot slow points or network issues.

### Dig

*   Queries DNS to translate a domain name into an IP address.
*   Can give detailed DNS record info (like A, MX, or TXT records).
*   Useful for troubleshooting name resolution problems.

### Summary

*   Traceroute focuses on the **journey** of data; Dig focuses on the **address** data needs.
*   Both are network troubleshooting tools, but they reveal different types of info.


## Common DNS Records

*   **A/AAAA Record:** Maps a domain to an IPv4/IPv6 address. Basically says, “This site lives at this IP.”
*   **MX Record:** Mail Exchange: Directs email to the right mail server for a domain.  Essential for sending/receiving emails properly.
*   **CNAME Record:** Makes one domain an alias of another. Useful for subdomains or pointing multiple names to the same site.
*   **NS Record:** Tells the internet which DNS servers are authoritative for the domain. Critical for knowing where to ask about your domain’s records.


## TLS Handshake Overview

*   **Client Hello:** Browser says, “Hey server, here’s what I support—TLS version, cipher suites, random number, etc.” Basically, “Hi, can we talk securely?”
*   **Server Hello:** Server replies: “Cool, let’s use this TLS version and cipher suite,” plus its digital certificate (proves its identity).
*   **Certificate Verification:** Browser checks the certificate: valid? trusted CA? not expired? If all good, move on; otherwise, warning pops up.
*   **Key Exchange / Pre-Master Secret:** Client and server share info to agree on a _shared secret_ (key) securely.
*   **Session Key Generation:** Both sides use the shared secret to generate session keys for encrypting actual data.
*   **Finished Messages:** Client and server say, “All done! Ready to encrypt data.” From here, all communication is encrypted.

## SSL/TLS Certificates Explained

*   **How does a certificate know what domain it belongs to?** Every certificate has a _Common Name (CN)_ and sometimes _Subject Alternative Names (SANs)_ listing valid domains. Browser checks if the domain you’re visiting matches CN or SAN → yes ✅, no ⚠️ warning.
*   **What is a Certificate Authority (CA)?** Think of it as a _trusted digital notary_ for the web. CA issues certificates after verifying the domain owner. Browsers trust certain CAs by default, so certificates from them are automatically trusted. Basically: “CA says: Yep, this site really owns this domain.”


-------------------------


# Load Balancers

## GCP Application Load Balancer SSL

*   **How do GCP ALBs offload (decrypt) SSL?** The load balancer can handle SSL/TLS _termination_. It decrypts incoming HTTPS traffic at the _frontend_ where the SSL cert is installed. After decryption, traffic can go to the backend as HTTP or re-encrypted HTTPS. Basically: LB says, “I’ll do the decrypting so your backend servers don’t have to.”
*   **Use cases for encryption all the way to the backend?** Known as _end-to-end encryption_. Useful if:
    *   Data is sensitive inside your network.
    *   Compliance/security rules require encrypted traffic everywhere.In GCP, you can use HTTPS/SSL between LB and backend services to keep traffic encrypted. Tradeoff: backend CPUs do extra work to decrypt traffic.
    
    
-------------------------

# Cloud Domain/DNS

## Load Balancers & Cloud DNS Zones

*   **Can multiple domains point to the same load balancer?** Yup! One LB can handle multiple domains. Just set up _host rules or backend services_ for each domain. Common uses:
    
    *   Multiple websites sharing the same infrastructure.
    *   Easier scaling and management.
    
    Think of the LB as a _traffic director_ routing requests from different domains wherever you want.
*   **In Cloud DNS, what are zones?** A _zone_ is like a folder for a domain’s DNS records. It contains all records (A, CNAME, MX, etc.) for that domain. Types:
    *   **Public zones:** visible to the internet.
    *   **Private zones:** only visible inside your VPC/network.Basically: “Zone = domain + its DNS records + scope (public or private).”


