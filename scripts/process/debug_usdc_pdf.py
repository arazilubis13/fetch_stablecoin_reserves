"""Dumps raw text from USDC PDFs to inspect structure for different eras."""
import pdfplumber
from pathlib import Path

RAW_DIR = Path(__file__).parent.parent.parent / "data" / "raw" / "usdc"

# Check one recent and one older report
for filename in ["usdc_2024-06.pdf", "usdc_2022-01.pdf", "usdc_2019-01.pdf"]:
    pdf_path = RAW_DIR / filename
    if not pdf_path.exists():
        print("Not found: {}".format(filename))
        continue
    print("\n{'='*70}")
    print("FILE: {}".format(filename))
    print("="*70)
    with pdfplumber.open(pdf_path) as pdf:
        for i, page in enumerate(pdf.pages):
            text = page.extract_text()
            print("\n--- PAGE {} ---".format(i + 1))
            if text:
                print(text[:3000])
            else:
                print("(no text)")
