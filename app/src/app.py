from flask import Flask
from random import randint

app = Flask(__name__)

@app.route('/random')
def randomNumber():
    return str(randint(0,10))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
