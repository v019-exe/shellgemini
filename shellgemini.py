# -*- coding: utf-8 -*-
import requests
import sys
import configparser

config = configparser.ConfigParser()
config.read("/usr/local/bin/shellgemini.conf")

GEMINI_API_KEY = config['DEFAULT']['api_key']

def chat_gemini(text: str):
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key={GEMINI_API_KEY}"   
    headers = {
        "Content-Type": "application/json"
    }
    data = {"contents": [{"parts": [{"text": f"{text}"}]}]}
    response = requests.post(url, headers=headers, json=data)
    if response.status_code == 400:
        print("Clave API no valida")
    else:
        response_json = response.json()
        return response_json["candidates"][0]["content"]["parts"][0]["text"]

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso de shellgemini: shellgemini <pregunta>")
        sys.exit(1)
        
    pregunta = " ".join(sys.argv[1:])
    respuesta = chat_gemini(text=pregunta)
    
    print(respuesta)
