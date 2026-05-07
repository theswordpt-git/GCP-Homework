## High Availability vs. Fault Tolerance

*   **High Availability (HA)**
    *   System remains operational with minimal downtime (seconds to minutes)
    *   Uses redundancy and failover
    *   More cost-effective and widely used
*   **Fault Tolerance (FT)**
    *   System continues operating with zero downtime despite failures
    *   Requires full redundancy and instant failover
    *   More complex and expensive
*   **Which to strive for?**
    *   Most systems: High Availability (e.g. social media)
    *   Mission-critical systems: Fault Tolerance (e.g. Banks)

Sources: 
[High Availability vs. Fault Tolerance - Baeldung](https://medium.com/@harshithgowdakt/high-availability-vs-fault-tolerance-the-crucial-distinction-in-distributed-systems-ac4947537cd2)


## Autoscaling vs. Elasticity

*   **Elasticity**
    *   Ability to dynamically grow/shrink resources based on demand
*   **Autoscaling**
    *   Automatically adjusts resources (typically instance count)
*   **Vertical Scaling (Scale Up/Down)**
    *   Increase/decrease CPU or RAM of a single instance
    *   Simple but hardware-limited
    *   May require downtime
*   **Horizontal Scaling (Scale Out/In)**
    *   Add/remove instances
    *   Supports high availability and large scale
    *   Requires load balancing
*   **Which is better?**
    *   Horizontal scaling preferred in cloud environments
    *   Vertical scaling is simpler but limited
*   **On-prem feasibility**
    *   Both are possible
    *   Horizontal scaling is more complex but achievable (via VMs)

Sources:  
[Stack Overflow - What is the difference between scalability and elasticity?](https://stackoverflow.com/questions/9587919/what-is-the-difference-between-scalability-and-elasticity)

## Managed vs. Unmanaged Instance Groups (GCP)

*   **Managed Instance Groups (MIGs)**
    *   Automatically create, update, and heal instances
    *   Support autoscaling and rolling updates
    *   Best for uniform, stateless workloads
*   **Unmanaged Instance Groups**
    *   Instances managed manually
    *   No autoscaling or automatic healing
    *   Useful for custom or mixed workloads

Source:  
[Managed & Unmanaged Instance Groups (MIG & UMIG) Explained](https://medium.com/@stephythomaspss/becoming-a-google-cloud-engineer-my-daily-learning-journal-day-4-d4cd49677fb7)

## Health Checks: Application vs. Load Balancer

*   **Application Health Checks (Instance Groups)**
    *   Determine internal health of instances
    *   Can check deep logic (e.g., database connectivity)
*   **Load Balancer Health Checks**
    *   Decide which instances receive traffic
    *   Typically simple (HTTP/TCP endpoint)
*   **Can they be the same?**
    *   Yes, but not always ideal
*   **Are they different APIs?**
    *   Yes
*   **Best practice**
    *   Load balancer checks should be lightweight
    *   Application checks can be more detailed

Source:  
[Google Cloud](https://cloud.google.com/load-balancing/docs/health-checks)
[Google Cloud: Set up an application-based health check and autohealing](https://docs.cloud.google.com/compute/docs/instance-groups/autohealing-instances-in-migs#checking_whether_instances_are_healthy)

## Three-Tier Architecture

*   **Presentation Layer**
    *   User interface (web or mobile)
*   **Application Layer**
    *   Business logic and processing
*   **Data Layer**
    *   Database and storage systems
*   **Benefits**
    *   Separation of concerns
    *   Independent scaling
    *   Easier maintenance

Source:  
[Microsoft Docs](https://learn.microsoft.com/en-us/azure/architecture/guide/design-principles/separation-of-concerns)
[AWS: Building a three-tier architecture on a budget](https://aws.amazon.com/blogs/architecture/building-a-three-tier-architecture-on-a-budget/)
