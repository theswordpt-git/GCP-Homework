# LIVE Console Runbook — GCP HA VPN Side A ↔ Peer Side B

## Purpose

Console runbook for a two-person GCP-to-GCP HA VPN lab.

Use it like this:

```text
Side A = the person following this runbook directly
Side B / peer = the other person
```

Replace names only if your group uses different labels.

---

# 0. Values

## Side A

```text
Project: bash-gcp
Region: europe-west2
Zone: europe-west2-a
VPC: vpc-bash-lon
Subnet: subnet-a
CIDR: 10.72.10.0/24
VM: vm-bash-a
VM IP: 10.72.10.10
Gateway: ha-vpn-bash-lon
Cloud Router: cr-bash-lon
ASN: 65072
Terraform SA: tf-deployer@bash-gcp.iam.gserviceaccount.com
State bucket: tfstate-bash-gcp-ha-vpn
```

## Peer / Side B

```text
Project: PEER_PROJECT_ID
Region: europe-west2
Zone: europe-west2-b
VPC: vpc-peer-lon
Subnet: subnet-a
CIDR: 10.73.10.0/24
VM: vm-peer-a
VM IP: 10.73.10.10
Gateway: ha-vpn-peer-lon
Cloud Router: cr-peer-lon
ASN: 65073
Peer Terraform SA: PEER_TERRAFORM_SA_EMAIL
```

## Shared tunnel values

```text
Tunnel 0 PSK: REPLACE_ME_side_a_peer_if0_min32chars
Tunnel 1 PSK: REPLACE_ME_side_a_peer_if1_min32chars

Tunnel 0:
  Side A BGP IP: 169.254.72.1
  Peer BGP IP:   169.254.72.2

Tunnel 1:
  Side A BGP IP: 169.254.73.1
  Peer BGP IP:   169.254.73.2
```

---

# 1. Live rule for Console principal fields

In Google Cloud Console IAM boxes, paste **email only**.

Use:

```text
tf-deployer@bash-gcp.iam.gserviceaccount.com
```

Do **not** use:

```text
serviceAccount:tf-deployer@bash-gcp.iam.gserviceaccount.com or peer@gmail.com
```

The `serviceAccount:` prefix is for CLI/IAM policy member strings, not the Console principal text box.

---

# 2. Create custom peer-use role in Side A project

Do this first so the peer can use your HA VPN gateway.

## 2.1 Open correct project

- Project picker: select `bash-gcp`.
- Confirm top bar says `bash-gcp`.

## 2.2 Create role

- Go to **IAM & Admin → Roles**
- Click **Create role**
- Fill:

```text
Title: HA VPN Gateway Peer Use
ID: HaVpnGatewayPeerUse
Stage: GA
Description: Allows peer to get/list/use this project's HA VPN gateway only.
```

## 2.3 Add permissions

- Click **Add permissions**
- Add exactly:

```text
compute.vpnGateways.get
compute.vpnGateways.list
compute.vpnGateways.use
```

- Click **Add**
- Click **Create**

Source: Google HA VPN VPC-to-VPC guide says if the peer gateway is in a project or organization you do not own, request `compute.vpnGateways.use`.  
URL: https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2

---

# 3. Grant custom role to peer

## 3.1 Go to IAM

- Go to **IAM & Admin → IAM**
- Click **Grant access**

## 3.2 Add peer principal

Paste the peer Terraform service account email only:

```text
PEER_TERRAFORM_SA_EMAIL
```

Example format:

```text
tf-peer-terraform@peer-project-id.iam.gserviceaccount.com
```

## 3.3 Assign role

- Role dropdown: search **HA VPN Gateway Peer Use**
- Select **HA VPN Gateway Peer Use**
- Click **Save**

Done when IAM page shows the peer service account with:

```text
HA VPN Gateway Peer Use
```

---

# 4. Peer must do the reverse

The peer must create the same custom role in their project and grant it to Side A.

## Peer creates role

```text
Role ID: HaVpnGatewayPeerUse
Permissions:
  compute.vpnGateways.get
  compute.vpnGateways.list
  compute.vpnGateways.use
```

## Peer grants role to Side A

Principal:

```text
tf-deployer@bash-gcp.iam.gserviceaccount.com
```

Role:

```text
HA VPN Gateway Peer Use
```

Do not continue to tunnel creation until this is done.

---

# 5. Create Side A VPC and subnet

## 5.1 Open VPC page

- Go to **VPC network → VPC networks**
- Click **Create VPC network**

## 5.2 VPC settings

```text
Name: vpc-bash-lon
Subnet creation mode: Custom
Dynamic routing mode: Global
```

## 5.3 Subnet settings

```text
Name: subnet-a
Region: europe-west2
IPv4 range: 10.72.10.0/24
```

## 5.4 Finish

- Click **Create**

Source: Google HA VPN VPC-to-VPC guide requires VPC networks with non-overlapping subnet ranges.  
URL: https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2

---

# 6. Create Side A firewall rules

## 6.1 Allow peer CIDR for ICMP and SSH

- Go to **VPC network → Firewall**
- Click **Create firewall rule**

Fill:

```text
Name: allow-peer-icmp-ssh
Network: vpc-bash-lon
Direction: Ingress
Action: Allow
Targets: Specified target tags
Target tags: vpn-test
Source IPv4 ranges: 10.73.10.0/24
```

Protocols:

```text
icmp
tcp:22
```

- Click **Create**

Source: Google Cloud VPN firewall docs say when the peer is another VPC, configure firewall rules on both sides.  
URL: https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/configuring-firewall-rules

## 6.2 Allow IAP SSH

- Click **Create firewall rule**

Fill:

```text
Name: allow-iap-ssh
Network: vpc-bash-lon
Direction: Ingress
Action: Allow
Targets: Specified target tags
Target tags: vpn-test
Source IPv4 ranges: 35.235.240.0/20
```

Protocols:

```text
tcp:22
```

- Click **Create**

Source: Google IAP TCP forwarding docs use `35.235.240.0/20` for IAP TCP forwarding.  
URL: https://docs.cloud.google.com/iap/docs/using-tcp-forwarding

---

# 7. Create Side A VM endpoint

## 7.1 Open VM page

- Go to **Compute Engine → VM instances**
- Click **Create instance**

## 7.2 Basic VM settings

```text
Name: vm-bash-a
Region: europe-west2
Zone: europe-west2-a
Machine type: e2-micro
```

Boot disk:

```text
Debian 12
```

## 7.3 Networking

Open **Advanced options → Networking**.

Set:

```text
Network: vpc-bash-lon
Subnet: subnet-a
Primary internal IP: Static / Custom
Internal IP: 10.72.10.10
External IPv4 address: None
Network tags: vpn-test
```

## 7.4 Create

- Click **Create**

This VM is only the ping and Connectivity Test endpoint.

---

# 8. Create Side A HA VPN gateway

## 8.1 Open VPN wizard

- Go to **Hybrid Connectivity → VPN**
- Click **Create VPN connection**
- Choose **HA VPN**
- Click **Continue**

## 8.2 Gateway settings

```text
VPN gateway name: ha-vpn-bash-lon
Network: vpc-bash-lon
Region: europe-west2
Stack type: IPv4 only
```

- Click **Create & continue** or continue to tunnel setup.

Source: Google VPC-to-VPC HA VPN guide uses one HA VPN gateway per VPC and one tunnel on each interface.  
URL: https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2

---

# 9. Create/select Side A Cloud Router

In the VPN wizard:

```text
Cloud Router: Create new router
Name: cr-bash-lon
Region: europe-west2
ASN: 65072
```

Save/continue.

---

# 10. Wait for peer before tunnel creation

Do not create tunnels until the peer has created:

```text
Project: PEER_PROJECT_ID
Gateway: ha-vpn-peer-lon
Region: europe-west2
```

Also confirm peer granted Side A gateway-use:

```text
Principal: tf-deployer@bash-gcp.iam.gserviceaccount.com
Role: HA VPN Gateway Peer Use
```

---

# 11. Create Side A tunnels

Peer gateway type:

```text
Google Cloud VPN gateway
```

Peer project:

```text
PEER_PROJECT_ID
```

Peer gateway:

```text
ha-vpn-peer-lon
```

## 11.1 Tunnel 0

```text
Name: bash-to-peer-if0
IKE version: IKEv2
Side A gateway interface: 0
Peer gateway interface: 0
Shared secret: REPLACE_ME_side_a_peer_if0_min32chars
```

## 11.2 Tunnel 1

```text
Name: bash-to-peer-if1
IKE version: IKEv2
Side A gateway interface: 1
Peer gateway interface: 1
Shared secret: REPLACE_ME_side_a_peer_if1_min32chars
```

The PSKs must match the peer side exactly.

Source: Google HA VPN guide says partner tunnel shared secrets must match.  
URL: https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2

---

# 12. Configure Side A BGP

## 12.1 BGP for tunnel 0

```text
BGP session name: bgp-bash-to-peer-if0
Cloud Router BGP IP: 169.254.72.1
Peer BGP IP: 169.254.72.2
Peer ASN: 65073
```

## 12.2 BGP for tunnel 1

```text
BGP session name: bgp-bash-to-peer-if1
Cloud Router BGP IP: 169.254.73.1
Peer BGP IP: 169.254.73.2
Peer ASN: 65073
```

Source: Google HA VPN guide says manual BGP IPv4 addresses must use `/30` ranges from `169.254.0.0/16`.  
URL: https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2

---

# 13. Peer mirror values

Send this to peer:

```text
Project: PEER_PROJECT_ID
Region: europe-west2
Zone: europe-west2-b
VPC: vpc-peer-lon
Subnet: subnet-a
CIDR: 10.73.10.0/24
VM: vm-peer-a
VM IP: 10.73.10.10
Firewall source: 10.72.10.0/24
Gateway: ha-vpn-peer-lon
Router: cr-peer-lon
ASN: 65073
Peer ASN: 65072

Tunnel 0:
  Peer interface: 0
  Side A interface: 0
  Peer BGP IP: 169.254.72.2
  Side A BGP IP: 169.254.72.1
  PSK: REPLACE_ME_side_a_peer_if0_min32chars

Tunnel 1:
  Peer interface: 1
  Side A interface: 1
  Peer BGP IP: 169.254.73.2
  Side A BGP IP: 169.254.73.1
  PSK: REPLACE_ME_side_a_peer_if1_min32chars
```

Peer must also grant Side A their custom role:

```text
Principal: tf-deployer@bash-gcp.iam.gserviceaccount.com
Role: HaVpnGatewayPeerUse
Permissions:
  compute.vpnGateways.get
  compute.vpnGateways.list
  compute.vpnGateways.use
```

---

# 14. Verify VPN

Go to:

```text
Hybrid Connectivity → VPN → Cloud VPN tunnels
```

Expected:

```text
Tunnel 0: Established
Tunnel 1: Established
BGP: Established
```

If not established, check:

```text
PSKs match
interface 0 ↔ 0
interface 1 ↔ 1
BGP IPs reversed correctly
ASNs reversed correctly
firewalls exist
peer granted gateway-use to Side A
wait 2–5 minutes
```

---

# 15. Ping test

Go to **Compute Engine → VM instances**.

On `vm-bash-a`:

- Click **SSH** if IAP works
- Run:

```bash
ping -c 7 10.73.10.10
```

Expected:

```text
7 packets transmitted
7 received
```

---

# 16. Network Intelligence Center test

## 16.1 Create test

- Go to **Network Intelligence Center → Connectivity Tests**
- Click **Create Connectivity Test**

Fill:

```text
Name: bash-to-peer-icmp
Protocol: ICMP
```

Source:

```text
VM instance: vm-bash-a
IP: 10.72.10.10
Project: bash-gcp
Network: vpc-bash-lon
```

Destination:

```text
IP address: 10.73.10.10
```

- Click **Create**
- Click **Run test**

Source: Google Connectivity Tests docs describe Connectivity Tests as diagnostics for analyzing reachability between endpoints.  
URL: https://docs.cloud.google.com/network-intelligence-center/docs/connectivity-tests/how-to/running-connectivity-tests

---

# 17. Minimum live order

```text
1. Create Side A custom role.
2. Grant it to peer Terraform SA.
3. Create VPC/subnet.
4. Create firewall rules.
5. Create VM.
6. Create HA VPN gateway + Cloud Router.
7. Wait for peer gateway + reverse IAM.
8. Create tunnels.
9. Configure BGP.
10. Verify tunnel/BGP.
11. ping -c 7.
12. Connectivity Test.
```
