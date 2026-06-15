

Note: This all is from official Google Cloud documentation.

[https://github.com/terraform-google-modules/terraform-docs-samples](https://github.com/terraform-google-modules/terraform-docs-samples)

Do not forget about the IAM setting for the initiator, only the site initiating the connection needs the iam policy.

1. Create VPC network and subnets [https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2#create-network-subnet](https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2#create-network-subnet)

2. Create two  HA VPN gateways [https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2#creating-ha-gw-2-gw-and-tunnel](https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2#creating-ha-gw-2-gw-and-tunnel)

3. Specify the peer VPN gateway resource [https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2#specify-peer-vpn-gateway-resource](https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2#specify-peer-vpn-gateway-resource)

4. Create Cloud Routers [https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2#create-cloud-routers](https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2#create-cloud-routers)

5. Create VPN Tunnels [https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2#create-vpn-tunnels](https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2#create-vpn-tunnels)

6. Create BGP sessions

7. Verify the configuration [https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2#verify-the-configuration](https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2#verify-the-configuration)

  - Cloud VPN tunnels page check for VPN tunnel status and BGP session status

8. Create an additional tunnel on a single-tunnel gateway. Use this if you only have 2 tunnel on 1 interface to another H VPN gateway. 

[https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2#create-an-additional-tunnel](https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2#create-an-additional-tunnel)

To configure a second tunnel, follow the steps at Add a tunnel from an HA VPN gateway to another HA VPN gateway. [https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/adding-a-tunnel#add-tunnel-from-ha-vpn-to-ha-vpn](https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/adding-a-tunnel#add-tunnel-from-ha-vpn-to-ha-vpn)

VPC-A <--->VPN Tunnel 0 <---->VPC-B # Created and in-use

VPC-A <--->VPN Tunnel 1 <---->VPC-B # Not Created in single tunnel setup.

For dual tunnel setup tunnel ZERO and tunnel ONE are both established with an either active-active or active-passive routing

9. Complete the configuration

9.1 Configure firewall rules for the VPC networks. [https://docs.cloud.google.com/firewall/docs/using-firewalls](https://docs.cloud.google.com/firewall/docs/using-firewalls)

9.2 Check status of VPN tunnels. [https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/checking-vpn-status](https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/checking-vpn-status)