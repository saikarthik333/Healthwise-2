# components/maps.py
import requests
import pandas as pd
from geopy.geocoders import Nominatim

def find_nearby_doctors(location_query):
    """Finds nearby doctors using the free OpenStreetMap APIs."""
    try:
        geolocator = Nominatim(user_agent="healthwise_app")
        location = geolocator.geocode(location_query)
        if not location:
            return [], None
        lat, lon = location.latitude, location.longitude
    except Exception as e:
        print(f"Geocoding error: {e}")
        return [], None

    overpass_query = f"""
    [out:json];
    (
      node["amenity"~"doctors|hospital"](around:5000,{lat},{lon});
      way["amenity"~"doctors|hospital"](around:5000,{lat},{lon});
      relation["amenity"~"doctors|hospital"](around:5000,{lat},{lon});
    );
    out center;
    """
    overpass_url = "https://overpass-api.de/api/interpreter"
    
    try:
        response = requests.get(overpass_url, params={'data': overpass_query})
        response.raise_for_status()
        data = response.json()
    except requests.exceptions.RequestException as e:
        print(f"Overpass API error: {e}")
        return [], None

    places = []
    map_points = []
    for element in data.get('elements', []):
        tags = element.get('tags', {})
        name = tags.get('name', 'N/A')
        if element['type'] == 'node':
            place_lat, place_lon = element['lat'], element['lon']
        else:
            place_lat, place_lon = element['center']['lat'], element['center']['lon']
        
        places.append({'name': name, 'lat': place_lat, 'lon': place_lon})
        map_points.append({'lat': place_lat, 'lon': place_lon})

    if not map_points:
        return [], None

    map_df = pd.DataFrame(map_points)
    return places, map_df