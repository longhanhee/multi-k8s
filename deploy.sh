docker build -t luhansmilex/multi-client:latest -t luhansmilex/multi-client:$SHA -f .client/Dockerfile ./client
docker build -t luhansmilex/multi-server:latest -t luhansmilex/multi-server:$SHA -f .server/Dockerfile ./server
docker build -t luhansmilex/multi-worker:latest -t luhansmilex/multi-worker:$SHA -f .worker/Dockerfile ./worker
docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD" docker.io      
docker push luhansmilex/multi-client:latest
docker push luhansmilex/multi-server:latest
docker push luhansmilex/multi-worker:latest

docker push luhansmilex/multi-client:$SHA
docker push luhansmilex/multi-server:$SHA
docker push luhansmilex/multi-worker:$SHA
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=luhansmilex/multi-server:$SHA
kubectl set image deployments/client-deployment client=luhansmilex/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=luhansmilex/multi-worker:$SHA