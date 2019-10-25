FROM python:3.7
COPY requirements /tmp
RUN pip install -r /tmp/requirements.txt
