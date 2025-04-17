from flask import Flask, request, render_template_string

app = Flask(__name__)

@app.route("/")
def home():
    return "Welcome to Flasky Hack! Try /greet?name=YourName"

@app.route("/greet")
def greet():
    name = request.args.get('name', 'Guest')
    return render_template_string(f"Hello, {name}!")  # SSTI Vulnerability

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)  # Debug mode for extra fun