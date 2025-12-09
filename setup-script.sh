#!/bin/bash

# this script sets up a local k3d Kubernetes cluster and deploys the application
# exposes the application via an ingress controller on port 9080
# it requires k3d and kubectl to be installed on the host machine

echo "-------- Checking for k3d --------"
if ! k3d version | grep -q "k3d version";
then
    echo "k3d could not be found, please install it first."
    exit
else 
    echo "k3d is installed."
fi

echo "-------- Checking for kubectl --------"

if ! kubectl version --client | grep -q "Client Version";
then
    echo "kubectl could not be found, please install it first."
    exit
else 
    echo "kubectl is installed."
fi

if ! k3d cluster list | grep -q dp-cluster; then
    echo "-------- Creating k3d cluster --------"
    k3d cluster create --config k3d-config.yaml
else
    echo "-------- k3d cluster 'dp-cluster' already exists --------"
fi

if k3d node list | grep -q "exited"; then
    echo "-------- Starting k3d cluster --------"
    k3d cluster start dp-cluster
else
    echo "-------- k3d cluster 'dp-cluster' is already running --------"
fi

sleep 5

echo "------ Configure Kubernetes cluster ------"
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secrets.yaml
kubectl apply -f k8s/postgres.yaml
kubectl apply -f k8s/redis.yaml

echo "--------- Postgres and Redis getting ready ---------"

k3d image import dp-backend:latest -c dp-cluster
k3d image import dp-frontend:latest -c dp-cluster
sleep 2
kubectl apply -f k8s/backend.yaml
sleep 2
kubectl apply -f k8s/frontend.yaml

echo "-------------- Services in DP-NS ------------------"
kubectl get pods -n dp-ns

echo "------------ Setup Ingress controller ----------------"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/baremetal/deploy.yaml
echo "-------------- ingress setup in ingress-nginx ------------------"
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
echo "🩹 Patching ingress-nginx-controller to use hostNetwork..."
kubectl patch deployment ingress-nginx-controller -n ingress-nginx -p '{"spec":{"template":{"spec":{"containers":[{"name":"controller","ports":[{"containerPort":80,"hostPort":80,"name":"http","protocol":"TCP"},{"containerPort":443,"hostPort":443,"name":"https","protocol":"TCP"},{"containerPort":8443,"name":"webhook","protocol":"TCP"}]}]}}}}'
kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx

kubectl apply -f k8s/ingress.yaml

echo "---------- Ingress setup completed ----------"
# set /etc/hosts entry
if ! grep -q "k8sapp.local" /etc/hosts; then
    echo "Adding k8sapp.local to /etc/hosts"
    echo "127.0.0.1 k8sapp.local" | sudo tee -a /etc/hosts
fi

echo "-------------- Final status in DP-NS ------------------"
kubectl get all -n dp-ns

curl -H "Host: k8sapp.local" -I http://localhost:9080/
curl -H "Host: k8sapp.local" http://localhost:9080/api/health