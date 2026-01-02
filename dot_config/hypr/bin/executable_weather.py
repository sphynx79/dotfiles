#!/usr/bin/env python3

import os
import sys
import json
import subprocess
from datetime import datetime

# --- CONFIGURAZIONE STATICA (Dal tuo file config) ---
CONFIG = {
    "LOCATION": "45.416774071142534,9.262571769084099", # Coordinate Milano Sud-Est
    "TEMP_UNIT": "c",             # 'c' o 'f'
    "TIME_FORMAT": "24h",         # '12h' o '24h'
    "WINDSPEED_UNIT": "km/h",     # 'km/h' o 'mph'
    "SHOW_ICON": True,
    "SHOW_LOCATION": True,
    "SHOW_TODAY_DETAILS": True,
    "FORECAST_DAYS": 3
}

# --- FUNZIONE DI NOTIFICA ---
def send_notify(title, message, urgency="normal"):
    """Invia una notifica di sistema usando notify-send"""
    try:
        subprocess.run(["notify-send", "-u", urgency, title, message])
    except FileNotFoundError:
        # Se notify-send non è installato, ignoriamo (o scriviamo su stderr)
        sys.stderr.write(f"Notify non disponibile. Msg: {message}\n")

# --- CONTROLLO DIPENDENZE ---
try:
    import requests
except ImportError:
    error_msg = "Modulo Python 'requests' mancante.\nEsegui: pip install requests"
    # 1. Invia notifica Desktop
    send_notify("Waybar Weather Error", error_msg, "critical")
    # 2. Mostra errore nella barra (JSON)
    print(json.dumps({
        "text": "🚫 Deps Error",
        "tooltip": error_msg,
        "class": "error"
    }))
    sys.exit(1)

### COSTANTI ICONE ###
WEATHER_CODES = {
    **dict.fromkeys(["113"], "☀️ "),
    **dict.fromkeys(["116"], "⛅ "),
    **dict.fromkeys(["119", "122", "143", "248", "260"], "☁️ "),
    **dict.fromkeys(
        ["176", "179", "182", "185", "263", "266", "281", "284", "293", "296", "299",
         "302", "305", "308", "311", "314", "317", "350", "353", "356", "359", "362",
         "365", "368", "392"],
        "🌧️ ",
    ),
    **dict.fromkeys(["200"], "⛈️ "),
    **dict.fromkeys(
        ["227", "230", "320", "323", "326", "374", "377", "386", "389"], "🌨️ "
    ),
    **dict.fromkeys(["329", "332", "335", "338", "371", "395"], "❄️ "),
}

### FUNZIONI DI FORMATTAZIONE ###
def get_weather_icon(weatherinstance):
    return WEATHER_CODES.get(weatherinstance["weatherCode"], "❓")

def get_description(weatherinstance):
    return weatherinstance["weatherDesc"][0]["value"]

def get_temperature(weatherinstance):
    if CONFIG["TEMP_UNIT"] == "c":
        return weatherinstance["temp_C"] + "°C"
    return weatherinstance["temp_F"] + "°F"

def get_temperature_hour(weatherinstance):
    if CONFIG["TEMP_UNIT"] == "c":
        return weatherinstance["tempC"] + "°C"
    return weatherinstance["tempF"] + "°F"

def get_feels_like(weatherinstance):
    if CONFIG["TEMP_UNIT"] == "c":
        return weatherinstance["FeelsLikeC"] + "°C"
    return weatherinstance["FeelsLikeF"] + "°F"

def get_wind_speed(weatherinstance):
    if CONFIG["WINDSPEED_UNIT"] == "km/h":
        return weatherinstance["windspeedKmph"] + "Km/h"
    return weatherinstance["windspeedMiles"] + "Mph"

def get_max_temp(day):
    if CONFIG["TEMP_UNIT"] == "c":
        return day["maxtempC"] + "°C"
    return day["maxtempF"] + "°F"

def get_min_temp(day):
    if CONFIG["TEMP_UNIT"] == "c":
        return day["mintempC"] + "°C"
    return day["mintempF"] + "°F"

def get_timestamp(time_str):
    # wttr.in restituisce sempre AM/PM nel JSON, convertiamo se necessario
    if CONFIG["TIME_FORMAT"] == "24h":
        try:
            return datetime.strptime(time_str, "%I:%M %p").strftime("%H:%M")
        except ValueError:
            return time_str
    return time_str

def get_sunrise(day):
    return get_timestamp(day["astronomy"][0]["sunrise"])

def get_sunset(day):
    return get_timestamp(day["astronomy"][0]["sunset"])

def get_city_name(weather):
    return weather["nearest_area"][0]["areaName"][0]["value"]

def get_country_name(weather):
    return weather["nearest_area"][0]["country"][0]["value"]

def format_time(time):
    return (time.replace("00", "")).ljust(3)

def format_temp(temp):
    if temp[0] != "-":
        temp = " " + temp
    return temp.ljust(5)

def format_chances(hour):
    chances = {
        "chanceoffog": "Fog",
        "chanceoffrost": "Frost",
        "chanceofovercast": "Overcast",
        "chanceofrain": "Rain",
        "chanceofsnow": "Snow",
        "chanceofsunshine": "Sunshine",
        "chanceofthunder": "Thunder",
        "chanceofwindy": "Wind",
    }
    conditions = [
        f"{chances[event]} {hour[event]}%"
        for event in chances
        if int(hour.get(event, 0)) > 0
    ]
    return ", ".join(conditions)

### LOGICA PRINCIPALE ###
def main():
    data = {}
    location = CONFIG["LOCATION"].replace(" ", "_")
    url = f"https://wttr.in/{location}?format=j1"
    headers = {"User-Agent": "Mozilla/5.0"}

    try:
        response = requests.get(url, timeout=10, headers=headers)
        response.raise_for_status()
        weather = response.json()
    except requests.exceptions.RequestException:
        # Errore di connessione
        print(json.dumps({"text": "Offline", "tooltip": "Cannot connect to wttr.in"}))
        sys.exit(0)
    except json.decoder.JSONDecodeError:
        # Errore API
        print(json.dumps({"text": "API Error", "tooltip": "Invalid JSON response"}))
        sys.exit(0)

    current_weather = weather["current_condition"][0]

    # --- Costruzione Testo Waybar ---
    data["text"] = get_temperature(current_weather)
    if CONFIG["SHOW_ICON"]:
        data["text"] = get_weather_icon(current_weather) + " " + data["text"]
    if CONFIG["SHOW_LOCATION"]:
        # Se usi coordinate, a volte areaName è vuoto o generico, ma proviamo
        city = get_city_name(weather)
        country = get_country_name(weather)
        data["text"] += f" | {city}, {country}"

    # --- Costruzione Tooltip ---
    data["tooltip"] = ""
    if CONFIG["SHOW_TODAY_DETAILS"]:
        data["tooltip"] += (
            f"<b>{get_description(current_weather)} {get_temperature(current_weather)}</b>\n"
        )
        data["tooltip"] += f"Feels like: {get_feels_like(current_weather)}\n"
        data["tooltip"] += (
            f"Location: {get_city_name(weather)}, {get_country_name(weather)}\n"
        )
        data["tooltip"] += f"Wind: {get_wind_speed(current_weather)}\n"
        data["tooltip"] += f"Humidity: {current_weather['humidity']}%\n"

    # Previsioni giorni successivi
    for i in range(CONFIG["FORECAST_DAYS"]):
        # Controllo per evitare index out of bound se l'API restituisce meno giorni
        if i >= len(weather["weather"]):
            break

        day_instance = weather["weather"][i]
        data["tooltip"] += "\n<b>"
        if i == 0:
            data["tooltip"] += "Today, "
        elif i == 1:
            data["tooltip"] += "Tomorrow, "
        data["tooltip"] += f"{day_instance['date']}</b>\n"
        data["tooltip"] += f"⬆️ {get_max_temp(day_instance)} ⬇️ {get_min_temp(day_instance)} "
        data["tooltip"] += f"🌅 {get_sunrise(day_instance)} 🌇 {get_sunset(day_instance)}\n"

        # Previsioni orarie
        for hour in day_instance["hourly"]:
            # Per oggi, saltiamo le ore già passate
            if i == 0:
                hour_time = int(format_time(hour["time"]).strip())
                if hour_time < datetime.now().hour - 2:
                    continue

            data["tooltip"] += (
                f"{format_time(hour['time'])} {get_weather_icon(hour)} {format_temp(get_temperature_hour(hour))} {get_description(hour)}, {format_chances(hour)}\n"
            )

    print(json.dumps(data))

if __name__ == "__main__":
    main()

