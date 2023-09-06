mk start --memory=4096

k config set-context --current --namespace=strim-ns

# deploy CRDs & operator pod
kubectl create -f 'https://strimzi.io/install/latest?namespace=kafka' -n kafka

# watch pod
kubectl get pod -n kafka --watch

# get the logs
kubectl logs deployment/strimzi-cluster-operator -n kafka -f

kubectl logs kafka/kafka-cluster -n kafka -f

#
kubectl exec -it kafka-cluster-kafka-0 -- /bin/bash

./bin/kafka-topics.sh --list --bootstrap-server localhost:9092

kubectl get secret/admin -o yaml

# extract password for user admin
kubectl get secret admin -o jsonpath='{.data.password}' | base64 --decode

# list containers
kubectl get pods kafka-cluster-kafka-0 -o jsonpath='{.spec.containers[*].name}'
kafka

# cp
kubectl cp /home/matar/github/strimzi-matar/consumer.properties kafka/kafka-cluster-kafka-0:/tmp/consumer.properties

# consumer with config
./bin/kafka-topics.sh --list --bootstrap-server localhost:9092 --command-config /tmp/consumer.properties

# create a topic
./bin/kafka-topics.sh --create --topic matar22 --bootstrap-server localhost:9092 --command-config /tmp/consumer.properties

# extract password for user matar
kubectl get secret matar -o jsonpath='{.data.password}' | base64 --decode

# cp matar config to kafka pod
kubectl cp /home/matar/github/strimzi-matar/matar.properties kafka/kafka-cluster-kafka-0:/tmp/matar.properties

# consumer matar with config
./bin/kafka-topics.sh --list --bootstrap-server localhost:9092 --command-config /tmp/matar.properties


./bin/kafka-topics.sh --create --topic matar55 --bootstrap-server localhost:9092 --command-config /tmp/matar.properties
