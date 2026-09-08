# Healthwise-2

AI Symptom Checker & Doctor Locator  
(Flutter + Flask + Machine Learning)

Healthwise-2 is a full-stack mobile application that predicts possible diseases
based on user-selected symptoms using a machine learning model.
The project demonstrates end-to-end integration of Flutter frontend
with a Flask REST API backend.

Refer HealthWise-1 here https://github.com/saikarthik333/Healthwise

---

## Features

- Select multiple symptoms from the mobile app
- Real-time disease prediction using Machine Learning
- Recommended medical specialist
- General remedies and precautions
- REST API based backend architecture
- Cross-platform Flutter frontend

---

## Project Structure

Healthwise-2/
backend/    -> Flask + Machine Learning API  
frontend/   -> Flutter mobile application  

---

## Tech Stack

Frontend:
- Flutter
- Dart
- HTTP package

Backend:
- Python
- Flask
- Flask-CORS

Machine Learning:
- Scikit-learn
- RandomForestClassifier

---

## Backend Structure

backend/
app.py  
models/  
- model.pkl  
- symptoms.pkl  

components/  
- prediction.py  
- recommendation.py  
- maps.py  

requirements.txt  

---

## Frontend Structure

frontend/
lib/
- main.dart  

screens/
- symptom_screen.dart  
- result_screen.dart  

services/
- api_service.dart  

pubspec.yaml  

---

## How to Run the Project

### Backend

cd backend  
pip install -r requirements.txt  
python app.py  

API will run at:  
http://127.0.0.1:5000  

---

### Frontend

cd frontend  
flutter pub get  
flutter run -d chrome  

Make sure backend is running before using prediction.

---

## Application Flow

1. User selects symptoms in Flutter app
2. Flutter sends symptoms to Flask API
3. Flask loads trained ML model
4. Disease is predicted
5. Specialist and remedies are returned
6. Result is shown in Flutter UI

---

## Disclaimer

This project is an AI-powered proof of concept and should not be used as a
substitute for professional medical advice.

---

## Author

Motapothula Sai Karthik  
B.Tech CSE (ML Specialization)

---

## Future Enhancements

- Doctor locator with maps
- PDF health report generation
- User authentication
- Cloud deployment

