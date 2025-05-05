FROM python:3.10-slim

WORKDIR /app
COPY app.py .

RUN pip install flask mysql-connector-python

# Create non-root user and use it
RUN groupadd -g 1001 appgroup && useradd -u 1001 -g appgroup appuser
USER appuser

CMD ["python", "app.py"]