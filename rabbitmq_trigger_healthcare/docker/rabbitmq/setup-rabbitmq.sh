#!/bin/bash

# Create exchange
docker exec rabbitmq rabbitmqadmin declare exchange \
  name=lab_events \
  type=topic \
  durable=true

# Create queues
queues=("ehr_updates" "billing_tasks" "pharmacy_checks")
for queue in "${queues[@]}"; do
  docker exec rabbitmq rabbitmqadmin declare queue \
    name=$queue \
    durable=true
done

# Create bindings
for queue in "${queues[@]}"; do
  docker exec rabbitmq rabbitmqadmin declare binding \
    source=lab_events \
    destination_type=queue \
    destination=$queue \
    routing_key="lab.result.completed"
done

# Optional: Dead-letter setup
docker exec rabbitmq rabbitmqadmin declare exchange name=dead_letter type=direct
docker exec rabbitmq rabbitmqadmin declare queue name=dead_letter_queue durable=true
docker exec rabbitmq rabbitmqadmin declare binding source=dead_letter destination=dead_letter_queue