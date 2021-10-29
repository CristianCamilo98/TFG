import requests
import json
import os
import datetime
from market import api_key

def get_meteo_for_locality(locality):
    payload = {
            'q': locality + ',ES',
            'appid': api_key,
            'units': 'metric'
    }

    endpoint = "http://api.openweathermap.org/data/2.5/weather"
    r = requests.get(endpoint, params=payload)

    if r.status_code == 200:
        meteodata = r.json()
        timestamp = datetime.datetime.now().isoformat()
        return float(meteodata["main"]["temp"])
    else:
        return None



    
