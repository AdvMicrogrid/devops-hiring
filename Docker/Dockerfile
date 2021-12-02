FROM python:latest as builder

RUN mkdir -p /opt/my_app
WORKDIR /opt/my_app
COPY my_app/file_maker.py ./
RUN python file_maker.py
RUN find /opt/my_app/ -name ‘index*.json’ -exec cp {} /tmp \;

FROM python:latest

RUN mkdir -p /opt/my_app
COPY --from=builder /tmp .
WORKDIR /opt/my_app
COPY my_app/requirements.txt ./
RUN pip install -r requirements.txt
COPY my_app ./

EXPOSE 8080

ENTRYPOINT ["python", "my_app.py"]
CMD ["Hello World"]