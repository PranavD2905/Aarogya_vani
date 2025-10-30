import os
from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def text_to_speech(text: str, output_path="output.mp3"):
    """Convert text to speech using OpenAI TTS."""
    response = client.audio.speech.create(
        model="gpt-4o-mini-tts",
        voice="alloy",
        input=text
    )
    with open(output_path, "wb") as f:
        f.write(response.read())
    return output_path
