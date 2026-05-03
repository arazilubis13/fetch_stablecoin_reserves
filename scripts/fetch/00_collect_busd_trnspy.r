# -*- coding: utf-8 -*-
"""
Created on Tue Jan 20 23:36:13 2026

@author: X1 Carbon i7-7500
"""

import PyPDF2
import pandas as pd
import re
from pathlib import Path

# Directory containing the PDF files
pdf_dir = Path("/Users/X1 Carbon i7-7500/Dropbox/stablecoins/busd/")

# List to store extracted data
data = []

# Process each PDF file
for pdf_file in sorted(pdf_dir.glob("*.pdf")):
    try:
        with open(pdf_file, 'rb') as file:
            pdf_reader = PyPDF2.PdfReader(file)
            
            # Extract text from all pages
            full_text = ""
            for page in pdf_reader.pages:
                full_text += page.extract_text()
            
            # Find report dates - pattern: "Month DD, YYYY"
            date_pattern = r'(January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2},\s+\d{4}'
            dates = re.findall(date_pattern, full_text)
            
            # Find BUSD circulation numbers
            busd_pattern = r'BUSD tokens in circulation\s+(\d{1,3}(?:,\d{3})*)'
            busd_matches = re.findall(busd_pattern, full_text)
            
            # Find redemption assets values (from the summary table)
            assets_pattern = r'Fair Value of Redemption Assets.*?\$(\d{1,3}(?:,\d{3})*)'
            assets_matches = re.findall(assets_pattern, full_text)
            
            # Find detailed breakdown components
            # Treasury Debt held in reverse repos
            treasury_pattern = r'Total U\.S\. Government Guaranteed Debt Instruments Held Pursuant\s+to Overnight Reverse Repurchase Agreements:\s+(\d{1,3}(?:,\d{3})*)'
            treasury_matches = re.findall(treasury_pattern, full_text)
            
            # Cash held
            cash_pattern = r'Total U\.S\. Dollars Held:\s+(\d{1,3}(?:,\d{3})*)'
            cash_matches = re.findall(cash_pattern, full_text)
            
            # Total from detailed breakdown
            total_pattern = r'Total Fair Value of Redemption Assets:\s+(\d{1,3}(?:,\d{3})*)'
            total_matches = re.findall(total_pattern, full_text)
            
            # Match dates with values (typically 2 dates per report)
            for i in range(min(len(dates), len(busd_matches), len(assets_matches))):
                date_str = dates[i]
                busd = int(busd_matches[i].replace(',', ''))
                assets = int(assets_matches[i].replace(',', ''))
                
                # Get detailed breakdown if available
                treasury = int(treasury_matches[i].replace(',', '')) if i < len(treasury_matches) else None
                cash = int(cash_matches[i].replace(',', '')) if i < len(cash_matches) else None
                total_detailed = int(total_matches[i].replace(',', '')) if i < len(total_matches) else None
                
                over_collat = assets - busd
                over_collat_pct = ((assets / busd) - 1) * 100 if busd > 0 else 0
                
                data.append({
                    'Date': date_str,
                    'BUSD_Circulation': busd,
                    'Treasury_Securities_RRP': treasury,
                    'Cash_USD': cash,
                    'Total_Redemption_Assets': total_detailed,
                    'Redemption_Assets_Summary': assets,
                    'Over_Collateralization_USD': over_collat,
                    'Over_Collateralization_Pct': round(over_collat_pct, 2)
                })
                
    except Exception as e:
        print(f"Error processing {pdf_file.name}: {e}")

# Create DataFrame and sort by date
df = pd.DataFrame(data)
df['Date'] = pd.to_datetime(df['Date'], format='%B %d, %Y')
df = df.sort_values('Date')
df['Date'] = df['Date'].dt.strftime('%B %d, %Y')

# Save to CSV
#output_path = "/mnt/user-data/outputs/busd_reserve_attestations.csv"
#df.to_csv(output_path, index=False)

print(f"Extracted {len(df)} records")
print(df.to_string(index=False))