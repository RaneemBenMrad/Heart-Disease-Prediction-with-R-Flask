from flask import Flask, request, render_template
import pandas as pd
import numpy as np

app = Flask(__name__)

# Charger les coefficients
try:
    coefs = pd.read_csv('model_coefficients.csv', index_col=0)
    coefs = coefs['x'].to_dict()
    print("Coefficients chargés avec succès")
except Exception as e:
    print(f"Erreur lors du chargement des coefficients : {e}")
    exit(1)

# Variables attendues par logistic2 (sans fbs)
features = [
    'age', 'trestbps', 'chol', 'thalach', 'oldpeak',
    'sex', 'cp', 'restecg', 'exang', 'slope', 'ca', 'thal'
]

def predict_heart_disease(data):
    intercept = coefs['(Intercept)']
    log_odds = intercept

    for var in ['age', 'trestbps', 'chol', 'thalach', 'oldpeak']:
        if var in data:
            log_odds += coefs[var] * float(data[var])

    if data['sex'] == 'M':
        log_odds += coefs.get('sexM', 0)
    if data['cp'] != '1':
        log_odds += coefs.get(f'cp{data["cp"]}', 0)
    if data['restecg'] != '0':
        log_odds += coefs.get(f'restecg{data["restecg"]}', 0)
    if data['exang'] == '1':
        log_odds += coefs.get('exang1', 0)
    if data['slope'] != '1':
        log_odds += coefs.get(f'slope{data["slope"]}', 0)
    if data['ca'] != '0':
        log_odds += coefs.get(f'ca{data["ca"]}', 0)
    if data['thal'] != '3':
        log_odds += coefs.get(f'thal{data["thal"]}', 0)

    probability = 1 / (1 + np.exp(-log_odds))
    return probability

@app.route('/', methods=['GET', 'POST'])
def index():
    prediction = None
    if request.method == 'POST':
        try:
            data = {
                'age': request.form['age'],
                'sex': request.form['sex'],
                'cp': request.form['cp'],
                'trestbps': request.form['trestbps'],
                'chol': request.form['chol'],
                'restecg': request.form['restecg'],
                'thalach': request.form['thalach'],
                'exang': request.form['exang'],
                'oldpeak': request.form['oldpeak'],
                'slope': request.form['slope'],
                'ca': request.form['ca'],
                'thal': request.form['thal']
            }
            probability = predict_heart_disease(data)
            prediction = f"Probabilité de maladie cardiaque : {probability:.2%}"
        except Exception as e:
            prediction = f"Erreur lors de la prédiction : {e}"
    return render_template('index.html', prediction=prediction)

if __name__ == '__main__':
    app.run(debug=True, port=5003)