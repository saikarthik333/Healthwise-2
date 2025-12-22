from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
import pickle
import io

from components.prediction import predict_disease
from components.recommendation import (
    get_specialist,
    get_remedies,
    generate_report_pdf
)
from components.maps import find_nearby_doctors

app = Flask(__name__)
CORS(app)

# ---------------- LOAD MODEL & SYMPTOMS ---------------- #
with open("models/model.pkl", "rb") as f:
    model = pickle.load(f)

with open("models/symptoms.pkl", "rb") as f:
    all_symptoms = pickle.load(f)

# ---------------- HEALTH CHECK ---------------- #
@app.route("/api/health", methods=["GET"])
def health():
    return jsonify({"status": "API is running"}), 200

# ---------------- GET SYMPTOMS ---------------- #
@app.route("/api/symptoms", methods=["GET"])
def get_symptoms():
    return jsonify({"symptoms": all_symptoms}), 200

# ---------------- PREDICT DISEASE ---------------- #
@app.route("/api/predict", methods=["POST"])
def predict():
    data = request.json
    selected_symptoms = data.get("symptoms", [])

    if not selected_symptoms:
        return jsonify({"error": "No symptoms provided"}), 400

    disease = predict_disease(selected_symptoms, all_symptoms)
    specialist = get_specialist(disease)
    remedies = get_remedies(disease)

    return jsonify({
        "predicted_disease": disease,
        "specialist": specialist,
        "remedies": remedies
    }), 200

# ---------------- FIND NEARBY DOCTORS ---------------- #
@app.route("/api/doctors", methods=["POST"])
def doctors():
    data = request.json
    location = data.get("location", "")

    if not location:
        return jsonify({"error": "Location not provided"}), 400

    doctors, _ = find_nearby_doctors(location)

    return jsonify({
        "location": location,
        "doctors": doctors
    }), 200

# ---------------- GENERATE PDF REPORT ---------------- #
@app.route("/api/report", methods=["POST"])
def report():
    data = request.json

    symptoms = data.get("symptoms", [])
    disease = data.get("disease", "")
    specialist = data.get("specialist", "")
    remedies = data.get("remedies", [])

    pdf_bytes = generate_report_pdf(
        symptoms, disease, specialist, remedies
    )

    return send_file(
        io.BytesIO(pdf_bytes),
        mimetype="application/pdf",
        as_attachment=True,
        download_name="health_report.pdf"
    )

# ---------------- RUN SERVER ---------------- #
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
