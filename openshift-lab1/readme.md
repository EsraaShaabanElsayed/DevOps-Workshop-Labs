# OpenShift Users and Groups Management Lab

## Overview

This lab demonstrates how to configure and manage user authentication and authorization in OpenShift using HTPasswd identity provider. You'll learn how to create users, organize them into groups, and assign role-based access control (RBAC) permissions.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Lab Objectives](#lab-objectives)
- [Lab Environment](#lab-environment)
- [Step-by-Step Instructions](#step-by-step-instructions)
  - [1. Project Setup](#1-project-setup)
  - [2. User Creation](#2-user-creation)
  - [3. Configure HTPasswd Identity Provider](#3-configure-htpasswd-identity-provider)
  - [4. User Authentication Testing](#4-user-authentication-testing)
  - [5. Group Management](#5-group-management)
  - [6. Role-Based Access Control](#6-role-based-access-control)
- [Verification](#verification)
- [Key Concepts](#key-concepts)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)
- [Additional Resources](#additional-resources)

## Prerequisites

- Access to an OpenShift cluster (CRC or remote cluster)
- OpenShift CLI (`oc`) installed and configured
- Cluster administrator privileges
- Basic understanding of Kubernetes RBAC concepts

## Lab Objectives

By the end of this lab, you will be able to:

1. Create and manage users using HTPasswd authentication
2. Configure identity providers in OpenShift
3. Create and manage user groups
4. Assign cluster roles and project-level roles to users and groups
5. Test authentication and authorization configurations

## Lab Environment

- **OpenShift Cluster**: https://api.crc.testing:6443
- **Project Name**: users-groups-lab
- **Users Created**: esraa, alaa
- **Group Created**: group-lab

## Step-by-Step Instructions

### 1. Project Setup

Create a new project for this lab:

```bash
oc new-project users-groups-lab
```

**Expected Output:**
![alt text](<Screenshot from 2025-11-10 10-43-44.png>)


### 2. User Creation

Create a password file for HTPasswd authentication:

```bash
# Create an empty users file
touch users.txt

# Add user 'esraa' with password
htpasswd -B users.txt esraa

# Add user 'alaa' with password
htpasswd -B users.txt alaa
```
![alt text](<Screenshot from 2025-11-10 10-45-31.png>)

### 3. Configure HTPasswd Identity Provider

#### 3.1 View Existing Secrets

Check for existing authentication secrets:

```bash
oc get secrets -n openshift-config
```

You should see a secret named `htpass-secret` or similar.
![alt text](<Screenshot from 2025-11-10 10-48-19.png>)

#### 3.2 Create or Update HTPasswd Secret

Upload the users file as a secret:

```bash
oc create secret generic users --from-file=htpasswd=users.txt -n openshift-config
```
![alt text](<Screenshot from 2025-11-10 11-49-26.png>)
#### 3.3 Configure OAuth Resource

1. Navigate to the OpenShift Web Console
2. Go to **Administration** → **Cluster Settings**
3. Select the **Configuration** tab
4. Click on **OAuth**
5. Under **Identity Providers**, click **Add** → **HTPasswd**
6. Configure the following:
   - **Name**: htpasswd
   - **HTPasswd File**: Upload or reference the `users.txt` file
7. Click **Add**

![alt text](<Screenshot from 2025-11-10 10-55-59.png>)
![alt text](<Screenshot from 2025-11-10 10-57-39.png>)
![alt text](<Screenshot from 2025-11-10 10-57-59.png>)
![alt text](<Screenshot from 2025-11-10 10-58-35.png>)
![alt text](<Screenshot from 2025-11-10 10-59-20.png>)

**Note**: The cluster will automatically reconfigure the authentication operator. This process may take a few minutes.

### 4. User Authentication Testing

Test login with the newly created users:

```bash
# Login as user 'alaa'
oc login -u alaa -p alaa
```
![alt text](<Screenshot from 2025-11-10 11-00-33.png>)

### 5. Group Management

#### 5.1 Create a Group

Create a new group named `group-lab`:

```bash
oc adm groups new group-lab
```
![alt text](<Screenshot from 2025-11-10 11-03-05.png>)

#### 5.2 Add Users to Group

Add both users to the group:

```bash
oc adm groups add-users group-lab esraa alaa
```
![alt text](<Screenshot from 2025-11-10 11-04-42.png>)



### 6. Role-Based Access Control

#### 6.1 Grant Edit Role to Group

Assign the `edit` role to the group for the project:

```bash
oc adm policy add-role-to-group edit group-lab -n users-groups-lab
```

![alt text](<Screenshot from 2025-11-10 11-23-31.png>)
**Permissions Granted:**
- Create, read, update, and delete most objects in the project
- Cannot modify project-level permissions
- Cannot delete the project itself

#### 6.2 Grant Cluster Admin Role to Individual User

Assign cluster-admin privileges to user `esraa`:

```bash
oc adm policy add-cluster-role-to-user cluster-admin esraa
```
![alt text](<Screenshot from 2025-11-10 11-27-58.png>)
**Warning**: The cluster-admin role grants full administrative access to the entire cluster. Use with caution.


### Role Types

| Role | Level | Description |
|------|-------|-------------|
| `view` | Project | Read-only access to project resources |
| `edit` | Project | Create, read, update, delete resources (except RBAC) |
| `admin` | Project | Full project administration including RBAC |
| `cluster-admin` | Cluster | Full cluster administration |
| `cluster-reader` | Cluster | Read-only access to cluster resources |



## Lab Summary

In this lab, you successfully:
- ✅ Created an OpenShift project
- ✅ Generated HTPasswd credentials for multiple users
- ✅ Configured HTPasswd as an identity provider
- ✅ Created and managed user groups
- ✅ Assigned project-level and cluster-level roles
- ✅ Tested authentication and authorization
