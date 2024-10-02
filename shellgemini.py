# -*- coding: utf-8 -*-
import requests
import sys
import os

GEMINI_API_KEY = os.getenv('API_KEY')

def chat_gemini(text: str):
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key={GEMINI_API_KEY}"
    headers = {
        "Content-Type": "application/json"
    }
    data = {"contents": [{"parts": [{"text": f"Ciberseguridad: {text}"}]}]}
    response = requests.post(url, headers=headers, json=data)
    if response.status_code == 400:
        print("Clave API no válida")
    else:
        response_json = response.json()
        return response_json["candidates"][0]["content"]["parts"][0]["text"]

def formatear_respuesta(respuesta: str):
    respuesta = respuesta.replace("#", "").replace("*", "").replace("_", "").replace("`", "").strip()
    return respuesta

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso de shellgemini: shellgemini <pregunta>")
        sys.exit(1)

    pregunta = " ".join(sys.argv[1:])
    respuesta = chat_gemini(text=pregunta)

    if respuesta:
        print(formatear_respuesta(respuesta))
