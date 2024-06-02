# Login to Azure
az login
# Create an Azure resource group
az group create --name AKS-Demo-RG --location centralindia
# Create a two node cluster
 
az aks create --resource-group AKS-Demo-RG --name SQLSVR --node-count 1 --generate-ssh-keys --node-vm-size=Standard_B4ms
 
# Get credentials for the cluster
az aks get-credentials --resource-group AKS-Demo-RG --name SQLSVR
 
# List nodes
kubectl get nodes
 
# Create the load balancing service
kubectl apply -f sqlloadbalancer.yaml --record
 
# Create external storage with PV and PVC
kubectl apply -f sqlstorage.yaml --record
kubectl apply -f pvc.yaml --record
 
 
# Display the persistent volume and claim
kubectl get pv
kubectl get pvc
 
# Optional: In case if you want to explore differennt choices of storage classes you can run this line  otherwise you can ignore it
kubectl get storageclass
 
# Use Kubernetes secrets to store required sa password for SQL Server container. This is a best Practice
# If you want to delete the previously created secret use this one otherwise avoid it and go to next line
kubectl delete secret mssql-secret 
 
# use complex password
kubectl create secret generic mssql-secret --from-literal=SA_PASSWORD="Prasad@123"
 
# Deploy the SQL Server 2019 container
kubectl apply -f sqldeployment.yaml --record
 
# List the running pods and services
kubectl get pods
kubectl get services
 
# TO fetch details about the POD
kubectl describe pod mssql

# Connect to the SQL Server pod with Azure Data Studio
# Retrieve external IP address
ip=$(kubectl get services | grep mssql | cut -c45-60)
echo $ip
  
# Simulate a failure by killing the pod. Delete pod exactkly does it.
kubectl delete pod ${podname}
 
# Wait one second
echo Waiting 3 second to show newly started pod
sleep 3
 
# now retrieve the running POD and you see the that POD name is different because Kubernetes recreated 
#it after we deleted the earlier one
echo Retrieving running pods
kubectl get pods
 
# Get all of the running components
kubectl get all
 
# for Troubelshooting purpose you can use this command to view the events  
 
kubectl describe pod -l app=mssql
 
 
 
# Display the container logs
kubectl logs -l app=aksdemo


# 
docker build -t prasadbhalerao/demo .
docker run -d -p 3000:3000 --name node-app prasadbhalerao/demo

dcoker logs --since=1h 'container_id'


docker tag prasadbhalerao/demo pbaksdemo.azurecr.io/prasadbhalerao/demo:latest

docker login pbaksdemo.azurecr.io

docker push pbaksdemo.azurecr.io/prasadbhalerao/demo:latest

##kubectl secret

kubectl apply -f appdeployment.yaml --record

kubectl apply -f service.yaml

kubectl get deployment

kubectl delete deployment aksdemo-deployment -n default
kubectl delete deployment mssql-deployment -n default

kubectl delete service app-service -n default

kubectl get services

kubectl logs <pod_name>