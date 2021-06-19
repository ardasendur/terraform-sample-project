FROM python:3.8 as builder
LABEL maintainer="ardasendur"
COPY /src/requirements.txt .

RUN pip install --user -r requirements.txt

# second unnamed stage
FROM python:3.8-slim
WORKDIR /code

# copy only the dependencies installation from the 1st stage image
COPY --from=builder /root/.local /root/.local
COPY ./src/app.py .

# update PATH environment variable
ENV PATH=/root/.local:$PATH
EXPOSE 5000
CMD [ "python", "./app.py" ]