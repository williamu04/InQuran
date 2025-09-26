import requests
import sqlite3

url = "https://api.alquran.cloud/v1/quran/quran-uthmani"
response = requests.get(url)
data = response.json()

conn = sqlite3.connect("quran.db")
cursor = conn.cursor()

try:
    cursor.execute("ALTER TABLE ayah ADD COLUMN page INTEGER")
except sqlite3.OperationalError:
    print("Column 'page' already exists, continuing...")

for surah in data["data"]["surahs"]:
    for ayah in surah["ayahs"]:
        number_index = ayah["number"] - 1  
        page = ayah["page"]
        cursor.execute("UPDATE ayah SET page = ? WHERE id = ?", (page, number_index))

conn.commit()

cursor.execute("""
CREATE TABLE ayah_new AS
SELECT * FROM ayah WHERE page IS NOT NULL
""")

cursor.execute("DROP TABLE ayah")
cursor.execute("ALTER TABLE ayah_new RENAME TO ayah")

conn.commit()
conn.close()

print("Pages inserted and column made NOT NULL successfully.")
