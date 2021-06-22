from flask import Flask, jsonify
import math

app = Flask(__name__)


@app.route("/")
def index():
    return jsonify(
        result=str("Happy Flask App"),
        status=200
    )


@app.route("/factorial/<number>")
def factorial(number):
    if int(number) == 0:
        result: int = 1
    elif int(number) < 0:
        result = "No valid input"
    else:
        result = math.factorial(int(number))
    return jsonify(
        result=str(result),
        status=200
    )


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
