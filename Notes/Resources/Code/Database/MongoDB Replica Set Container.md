---
categories:
  - "[[Resources]]"
title: MongoDB Replica Set Container
created: 2026-02-16
published:
source: https://chatgpt.com/c/68248136-e3f0-8012-ae42-3e920c2e3636
author:
  - "[[ChatGPT]]"
tags:
  - topic/conversations/gpt
  - tech/MongoDB
  - tech/containers
  - topic/code
---
 To initiate a **MongoDB replica set** in a containerized environment (e.g., using Docker), you need to:

---

### ✅ Prerequisites

1. **MongoDB containers are up** with replica set enabled.
2. Each container exposes the default port (27017).
3. The `mongod` instances are started with `--replSet` option.
4. Networking is set up so containers can talk to each other (e.g., they’re on the same Docker network).

---

### 🧱 Example Docker Compose File

```
version: '3.8'

services:
  mongo1:
    image: mongo:6
    container_name: mongo1
    ports:
      - "27017:27017"
    command: mongod --replSet rs0 --bind_ip_all
    networks:
      - mongo-cluster

  mongo2:
    image: mongo:6
    container_name: mongo2
    ports:
      - "27018:27017"
    command: mongod --replSet rs0 --bind_ip_all
    networks:
      - mongo-cluster

  mongo3:
    image: mongo:6
    container_name: mongo3
    ports:
      - "27019:27017"
    command: mongod --replSet rs0 --bind_ip_all
    networks:
      - mongo-cluster

networks:
  mongo-cluster:
```

---

### 🚀 Step-by-Step Initialization

1. **Start the containers:**
```
docker-compose up -d
```
2. **Enter the primary container (`mongo1`):**
```
docker exec -it mongo1 mongosh
```
3. **Initiate the replica set:**
```
rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "mongo1:27017" },
    { _id: 1, host: "mongo2:27017" },
    { _id: 2, host: "mongo3:27017" }
  ]
})
```
4. **Check replica set status:**
```
rs.status()
```

> You should see one `PRIMARY` and two `SECONDARY` nodes.

> [!WARNING] In Azure containers we use only one rs0 and the syntax is:
> ```mongosh
> rs.initiate({
>   _id: "rs0",
>   members: [
>     { _id: 0, host: "localhost" }
>   ]
> }) 
> ```

---

### 📝 Notes

- `--bind_ip_all` allows access from other containers.
- Hostnames like `mongo1`, `mongo2` must match the container names or service names in Docker Compose.
- Ensure there's no firewall or network isolation preventing inter-container communication.

