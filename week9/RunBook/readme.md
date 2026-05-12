# Global External Application Load Balancer Runbook (ClickOps)

## Goal

We want a global external application load balancer that distributes traffic across a Managed Instance Group (MIG). It should include proper health checks, frontend + backend config, and be fully functional for production traffic.

## Prerequisites

*   A **Managed Instance Group (MIG)** already created and running with your app instances.
*   Necessary **firewall rules** allowing health checks and app traffic.
*   **Static external IP** if you want a fixed frontend address.
*   **IAM permissions** to create/load balancers, backend services, URL maps, and health checks.
*   Knowledge of the **app ports/protocols** your backend serves.

## Step-by-Step Setup (ClickOps)

### 1\. Configure a Health Check

*   Go to **Network Services → Health checks → Create health check**.
*   Pick the protocol your app uses (HTTP, HTTPS, TCP).
*   Define the **port** and **path** (if HTTP/HTTPS).
*   Set thresholds for **healthy/unhealthy checks** (defaults usually fine).
*   Save.

### 2\. Create a Backend Service

*   Navigate to **Network Services → Load balancing → Backend services → Create**.
*   Choose **Backend type: Instance group**.
*   Attach your **MIG** as the backend.
*   Set **port and protocol** (same as your app).
*   Assign the **health check** you created in step 1.
*   Optional: configure session affinity, connection draining if needed.
*   Save.

### 3\. Set Up a URL Map (for HTTP/HTTPS)

*   Go to **Load balancing → URL maps → Create URL map**.
*   Set the **default backend** to the backend service from step 2.
*   Optional: define routing rules if multiple paths/apps.
*   Save.

### 4\. Configure Frontend

*   Navigate to **Load balancing → Create load balancer → Start configuration → HTTP(S) Load Balancing**.
*   Select **Global external**.
*   For frontend, choose:
    *   Protocol (HTTP/HTTPS)
    *   IP (static or ephemeral)
    *   Port(s)
*   Attach the **URL map** from step 3.
*   Save.

### 5\. Review and Create

*   Check that backend is wired to the health check and MIG.
*   Make sure frontend points to URL map or backend directly (for simple setups).
*   Review all configs.
*   Click **Create**.

### 6\. Verify

*   Confirm load balancer is **provisioned**.
*   Test access using the frontend IP/DNS.
*   Check that health check shows **healthy instances**.
*   Optionally, scale MIG up/down and see traffic distributing.

This leaves you with a global external LB that automatically distributes requests across your MIG, with health checks ensuring only healthy instances get traffic.
