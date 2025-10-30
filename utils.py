# utils.py
import os
import logging
from deep_translator import GoogleTranslator
from openai import OpenAI
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(level=logging.INFO)

# Initialize OpenAI client
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def translate_text_openai(text: str, target_lang: str) -> str:
    """
    Translate text using OpenAI model.
    """
    try:
        logging.info(f"Translating text using OpenAI to '{target_lang}'...")
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": f"You are a translation assistant. Translate the following text to {target_lang}."},
                {"role": "user", "content": text}
            ],
            temperature=0.3
        )
        translated_text = response.choices[0].message.content.strip()
        return translated_text
    except Exception as e:
        logging.error(f"OpenAI translation failed: {e}")
        return None


def translate_text_fallback(text: str, target_lang: str) -> str:
    """
    Fallback translation using Google Translator (deep_translator).
    """
    try:
        logging.info(f"Using GoogleTranslator fallback for '{target_lang}'...")
        return GoogleTranslator(source='auto', target=target_lang).translate(text)
    except Exception as e:
        logging.error(f"GoogleTranslator failed: {e}")
        return "Translation failed with both services."


def translate_text(text: str, target_lang: str) -> str:
    """
    Combined translation function — tries OpenAI first, then falls back to GoogleTranslator.
    """
    translated_text = translate_text_openai(text, target_lang)
    if not translated_text:
        translated_text = translate_text_fallback(text, target_lang)
    return translated_text
