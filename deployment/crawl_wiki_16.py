import os
import requests
import pypandoc
import re
import time
import logging

# --- KONFIGURATION ---
BASE_URL = "https://schulverwaltungsinfos.nrw.de/svws/wiki"
API_URL = f"{BASE_URL}/api.php"
OUTPUT_ROOT = "wiki_export"
LOG_FILE = "export_log.txt"

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[logging.FileHandler(LOG_FILE, encoding='utf-8'), logging.StreamHandler()]
)

session = requests.Session()
session.headers.update({
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
})

def get_all_pages():
    params = {"action": "query", "format": "json", "list": "allpages", "aplimit": "max"}
    try:
        res = session.get(API_URL, params=params).json()
        return [p["title"] for p in res["query"]["allpages"]]
    except Exception as e:
        logging.error(f"Fehler Seitenliste: {e}")
        return []

def download_image_to_dir(file_name, target_dir):
    clean_name = re.sub(r'[\\/*?:"<>|]', "_", file_name).replace(" ", "_")
    full_local_path = os.path.join(target_dir, clean_name)
    if os.path.exists(full_local_path): return clean_name
    params = {"action": "query", "format": "json", "titles": f"File:{file_name}", "prop": "imageinfo", "iiprop": "url"}
    try:
        res = session.get(API_URL, params=params).json()
        pages = res.get("query", {}).get("pages", {})
        for p_id in pages:
            info = pages[p_id].get("imageinfo")
            if info:
                img_data = session.get(info[0]["url"]).content
                with open(full_local_path, "wb") as f: f.write(img_data)
                return clean_name
    except: pass
    return None

def process_page(title):
    logging.info(f"Verarbeite: {title}")
    params = {"action": "parse", "format": "json", "page": title, "prop": "wikitext"}
    try:
        res = session.get(API_URL, params=params, timeout=15).json()
    except Exception as e:
        logging.error(f"Fehler {title}: {e}")
        return
    if "error" in res: return
    
    wikitext = res["parse"]["wikitext"]["*"]

    # 1. ORDNERSTRUKTUR
    cat_pattern = r'\[\[Kategorie:\s?([^\]|]+)(?:\|[^\]]*)?\]\]'
    categories = re.findall(cat_pattern, wikitext, re.IGNORECASE)
    clean_cats = [re.sub(r'[\\/*?:"<>|]', "_", c.strip()).replace(" ", "_") for c in categories]
    target_dir = os.path.join(OUTPUT_ROOT, *clean_cats) if clean_cats else os.path.join(OUTPUT_ROOT, "Unkategorisiert")
    os.makedirs(target_dir, exist_ok=True)

    # 2. BILDER
    img_pattern = r'\[\[(?:Datei|File):([^|\]]+)(?:\|([^\]]*))?\]\]'
    extracted_images = []
    def placeholder_replacer(match):
        clean_filename = download_image_to_dir(match.group(1).strip(), target_dir)
        if not clean_filename: return f"[[{match.group(1)}]]"
        placeholder = f"IMAGE_PLACEHOLDER_{len(extracted_images)}"
        extracted_images.append(f"![{clean_filename}](./{clean_filename})\n\n")
        return placeholder
    wikitext_prepared = re.sub(img_pattern, placeholder_replacer, wikitext, flags=re.IGNORECASE)
    
    # --- 2.5 BOXEN MARKIEREN (Platzhalter statt :::) ---
    wikitext_prepared = wikitext_prepared.replace("{{SEITENNAME}}", title).replace("{{PAGENAME}}", title)
    
    # Wir nutzen temporäre Marken, die Pandoc nicht als Syntax erkennt
    box_pattern = r'\{\{(?:Wichtig|Tipp|Info|Hinweis|Achtung)\|1=(.*?)\}\}'
    wikitext_prepared = re.sub(box_pattern, r'---BOXSTART---\1---BOXEND---', wikitext_prepared, flags=re.DOTALL | re.IGNORECASE)
    
    # Andere Vorlagen entfernen
    wikitext_prepared = re.sub(r'\{\{.*?\}\}', '', wikitext_prepared, flags=re.DOTALL)

    # 3. KONVERTIERUNG
    try:
        md_content = pypandoc.convert_text(wikitext_prepared, 'gfm', format='mediawiki')
    except RuntimeError as e:
        logging.error(f"Pandoc-Fehler {title}: {e}")
        return

    # 4. POST-PROCESSING
    for i, replacement in enumerate(extracted_images):
        md_content = md_content.replace(f"IMAGE_PLACEHOLDER_{i}", replacement)

    # --- BOXEN ZURÜCKWANDELN ---
    # Wir wandeln die Text-Marken nun in die gewünschte ::: Syntax um
    md_content = md_content.replace('---BOXSTART---', '::: warning ')
    md_content = md_content.replace('---BOXEND---', ' :::')

    # Cleanup (TOC, Kategorien, Links)
    md_content = re.sub(r'__.*?TOC.*?__', '', md_content, flags=re.IGNORECASE)
    md_content = re.sub(r'\\?\[TOC\\?\]', '', md_content, flags=re.IGNORECASE)
    md_content = re.sub(r'\[Kategorie:.*?\]\(.*?\)', '', md_content, flags=re.DOTALL | re.IGNORECASE)
    md_content = re.sub(r'\[(.*?)\]\((.*?)\s+"wikilink"\)', r'[\1](\2.md)', md_content)
    md_content = re.sub(r'\]\((.*?)\.md\)', lambda m: f"]({m.group(1).replace(' ', '_')}.md)", md_content)
    md_content = re.sub(r'\n{3,}', '\n\n', md_content).strip()

    # 5. SPEICHERN
    safe_title = re.sub(r'[\\/*?:"<>|]', "_", title).replace(" ", "_")
    output_path = os.path.join(target_dir, f"{safe_title}.md")
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(f"# {title}\n\n{md_content}")
    logging.info(f"Gespeichert: {output_path}")

if __name__ == "__main__":
    if not os.path.exists(OUTPUT_ROOT): os.makedirs(OUTPUT_ROOT)
    pages = get_all_pages()
    for p in pages:
        process_page(p)
        time.sleep(0.5)