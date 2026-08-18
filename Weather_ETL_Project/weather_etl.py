import requests
import pandas as pd
import json
from datetime import datetime
import os
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv("OPENWEATHER_API_KEY")
# Check that API key exists
if not API_KEY:
    raise ValueError("OPENWEATHER_API_KEY was not found in the .env file")
# -----------------------------
# 1. EXTRACT
# -----------------------------

cities = ["Nairobi", "Mombasa", "Kisumu", "Eldoret"]

weather_data = []

for city in cities:

    url = (
        f"https://api.openweathermap.org/data/2.5/weather"
        f"?q={city}&appid={API_KEY}&units=metric"
    )

    response = requests.get(url)

    if response.status_code == 200:

        data = response.json()

        weather_data.append(data)

        print(f"Successfully extracted data for {city}")

    else:
        print(f"Failed to retrieve data for {city}")
        print(response.text)


# Save raw data
with open("raw_weather_data.json", "w") as file:
    json.dump(weather_data, file, indent=4)

print("\nRaw weather data extracted successfully.")


# -----------------------------
# 2. TRANSFORM
# -----------------------------

clean_data = []

for data in weather_data:

    record = {
        "City": data["name"],
        "Temperature_C": data["main"]["temp"],
        "Feels_Like_C": data["main"]["feels_like"],
        "Humidity_%": data["main"]["humidity"],
        "Weather_Condition": data["weather"][0]["main"],
        "Wind_Speed_mps": data["wind"]["speed"],
        "Pressure_hPa": data["main"]["pressure"],
        "Date_Time": datetime.fromtimestamp(data["dt"])
    }

    clean_data.append(record)


df = pd.DataFrame(clean_data)

print("\nTransformed Dataset:")
print(df)


# -----------------------------
# 3. DATA CLEANING
# -----------------------------

df["Temperature_C"] = pd.to_numeric(df["Temperature_C"])
df["Humidity_%"] = pd.to_numeric(df["Humidity_%"])
df["Wind_Speed_mps"] = pd.to_numeric(df["Wind_Speed_mps"])

df["Date_Time"] = pd.to_datetime(df["Date_Time"])

print("\nDataset Information:")
print(df.info())

print("\nStatistical Summary:")
print(df.describe())


# -----------------------------
# 4. LOAD
# -----------------------------

df.to_csv("processed_weather_data.csv", index=False)

df.to_excel("processed_weather_data.xlsx", index=False)

print("\nData successfully saved!")


# -----------------------------
# 5. BASIC ANALYSIS
# -----------------------------

highest_temperature = df.loc[
    df["Temperature_C"].idxmax()
]

highest_humidity = df.loc[
    df["Humidity_%"].idxmax()
]

print("\n===== WEATHER ANALYSIS =====")

print(
    f"Highest temperature: "
    f"{highest_temperature['City']} "
    f"({highest_temperature['Temperature_C']}°C)"
)

print(
    f"Highest humidity: "
    f"{highest_humidity['City']} "
    f"({highest_humidity['Humidity_%']}%)"
)

print("\nWeather Conditions:")
print(df[["City", "Weather_Condition"]])


import matplotlib.pyplot as plt

# Temperature comparison
plt.figure(figsize=(8, 5))

plt.bar(df["City"], df["Temperature_C"])

plt.title("Temperature Comparison Across Cities")
plt.xlabel("City")
plt.ylabel("Temperature (°C)")

plt.xticks(rotation=30)

plt.tight_layout()
plt.show()

plt.figure(figsize=(8, 5))

plt.bar(df["City"], df["Humidity_%"])

plt.title("Humidity Comparison Across Cities")
plt.xlabel("City")
plt.ylabel("Humidity (%)")

plt.xticks(rotation=30)

plt.tight_layout()
plt.show()


print("\nKey Findings")

print(
    "Hottest city:",
    df.loc[df["Temperature_C"].idxmax(), "City"]
)

print(
    "Most humid city:",
    df.loc[df["Humidity_%"].idxmax(), "City"]
)

print(
    "Windiest city:",
    df.loc[df["Wind_Speed_mps"].idxmax(), "City"]
)