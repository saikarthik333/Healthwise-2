# components/prediction.py
import pickle

with open("models/model.pkl", "rb") as f:
    model = pickle.load(f)

def predict_disease(symptom_input, all_symptoms_list):
    """Predicts the disease based on a list of selected symptoms."""
    input_vector = [1 if symptom in symptom_input else 0 for symptom in all_symptoms_list]
    prediction = model.predict([input_vector])[0]
    return prediction
