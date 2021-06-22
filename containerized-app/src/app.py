from flask import Flask
import math

app = Flask(__name__)


@app.route("/")
def index():
    return "Hello World!"

@app.route("/factorial/<number>")
def factorial(number):
    if int(number) == 0:
        result: int = 1
    elif int(number) < 0:
        result = "No valid input!Please run with positive number..."
    else:
        result = math.factorial(int(number))
    return str("Factorial of " + str(number) + " is : " + str(result))


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
