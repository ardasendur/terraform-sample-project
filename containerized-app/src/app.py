from flask import Flask
import math

app = Flask(__name__)


@app.route("/")
def index():
    return "Hello World!"


@app.route("/factorial/<number>")
def factorial(number):
    if int(number) <= 0:
        result: int = 1
    else:
        result = math.factorial(int(number))
    return str(result)


if __name__ == "__main__":
    app.run(host='0.0.0.0')
