import os
import whisper
from openai import OpenAI

def speech_to_text(audio_path: str):
    """Convert speech to text using OpenAI Whisper API or fallback to local model."""
    try:
        api_key = os.getenv("OPENAI_API_KEY")

        if api_key:  # Try OpenAI API first
            client = OpenAI(api_key=api_key)
            with open(audio_path, "rb") as audio_file:
                transcript = client.audio.transcriptions.create(
                    model="whisper-1",
                    file=audio_file
                )
            return transcript.text
        else:
            raise Exception("No API key found, switching to local model")

    except Exception as e:
        print(f"[INFO] Falling back to local Whisper model because: {e}")
        model = whisper.load_model("base")  # 'tiny', 'base', 'small', 'medium', 'large'
        result = model.transcribe(audio_path)
        return result["text"]
