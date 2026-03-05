FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update \
 && apt-get install -y curl postgresql-client \
 && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .
RUN chmod +x wait-for-db.sh

RUN mkdir -p logs

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "forum_sandbox.wsgi:application"]
