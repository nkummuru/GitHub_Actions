FROM python:3.9-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install required packages
#RUN pip install locust
RUN pip install locust && \
    pt-get update && apt-get install -y \
    apache2-utils \
    bash \
    curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the entrypoint script into the container
COPY locustfile.py /locustfile.py
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
