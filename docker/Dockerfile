FROM python:3.10-slim-bullseye

ENV USER=rta

WORKDIR /app

RUN useradd -mrU $USER && \
    chown -R $USER:$USER /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential && \
    rm -rf /var/lib/apt/lists/*

COPY --chown=$USER:$USER src/requirements.txt /app

RUN pip install --no-cache-dir --upgrade -r requirements.txt && \
    python -m spacy download en_core_web_sm && \
    rm -f requirements.txt

COPY --chown=$USER:$USER src/main.py /app
COPY --chown=$USER:$USER src/templates/ /app/templates/
COPY --chown=$USER:$USER src/static/ /app/static/

USER $USER

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]


