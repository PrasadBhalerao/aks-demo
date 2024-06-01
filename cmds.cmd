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
 
# Copy the sample database to the pod
# You can download the AdventureWorks2014.bak file from this URL
# https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2014.bak
 
# Use curl command to download the database if you are using Linux otherwise use direct download link
# curl -L -o AdventureWorks2014.bak "https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2014.bak"
 
# Retrieve pod name to variable
podname=$(kubectl get pods | grep mssql | cut -c1-32)
#Display the variable name
echo $podname
#Copy the backup file to POD in AKS. In Linux SQL server is installed on this path. We use this POD Name: /var/opt/mssql/data/ to access the specific directory in the POD
fullpath=${podname}":/var/opt/mssql/data/AdventureWorks2014.bak"
# Just to verify the path. 
echo $fullpath
# just to echo what are we doing
echo Copying AdventureWorks2014 database to pod $podname
 
# Remember to specify the path if your project is running in different directory otherwise we can remove this path and make it kubectl cp AdventureWorks2014.bak  $fullpath
kubectl cp AdventureWorks2014.bak ${fullpath}
 
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
kubectl logs -l app=mssql



# 
docker build -t prasadbhalerao/demo .
docker run -d -p 3000:3000 --name node-app prasadbhalerao/demo


docker tag prasadbhalerao/demo pbaksdemo.azurecr.io/prasadbhalerao/demo:latest

docker login pbaksdemo.azurecr.io

docker push pbaksdemo.azurecr.io/prasadbhalerao/demo:latest

##kubectl secret

kubectl apply -f appdeployment.yaml --record

kubectl apply -f service.yaml