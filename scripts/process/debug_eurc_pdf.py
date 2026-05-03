"""Quick script to dump raw text from a PDF so we can see the actual content."""
import pdfplumber
from pathlib import Path

RAW_DIR = Path(__file__).parent.parent.parent / "data" / "raw" / "eurc"

# Look at a recent report
pdf_path = RAW_DIR / "eurc_2024-06.pdf"

with pdfplumber.open(pdf_path) as pdf:
    for i, page in enumerate(pdf.pages):
        print(f"\n{'='*60}")
        print(f"PAGE {i+1}")
        print('='*60)
        print(page.extract_text())
