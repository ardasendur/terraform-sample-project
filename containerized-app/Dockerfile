FROM python:3.8 as builder
LABEL maintainer="ardasendur"
COPY /src/requirements.txt /requirements.txt

RUN pip install --user --no-cache-dir -r requirements.txt

# builder pattern
FROM python:3.8-slim
WORKDIR /containerized-app

# copy only the dependencies installation from the 1st stage image
COPY --from=builder /root/.local /root/.local
COPY ./src/app.py .

# update PATH environment variable
ENV PATH=/root/.local:$PATH
EXPOSE 5000
CMD [ "python", "./app.py" ]