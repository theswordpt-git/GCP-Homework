# Load Balancers, Cloud Armor, Cloud CDN Cheat Sheet

## Load Balancers

*   **Fault tolerance & high availability:** Spread traffic across servers, so if one goes down, others take over. Minimizes downtime.
*   **Global LB and latency:** Routes users to the nearest healthy backend for a faster response. Not a magic fix if the origin is slow.
*   **Health checks:** Pings servers to see if they’re alive. Stops sending traffic to unhealthy servers. Mostly always needed. LB ≠ reverse proxy, but reverse proxies can do some LB tasks. [Docs](https://cloud.google.com/load-balancing/docs/health-checks)
*   **Routing rules & URL maps:** Decide traffic paths by path, host, protocol. Example: `/images/* → server group A`, `/api/* → server group B`. [Docs](https://cloud.google.com/load-balancing/docs/url-map)
*   **Anycast IP:** Single IP advertised worldwide. Users hit the closest location which is faster and resilient. [Docs](https://cloud.google.com/load-balancing/docs/anycast)

## Cloud Armor

*   **What it offers:** DDoS protection, WAF, custom rules, IP allow/block lists.
*   **Why it’s used:** Stop attacks like SQL injection, XSS, or massive bot traffic.
*   **OSI layer:** Layer 7 (application). Different from VPC firewalls (Layer 3/4).
*   **Rate-based rules:** Limit requests per user/IP to prevent abuse.
*   **reCAPTCHA:** Challenges suspicious traffic with CAPTCHA to let humans through but block bots. [Docs](https://cloud.google.com/armor)

## Cloud CDN

*   **POPs (Points of Presence):** Worldwide data centers where cached content lives → closer to users → faster.
*   **Files served:** Static content like images, videos, CSS, JS, PDFs. HTML if allowed.
*   **Origin sources:** Cloud Storage, Compute Engine, GKE, Cloud Run. Anything LB can point to.
*   **Protection:** Not a firewall, but reduces backend load → some DDoS mitigation. Doesn’t replace Cloud Armor.
*   **Should every enterprise use it?** Not always. Best for global/static content. Small/local apps might not benefit.
*   **TTL (Time to Live):** How long content stays cached. Short TTL → fresh content but more origin requests. Long TTL → faster, less load, but risk of stale content. [Docs](https://cloud.google.com/cdn/docs)