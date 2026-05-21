first turn on the VM

#check to see if external IP access config is even there:
gcloud compute instances describe homework-vm --zone=us-central1-a --format="yaml(networkInterfaces)"

#based heavily on https://oneuptime.com/blog/post/2026-02-17-how-to-configure-a-compute-engine-vm-to-use-a-static-external-ip-address/view

#it's not, so let's reserve an IP address
gcloud compute addresses create homework-ip  --region=us-central1  --network-tier=PREMIUM

#let's see it!
gcloud compute addresses describe homework-ip --region=us-central1 --format="value(address)"

#assign it to the VM
gcloud compute instances add-access-config homework-vm --zone=us-central1-a --access-config-name="External NAT" --address=<IP ADDRESS FROM EARLIER>

#confirm external IP is attached
gcloud compute instances describe homework-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'


---This came from googling error messages; you can enable iap ssh to get in to SSH from inside Google---
 gcloud compute firewall-rules create allow-iap-ssh \
  --network=homework-vpc \
  --direction=INGRESS \
  --action=ALLOW \
  --rules=tcp:22 \
  --source-ranges=35.235.240.0/20 \
  --target-tags=iap-ssh \
  --priority=1000
  
  gcloud compute instances add-tags homework-vm \
  --tags=iap-ssh \
  --zone=us-central1-a

____________________


#also checked firewall rules in the console, the SSH rule had 1.2.3.4/32 as the only allowed IP.
#went the VM setings, enabled http and https rules


#Check Routes
gcloud compute routes list --filter="network:homework-vpc" --format="table(name,destRange,nextHop,priority)"

#it was missing a default external gateway, so let's add it.
gcloud compute routes create default-internet-route --network=homework-vpc --destination-range=0.0.0.0/0 --next-hop-gateway=default-internet-gateway

#check SSH, should say succeeded! now.
nc -vz <IP ADDRESS FROM EARLIER> 22

#http should work now too
nc -vz <IP ADDRESS FROM EARLIER> 80


#curl too.
curl <IP ADDRESS FROM EARLIER>
You fixed the VM! Yay!
