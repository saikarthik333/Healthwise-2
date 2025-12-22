# components/recommendation.py
from fpdf import FPDF
from datetime import datetime

def get_specialist(disease):
    """Returns the recommended doctor specialty for a given disease."""
    specialist_mapping = {
        "flu": "General Physician", "diabetes": "Endocrinologist",
        "migraine": "Neurologist", "asthma": "Pulmonologist",
        "covid-19": "Infectious Disease Specialist", "common cold": "General Physician",
    }
    return specialist_mapping.get(disease.lower(), "General Physician")

def get_remedies(disease):
    """Returns a list of general remedies for a given disease."""
    remedy_mapping = {
        "flu": ["Rest and stay hydrated", "Take over-the-counter pain relievers", "Drink warm liquids"],
        "diabetes": ["Monitor blood sugar levels", "Follow a balanced, low-sugar diet", "Engage in regular physical activity"],
        "migraine": ["Rest in a quiet, dark room", "Apply a cold compress", "Stay hydrated"],
        "asthma": ["Avoid known triggers (dust, pollen)", "Use your prescribed inhaler", "Practice deep breathing exercises"],
        "covid-19": ["Isolate to prevent spreading", "Monitor oxygen levels and fever", "Stay hydrated and rest"],
        "common cold": ["Gargle with warm salt water", "Drink warm soups and teas", "Use a humidifier"],
    }
    return remedy_mapping.get(disease.lower(), ["Please consult a doctor for appropriate remedies."])

def generate_report_pdf(symptoms, disease, specialist, remedies):
    """Generates a PDF report summarizing the health analysis."""
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", "B", 16)
    pdf.cell(0, 10, "HealthWise AI Analysis Report", 0, 1, "C")
    pdf.set_font("Arial", "", 10)
    pdf.cell(0, 5, f"Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}", 0, 1, "C")
    pdf.ln(10)

    pdf.set_font("Arial", "B", 12)
    pdf.cell(0, 10, "1. Your Reported Symptoms", 0, 1)
    pdf.set_font("Arial", "", 11)
    pdf.multi_cell(0, 8, "- " + "\n- ".join(symptoms))
    pdf.ln(5)

    pdf.set_font("Arial", "B", 12)
    pdf.cell(0, 10, "2. AI-Powered Prediction", 0, 1)
    pdf.set_font("Arial", "", 11)
    pdf.cell(0, 8, f"Predicted Condition: {disease.title()}", 0, 1)
    pdf.cell(0, 8, f"Recommended Specialist: {specialist}", 0, 1)
    pdf.ln(5)

    pdf.set_font("Arial", "B", 12)
    pdf.cell(0, 10, "3. General Remedies & Precautions", 0, 1)
    pdf.set_font("Arial", "", 11)
    pdf.multi_cell(0, 8, "- " + "\n- ".join(remedies))
    pdf.ln(5)

    pdf.set_font("Arial", "I", 9)
    pdf.multi_cell(0, 5, "Disclaimer: This is an AI-generated report for informational purposes only and is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician.")
    return bytes(pdf.output(dest='S'))