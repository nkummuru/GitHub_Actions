#!/bin/bash

echo "Starting Locust performance testing..."

# Validate necessary environment variables (endpoint and test file)
if [ -z "$1" ]; then
  echo "Error: No application endpoint provided."
  exit 1
fi

APP_ENDPOINT=$1

# Run Locust headlessly
locust --headless -u 100 -r 10 -t 2m --host=$APP_ENDPOINT -f /locustfile.py > locust_metrics.log

# Collect and parse test results
AVG_LATENCY=$(grep "Average response time" locust_metrics.log | awk '{print $4}')
ERROR_RATE=$(grep "Failure ratio" locust_metrics.log | awk '{print $3}')
THROUGHPUT=$(grep "Requests per second" locust_metrics.log | awk '{print $4}')

# Define threshold values
MAX_LATENCY=500           # Maximum threshold for average latency (ms)
MAX_ERROR_RATE=0.05       # Maximum threshold for error rate (5%)
MIN_THROUGHPUT=50         # Minimum threshold for requests per second

# Evaluate test results
if (( $(echo "$AVG_LATENCY > $MAX_LATENCY" | bc -l) )); then
  echo "Performance Test Failed: Latency ($AVG_LATENCY ms) exceeded threshold ($MAX_LATENCY ms)."
  exit 1
fi

if (( $(echo "$ERROR_RATE > $MAX_ERROR_RATE" | bc -l) )); then
  echo "Performance Test Failed: Error rate ($ERROR_RATE) exceeded threshold ($MAX_ERROR_RATE)."
  exit 1
fi

if (( $(echo "$THROUGHPUT < $MIN_THROUGHPUT" | bc -l) )); then
  echo "Performance Test Failed: Throughput ($THROUGHPUT req/s) below threshold ($MIN_THROUGHPUT req/s)."
  exit 1
fi

echo "Performance Test Passed!"
echo "::set-output name=testResults::Average Latency: ${AVG_LATENCY} ms, Error Rate: ${ERROR_RATE}, Throughput: ${THROUGHPUT} req/s"
