## socat-forwarder

A lightweight TCP forwarder container built with Alpine Linux and `socat`.  
This image is designed to act as a generic network bridge inside Kubernetes or Docker environments.

The container dynamically forwards traffic based on environment variables.

---

### Features

- Generic TCP forwarder
- Works with MongoDB, PostgreSQL, Kafka, Elasticsearch, Redis, and other TCP services
- Kubernetes-friendly
- Supports multi-architecture images (amd64 / arm64)
- Very small image size
- Drop-in replacement for existing Helm charts using socat forwarders

---

### Image


ewzengineering/socat-forwarder:latest

---

### Environment Variables

The container behavior is configured using the following environment variables:

| Variable | Description | Required |
|----------|-------------|----------|
| SOCAT_FORWARD_IP | Destination host to forward traffic to | Yes |
| SOCAT_FORWARD_PORT | Destination port | Yes |
| SOCAT_LISTEN_PORT | Port that the container listens on | Yes |

---

### How It Works

The container runs the following command internally:

```
socat TCP-LISTEN:${SOCAT_LISTEN_PORT},fork,reuseaddr TCP:${SOCAT_FORWARD_IP}:${SOCAT_FORWARD_PORT}
```

Traffic flow:

Client → Container → Destination Service


---

## Running with Docker

### Example: Forward PostgreSQL

```bash
docker run -d \
  -p 5432:5432 \
  -e SOCAT_FORWARD_IP=10.0.0.5 \
  -e SOCAT_FORWARD_PORT=5432 \
  -e SOCAT_LISTEN_PORT=5432 \
  ewzengineering/socat-forwarder:latest
```

### Example: Forward MongoDB

```bash
docker run -d \
  -p 27017:27017 \
  -e SOCAT_FORWARD_IP=mongo.internal \
  -e SOCAT_FORWARD_PORT=27017 \
  -e SOCAT_LISTEN_PORT=27017 \
  ewzengineering/socat-forwarder:latest
```

### Example: Forward Elasticsearch

```bash
docker run -d \
  -p 9200:9200 \
  -e SOCAT_FORWARD_IP=elasticsearch.internal \
  -e SOCAT_FORWARD_PORT=9200 \
  -e SOCAT_LISTEN_PORT=9200 \
  ewzengineering/socat-forwarder:latest
```

### Kubernetes Example

```yaml
Deployment:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: socat-forwarder
spec:
  replicas: 1
  selector:
    matchLabels:
      app: socat-forwarder
  template:
    metadata:
      labels:
        app: socat-forwarder
    spec:
      containers:
      - name: my-socat
        image: ewzengineering/socat-forwarder:latest
        env:
        - name: SOCAT_FORWARD_IP
          value: "10.0.0.5"
        - name: SOCAT_FORWARD_PORT
          value: "5432"
        - name: SOCAT_LISTEN_PORT
          value: "5432"
        ports:
        - containerPort: 5432

Service:

apiVersion: v1
kind: Service
metadata:
  name: socat-forwarder
spec:
  selector:
    app: socat-forwarder
  ports:
  - port: 5432
    targetPort: 5432
    protocol: TCP
    name: tcp-5432

```


### Supported Use Cases

This image is commonly used for:
- External database bridging
- Hybrid infrastructure networking
- Database migration
- Secure internal network routing
- Kubernetes to external service connectivity

Examples:
- MongoDB forwarder
- Kafka forwarder
- Elasticsearch forwarder
- PostgreSQL forwarder
- MySql forwarder

### Multi-Architecture Support

The image supports:
- linux/amd64
- linux/arm64

It works on:
- Cloud servers
- ARM servers
- Apple Silicon (M1/M2/M3)
- Mixed architecture Kubernetes clusters

### Logs

You can check container logs using:

Docker:
```bash
docker logs <container-id>
```

Kubernetes:
```bash
kubectl logs <pod-name>
```

Example output:
```
Starting socat forwarder
Listen : 5432
Forward: 10.0.0.5:5432
```