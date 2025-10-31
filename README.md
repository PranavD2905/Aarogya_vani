# Aarogya Vani

Aarogya Vani is a **speech-translation telemedicine backend**, built using Python and FastAPI.  
It supports speech-to-text (STT), translation, and text-to-speech (TTS), enabling seamless multilingual voice-based consultations.

---

## 🚀 Features

- Convert patient speech into text using STT (`stt.py`)  
- Translate input text between languages (`translate.py`)  
- Generate speech from translated text using TTS (`tts.py`)  
- Utility functions for audio handling and file management (`utils.py`)  
- Easily configurable with environment variables (`.env`)  

---

## 💡 Motivation / Why

The goal of **Aarogya Vani** is to reduce language barriers in telemedicine by automating the process of transcribing, translating, and speaking patient messages. This can help doctors understand patients speaking in their native language and respond in their own.

---

## 🧱 Project Structure

AI_TRANSLATION_BACKEND/
├── .venv/
├── pycache/
├── .env # Environment variables
├── main.py # Entry point: FastAPI server
├── requirements.txt # Python dependencies
├── stt.py # Speech-to-Text logic
├── translate.py # Translation engine
├── tts.py # Text-to-Speech logic
├── utils.py # Helper functions
└── temp_audio.wav # Temporary audio storage

---

## 🛠️ Getting Started / Installation

1)Clone the repository
bash
git clone https://github.com/PranavD2905/Aarogya_vani.git
cd Aarogya_vani

2)Set up a virtual environment

bash
python3 -m venv .venv
source .venv/bin/activate   # On Windows use `.venv\Scripts\activate`


3)Install dependencies

bash
pip install -r requirements.txt


4)Configure environment variables
Create a .env file with the required keys, for example:

OPENAI_API_KEY=your_openai_api_key  
TRANSLATION_API_URL=…  
TTS_VOICE=…  


(Adjust based on what your code expects.)

5)Run the FastAPI server

bash
uvicorn main:app --reload


The API will be available at http://127.0.0.1:8000.

