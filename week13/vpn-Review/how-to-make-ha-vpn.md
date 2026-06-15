Here is your step-by-step guide to recreating this exact high-availability (HA) VPN setup using the **Google Cloud Console**.

---

## Step 1: Create the VPC Networks and Subnets

First, we need to set up the two isolated network environments.

1. In the GCP Console, go to **VPC network** > **VPC networks**.
2. Click **Create VPC Network**.
3. **Configure VPC 1:**
* **Name:** `screenshot2-vpc1`
* **Subnet creation mode:** Select **Custom**.
* Under **New subnet**:
* **Name:** `subnet-vpc1`
* **Region:** `us-central1`
* **IPv4 range:** `10.1.0.0/24`


* Click **Create**.


4. Click **Create VPC Network** again.
5. **Configure VPC 2:**
* **Name:** `screenshot2-vpc2`
* **Subnet creation mode:** Select **Custom**.
* Under **New subnet**:
* **Name:** `subnet-vpc2`
* **Region:** `us-central1`
* **IPv4 range:** `10.2.0.0/24`


* Click **Create**.



---

## Step 2: Configure Firewall Rules

Next, we'll allow cross-VPC communication. GCP blocks this traffic by default.

1. Go to **VPC network** > **Firewall**.
2. Click **Create Firewall Rule**.
3. **Configure Rule for VPC 1:**
* **Name:** `allow-vpn-from-vpc2`
* **Network:** Select `screenshot2-vpc1`.
* **Direction of traffic:** Ingress
* **Action on match:** Allow
* **Targets:** All instances in the network
* **Source filter:** IPv4 ranges
* **Source IPv4 ranges:** `10.2.0.0/24` (VPC 2's subnet)
* **Protocols and ports:** Check **Specified protocols and ports**, then check **TCP**, **UDP**, and **Other** (type `icmp`).
* Click **Create**.


4. Click **Create Firewall Rule** again.
5. **Configure Rule for VPC 2:**
* **Name:** `allow-vpn-from-vpc1`
* **Network:** Select `screenshot2-vpc2`.
* **Direction of traffic:** Ingress
* **Action on match:** Allow
* **Targets:** All instances in the network
* **Source filter:** IPv4 ranges
* **Source IPv4 ranges:** `10.1.0.0/24` (VPC 1's subnet)
* **Protocols and ports:** Check **Specified protocols and ports**, then check **TCP**, **UDP**, and **Other** (type `icmp`).
* Click **Create**.



---

## Step 3: Set Up Cloud Routers

Cloud Routers handle the dynamic routing (BGP) between your networks.

1. Go to **Network Connectivity** > **Cloud Routers**.
2. Click **Create Router**.
3. **Configure Router for VPC 1:**
* **Name:** `router-vpc1`
* **Network:** `screenshot2-vpc1`
* **Region:** `us-central1`
* **Google ASN:** `65001`
* **BGP route advertisement:** Select **Create custom routes**.
* Check **Advertise subnets visible to the Cloud Router**.
* Under **Custom routes**, click **Add a route**:
* **Source:** Custom IP range
* **IP address range:** `10.1.0.0/24`


* Click **Create**.


4. Click **Create Router** again.
5. **Configure Router for VPC 2:**
* **Name:** `router-vpc2`
* **Network:** `screenshot2-vpc2`
* **Region:** `us-central1`
* **Google ASN:** `65002`
* **BGP route advertisement:** Select **Create custom routes**.
* Check **Advertise subnets visible to the Cloud Router**.
* Under **Custom routes**, click **Add a route**:
* **Source:** Custom IP range
* **IP address range:** `10.2.0.0/24`


* Click **Create**.



---

## Step 4: Create HA VPN Gateways and Tunnels

Because you are connecting two VPCs inside GCP, you can set both gateways up simultaneously using Cloud Console's dedicated topology wizard.

1. Go to **Network Connectivity** > **VPN**.
2. Click **Create VPN Gateway** (or **VPN connection**).
3. Select **High-availability (HA) VPN** and click **Continue**.
4. **Configure VPN Gateway 1 (VPC1 Side):**
* **VPN gateway name:** `ha-vpn-gateway-vpc1`
* **VPC network:** `screenshot2-vpc1`
* **Region:** `us-central1`


5. Under **Peer VPN gateway**, select **Google Cloud VPC**.
6. **Configure VPN Gateway 2 (VPC2 Side / Peer):**
* **VPC network:** `screenshot2-vpc2`
* **Create a new HA VPN gateway** named: `ha-vpn-gateway-vpc2`


7. Click **Create & Continue**. GCP will generate the public IP addresses for both gateways.

### Configure the VPN Tunnels

On the next screen, you will define the 4 cross-connected tunnels (2 from VPC1 to VPC2, and 2 from VPC2 to VPC1).

1. Under **Cloud Router**, select `router-vpc1` for the VPC1 side, and `router-vpc2` for the VPC2 side.
2. **Configure Tunnel 0 (VPC1 interface 0 to VPC2 interface 0):**
* Name: `tunnel-vpc1-to-vpc2-0`
* Associated Cloud Router interface: Interface 0
* IKE pre-shared key (Shared secret): `super-secret-shared-key-1`


3. **Configure Tunnel 1 (VPC1 interface 1 to VPC2 interface 1):**
* Name: `tunnel-vpc1-to-vpc2-1`
* Associated Cloud Router interface: Interface 1
* IKE pre-shared key (Shared secret): `super-secret-shared-key-2`


4. Set up the corresponding reverse tunnels (`tunnel-vpc2-to-vpc1-0` and `tunnel-vpn-to-vpc1-1`) ensuring **shared secret 1** matches tunnel 0, and **shared secret 2** matches tunnel 1.
5. Click **Create & Continue**.

---

## Step 5: Configure BGP Sessions

Once the tunnels are provisioned, the Console will prompt you to configure the BGP sessions to exchange routing information.

### For Tunnel 0 (The Interface 0 Connection)

1. Click **Configure BGP Session** for the first tunnel pair.
2. **On Router 1 (`router-vpc1`):**
* **Name:** `router-vpc1-peer0`
* **Peer ASN:** `65002`
* **Cloud Router BGP IPv4 address:** `169.254.1.1`
* **Peer BGP IPv4 address:** `169.254.1.2`



3. **On Router 2 (`router-vpc2`):**
* **Name:** `router-vpc2-peer0`
* **Peer ASN:** `65001`
* **Cloud Router BGP IPv4 address:** `169.254.1.2`
* **Peer BGP IPv4 address:** `169.254.1.1`


4. Click **Save and continue**.

### For Tunnel 1 (The Interface 1 Connection)

1. Click **Configure BGP Session** for the second tunnel pair.
2. **On Router 1 (`router-vpc1`):**
* **Name:** `router-vpc1-peer1`
* **Peer ASN:** `65002`
* **Cloud Router BGP IPv4 address:** `169.254.2.1`
* **Peer BGP IPv4 address:** `169.254.2.2`


3. **On Router 2 (`router-vpc2`):**
* **Name:** `router-vpc2-peer1`
* **Peer ASN:** `65001`
* **Cloud Router BGP IPv4 address:** `169.254.2.2`
* **Peer BGP IPv4 address:** `169.254.2.1`


4. Click **Save and continue**, then click **Save BGP configuration**.

---

## Verification

Give the setup 1 to 2 minutes to establish connectivity. Go back to the **VPN** dashboard page. You should see a green checkmark next to the status fields:

* **VPN Tunnel Status:** `Established`
* **BGP Session Status:** `BGP Status Up`
