# Managed Instance Group (MIG) ClickOps Runbook

## Goal

Create a fully configured **Managed Instance Group (MIG)** via the GCP Console (ClickOps) that automatically scales, heals, and distributes instances across multiple zones.

## Prerequisites

*   GCP project with billing enabled.
*   Appropriate IAM roles: `Compute Admin` or equivalent.
*   Predefined **Instance Template** (OS, machine type, startup script, disks, network, etc.).
*   Network and subnetwork configured for the desired zones.
*   Familiarity with the GCP Console UI.

## Steps

### 1\. Create the Managed Instance Group

1.  Navigate to **Compute Engine → Instance groups → Create instance group**.
2.  Select **Managed instance group**.
3.  Choose your **Instance Template**.
4.  Select **Multiple zones** and pick the zones or region for your group.
5.  Set the **Target size** (initial number of instances).

### 2\. Enable Autoscaling

1.  Scroll to **Autoscaling** and enable it.
2.  Set the **min/max number of instances**.
3.  Choose a scaling metric, e.g., `CPU utilization` or `load balancing capacity`.
4.  Confirm and save.

### 3\. Enable Autohealing

1.  Scroll to **Autohealing** in the MIG creation page.
2.  Specify a **health check** (must exist beforehand).
3.  Set a **initial delay** (time before health checks start on new instances).

### 4\. Verify Multi-Zone Distribution

*   Check that the **instance distribution** shows instances across all selected zones.
*   The **“Regional” MIG** option automatically balances instances across zones.
*   Verify that scaling events maintain distribution by observing instances in each zone after a scale-up/scale-down.

### 5\. Critical Additional Configurations

*   **Rolling updates:** configure if instances will be updated without downtime.
*   **Target pools or backend services:** attach the MIG to a load balancer for traffic routing.
*   **Health check:** must be reliable; otherwise, autohealing may incorrectly replace instances.
*   **Instance Template updates:** MIGs use templates; updates require a **rolling update** strategy.
