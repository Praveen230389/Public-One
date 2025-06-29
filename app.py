from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "<h1>Welcome to Project 2</h1><p>This is served by Flask & Jenkins!</p>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
