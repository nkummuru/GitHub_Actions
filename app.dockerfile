FROM python:3.9-slim

# Prevent buffer issues
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# set working dir
WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

# Expose port 8080
EXPOSE 8080

# Command to run the flask app

CMD ["python", "app.py"]

