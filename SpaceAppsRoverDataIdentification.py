import requests
import json

# Docs: https://api.nasa.gov/
API_KEY = "jhlgkeb2ofsQ2Vi3yvtr9fUdDnev5AcYgGOm6zxT"

def fetch_perseverance_photos(sol=100, camera="NAVCAM"):
    """Fetch Perseverance images for a given Martian sol and camera."""
    url = f"https://api.nasa.gov/mars-photos/api/v1/rovers/perseverance/photos"
    params = {
        "sol": sol,
        "camera": camera,
        "api_key": API_KEY
    }
    resp = requests.get(url, params=params)
    data = resp.json()
    return data.get("photos", [])

def extract_locations(photos):
    """For each photo, pull the earth date, rover position, and image id."""
    locs = []
    for p in photos:
        loc = {
            "id": p.get("id"),
            "sol": p.get("sol"),
            "earth_date": p.get("earth_date"),
            "img_src": p.get("img_src"),
            "rover_position": p.get("rover", {}).get("landing_date")
        }
        locs.append(loc)
    return locs

def main():
    photos = fetch_perseverance_photos(sol=500, camera="NAVCAM")
    print(f"Found {len(photos)} photos on sol 500 (NAVCAM).")
    locs = extract_locations(photos)
    for loc in locs[:5]:
        print(loc)

if __name__ == "__main__":
    main()


