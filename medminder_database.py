import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Firebase Admin SDK
cred = credentials.Certificate("/Users/rishabh/Downloads/medminder-8af5d-firebase-adminsdk-twskz-919e41190b.json")  # Replace with your service account key file
firebase_admin.initialize_app(cred)
db = firestore.client()

# List of medications to add
medications = [
    {
        "drug_name": "Acetaminophen",
        "brand_name": ["Tylenol", "Panadol", "Mapap"],
        "food_interaction": "Avoid alcohol. Alcohol can increase the risk of liver damage when taking acetaminophen.",
        "foods_to_avoid": ["alcohol"],
        "recommended_consumption_method": {
            "adult_dosage": "325 mg to 650 mg every 4-6 hours as needed. Maximum 4,000 mg in 24 hours.",
            "children_dosage": "Follow the dosing instructions on the product label or consult a doctor.",
        },
        "side_effects": ["nausea", "rash", "liver damage (with prolonged or excessive use)"],
        "summary": "A pain reliever and fever reducer used for headaches, muscle aches, arthritis, and other minor pains.",
        "synonym": ["Paracetamol", "APAP", "Acetaminophenum"],
    },
    {
        "drug_name": "Atorvastatin",
        "brand_name": ["Lipitor"],
        "food_interaction": "Avoid large amounts of grapefruit or grapefruit juice, which can increase the risk of side effects.",
        "foods_to_avoid": ["grapefruit"],
        "recommended_consumption_method": {
            "adult_dosage": "10 mg to 80 mg once daily, with or without food.",
            "children_dosage": "Consult a doctor.",
        },
        "side_effects": ["muscle pain", "fatigue", "liver enzyme elevation"],
        "summary": "A cholesterol-lowering medication that reduces the risk of heart attacks and strokes.",
        "synonym": ["Statin"],
    },
    {
        "drug_name": "Metformin",
        "brand_name": ["Glucophage", "Fortamet"],
        "food_interaction": "Avoid excessive alcohol, which can increase the risk of lactic acidosis.",
        "foods_to_avoid": ["alcohol"],
        "recommended_consumption_method": {
            "adult_dosage": "500 mg to 2,000 mg daily in divided doses, with meals.",
            "children_dosage": "Consult a doctor.",
        },
        "side_effects": ["nausea", "diarrhea", "metallic taste"],
        "summary": "A medication used to manage type 2 diabetes by lowering blood sugar levels.",
        "synonym": ["Dimethylbiguanide"],
    },
    {
        "drug_name": "Omeprazole",
        "brand_name": ["Prilosec", "Losec"],
        "food_interaction": "Avoid alcohol, which can worsen acid reflux symptoms.",
        "foods_to_avoid": ["alcohol"],
        "recommended_consumption_method": {
            "adult_dosage": "20 mg to 40 mg once daily before a meal, typically for 4-8 weeks.",
            "children_dosage": "Consult a doctor.",
        },
        "side_effects": ["headache", "stomach pain", "diarrhea"],
        "summary": "A proton pump inhibitor (PPI) used to treat acid reflux, ulcers, and GERD.",
        "synonym": ["Proton pump inhibitor"],
    },
    {
        "drug_name": "Losartan",
        "brand_name": ["Cozaar"],
        "food_interaction": "Avoid excessive potassium intake (e.g., bananas, orange juice) to reduce the risk of hyperkalemia.",
        "foods_to_avoid": ["potassium-rich foods"],
        "recommended_consumption_method": {
            "adult_dosage": "25 mg to 100 mg daily, in one or two divided doses.",
            "children_dosage": "Consult a doctor.",
        },
        "side_effects": ["dizziness", "fatigue", "cough"],
        "summary": "An antihypertensive medication used to treat high blood pressure and protect kidneys in diabetic patients.",
        "synonym": ["ARB (Angiotensin Receptor Blocker)"],
    },
    # Add remaining medications in the same format

]

medications2 = [
    {
        "drug_name": "Clopidogrel",
        "brand_name": ["Plavix"],
        "food_interaction": "Avoid grapefruit and grapefruit juice, which can affect how the medication works.",
        "foods_to_avoid": ["grapefruit", "grapefruit juice"],
        "recommended_consumption_method": {
            "adult_dosage": "75 mg once daily.",
            "children_dosage": "Not typically recommended for children.",
        },
        "side_effects": ["bleeding", "rash", "itching"],
        "summary": "An antiplatelet medication used to prevent blood clots in patients with heart disease or stroke risk.",
        "synonym": ["Platelet aggregation inhibitor"],
    },
    {
        "drug_name": "Rivaroxaban",
        "brand_name": ["Xarelto"],
        "food_interaction": "Take with food to enhance absorption. Avoid alcohol as it may increase bleeding risk.",
        "foods_to_avoid": ["alcohol"],
        "recommended_consumption_method": {
            "adult_dosage": "10 mg to 20 mg once daily.",
            "children_dosage": "Consult a doctor.",
        },
        "side_effects": ["bleeding", "dizziness", "headache"],
        "summary": "An anticoagulant used to prevent and treat blood clots.",
        "synonym": ["Direct oral anticoagulant"],
    },
    {
        "drug_name": "Levothyroxine",
        "brand_name": ["Synthroid", "Levoxyl"],
        "food_interaction": "Take on an empty stomach, 30 minutes before breakfast. Avoid calcium-rich foods and supplements around dosing.",
        "foods_to_avoid": ["calcium-rich foods", "iron supplements", "soy"],
        "recommended_consumption_method": {
            "adult_dosage": "25 mcg to 200 mcg once daily.",
            "children_dosage": "Consult a doctor.",
        },
        "side_effects": ["weight loss", "palpitations", "anxiety"],
        "summary": "A medication used to treat hypothyroidism by replacing missing thyroid hormone.",
        "synonym": ["T4", "L-thyroxine"],
    },
    {
        "drug_name": "Tamsulosin",
        "brand_name": ["Flomax"],
        "food_interaction": "Take 30 minutes after the same meal every day. Avoid alcohol as it can worsen side effects.",
        "foods_to_avoid": ["alcohol"],
        "recommended_consumption_method": {
            "adult_dosage": "0.4 mg once daily.",
            "children_dosage": "Not recommended for children.",
        },
        "side_effects": ["dizziness", "fatigue", "runny nose"],
        "summary": "A medication used to treat benign prostatic hyperplasia (BPH) by relaxing muscles in the prostate and bladder.",
        "synonym": ["Alpha-blocker"],
    },
    {
        "drug_name": "Allopurinol",
        "brand_name": ["Zyloprim", "Aloprim"],
        "food_interaction": "Take after meals to reduce stomach upset. Avoid alcohol, as it may reduce effectiveness and worsen gout.",
        "foods_to_avoid": ["alcohol"],
        "recommended_consumption_method": {
            "adult_dosage": "100 mg to 300 mg once daily.",
            "children_dosage": "Consult a doctor.",
        },
        "side_effects": ["rash", "diarrhea", "drowsiness"],
        "summary": "A medication used to treat gout and kidney stones by lowering uric acid levels in the body.",
        "synonym": ["Xanthine oxidase inhibitor"],
    },
    {
        "drug_name": "Duloxetine",
        "brand_name": ["Cymbalta"],
        "food_interaction": "Avoid alcohol, as it may increase the risk of liver damage. Take with or without food.",
        "foods_to_avoid": ["alcohol"],
        "recommended_consumption_method": {
            "adult_dosage": "30 mg to 60 mg once daily.",
            "children_dosage": "Consult a doctor.",
        },
        "side_effects": ["nausea", "dry mouth", "fatigue"],
        "summary": "A serotonin-norepinephrine reuptake inhibitor (SNRI) used to treat depression, anxiety, and chronic pain.",
        "synonym": ["SNRI"],
    },
    {
        "drug_name": "Eszopiclone",
        "brand_name": ["Lunesta"],
        "food_interaction": "Avoid taking with a high-fat meal as it may delay the medication's effects. Avoid alcohol.",
        "foods_to_avoid": ["high-fat foods", "alcohol"],
        "recommended_consumption_method": {
            "adult_dosage": "1 mg to 3 mg immediately before bedtime.",
            "children_dosage": "Not recommended for children.",
        },
        "side_effects": ["drowsiness", "dry mouth", "dizziness"],
        "summary": "A sedative-hypnotic medication used to treat insomnia.",
        "synonym": ["Non-benzodiazepine hypnotic"],
    },
    {
        "drug_name": "Digoxin",
        "brand_name": ["Lanoxin"],
        "food_interaction": "Avoid high-fiber meals, which may reduce drug absorption. Avoid taking it with bran or certain herbs.",
        "foods_to_avoid": ["high-fiber foods", "bran"],
        "recommended_consumption_method": {
            "adult_dosage": "0.125 mg to 0.25 mg once daily.",
            "children_dosage": "Consult a doctor.",
        },
        "side_effects": ["nausea", "blurred vision", "irregular heartbeat"],
        "summary": "A medication used to treat heart failure and irregular heartbeats.",
        "synonym": ["Cardiac glycoside"],
    },
    {
        "drug_name": "Alprazolam",
        "brand_name": ["Xanax"],
        "food_interaction": "Avoid alcohol and grapefruit products, as they can increase side effects.",
        "foods_to_avoid": ["alcohol", "grapefruit"],
        "recommended_consumption_method": {
            "adult_dosage": "0.25 mg to 0.5 mg three times daily as needed.",
            "children_dosage": "Not typically recommended for children.",
        },
        "side_effects": ["drowsiness", "light-headedness", "memory issues"],
        "summary": "A benzodiazepine used to treat anxiety and panic disorders.",
        "synonym": ["Benzodiazepine"],
    },
    {
        "drug_name": "Spironolactone",
        "brand_name": ["Aldactone"],
        "food_interaction": "Avoid potassium-rich foods and salt substitutes to prevent high potassium levels.",
        "foods_to_avoid": ["potassium-rich foods", "salt substitutes"],
        "recommended_consumption_method": {
            "adult_dosage": "25 mg to 100 mg once daily.",
            "children_dosage": "Consult a doctor.",
        },
        "side_effects": ["dizziness", "nausea", "high potassium"],
        "summary": "A diuretic and aldosterone antagonist used to treat heart failure, high blood pressure, and edema.",
        "synonym": ["Aldosterone antagonist"],
    }
]


# Firestore collection name
collection_name = "DrugData"

# Add medications to Firestore
for med in medications2:
    drug_name = med["drug_name"]
    doc_ref = db.collection(collection_name).document(drug_name)
    doc_ref.set(med)

print("Medications added successfully!")
