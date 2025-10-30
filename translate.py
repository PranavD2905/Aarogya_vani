# translate.py
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from utils import translate_text

router = APIRouter()

class TranslationRequest(BaseModel):
    text: str
    target_lang: str

@router.post("/translate")
async def translate(request: TranslationRequest):
    """
    API endpoint to translate text into a target language.
    """
    try:
        translated = translate_text(request.text, request.target_lang)
        if "failed" in translated.lower():
            raise HTTPException(status_code=500, detail="Translation failed.")
        return {"translated_text": translated}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
