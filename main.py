from fastapi import FastAPI, UploadFile, File, Form
from pydantic import BaseModel
from stt import speech_to_text
from translate import router as translate_router

from tts import text_to_speech

app = FastAPI()

app.include_router(translate_router, prefix="/api", tags=["Translation"])

# 1️⃣ Speech-to-Text
@app.post("/stt/")
async def speech_to_text_endpoint(file: UploadFile = File(...)):
    temp_file = "temp_audio.wav"
    with open(temp_file, "wb") as f:
        f.write(await file.read())
    text = speech_to_text(temp_file)
    return {"transcribed_text": text}

# 2️⃣ Translation
# class TranslationRequest(BaseModel):
#     text: str
#     target_lang: str

# @app.post("/translate/")
# async def translate_endpoint(req: TranslationRequest):
#     result = process_translation(req.text, req.target_lang)
#     return result

# 3️⃣ Text-to-Speech
class TTSRequest(BaseModel):
    text: str

@app.post("/tts/")
async def tts_endpoint(req: TTSRequest):
    output_path = text_to_speech(req.text)
    return {"message": "Speech generated", "file_path": output_path}

@app.get("/")
def root():
    return {"message": "AI Translation Backend is running!"}
