# Filament data set: Bambu Lab and SUNLU (EU, checked 2026-11-12)

This is the seed for the designer site's filament catalogue (see [../PLAN.md](../PLAN.md), step W3). Prices are a snapshot taken on 2026-11-12, and Bambu's are sale prices until 2026-12-01.

## Read this first

- **Bambu hex codes are official and machine-readable.** They come from `filaments_color_codes.json` in the BambuStudio repo (last commit 2026-11-03). I cross-checked PLA Basic (30/30), PLA Matte (25/25) and PETG Translucent (8/8) against Bambu's own "Hex Code Table" PDFs linked from the EU store; all match.
- **PETG HF is no longer on the EU store.** `/products/petg-hf` redirects to PETG Matte, and the filament collection lists PETG Basic and PETG Matte instead. Forum threads from June 2026 say it was discontinued and PETG Basic relaunched as its replacement (no official statement found). I give the PETG HF colours anyway, plus PETG Basic as the line you can actually buy.
- **Every Bambu price below is a Black Friday price.** The EU sale runs Oct 27 13:00 CET to Dec 1 08:00 CET 2026 (live sale page). List prices (MSRP) are unchanged; the bulk tiers are the sale part. The routine non-sale tier structure is **unverified**.
- **SUNLU publishes no hex codes.** All SUNLU hex values are approximations I sampled from the store's own per-colour product renders (median of the object's centre region). They run slightly dark because the renders are shaded.
- **SUNLU's store localised to Romania** (EUR, "Tax included"). Bambu's store shows a generic "Europe" region and says "Final price and VAT may change based on shipping destination at checkout", so the Romanian checkout price is **unverified**.

## Bambu Lab (eu.store.bambulab.com)

### Price structure (live product pages)

| Line | Refill 1 kg | With spool 1 kg | 4 pcs (25%) | 6 pcs (35%) | 10 pcs (43%) | 14 pcs (47%) |
|---|---|---|---|---|---|---|
| PLA Basic, PLA Matte, PETG Translucent, ABS | €16.99 | €19.99 | €12.74 | €11.04 | €9.68 | €9.00 |
| PETG Basic, PETG Matte | €15.99 | €18.99 | €11.99 | €10.39 | €9.11 | €8.47 |
| ASA | none | €14.99 (was €24.99) | no tiers shown | | | |
| TPU for AMS | €21.59 (1 colour) | €23.99 ("was €35.99") | no tiers shown | | | |

- Tier prices are per roll, shown as "Mix & Match", and are computed on the refill MSRP. With-spool tier prices are **unverified** (19.99 × 0.53 would be €10.59).
- 14+ rolls also gets a free roll ("Buy 14+, Get 1 Free").
- Free shipping over €55 for most EU countries; ships from a German warehouse.
- All lines are 1 kg, 1.75 mm; spool is 200 mm diameter × 67 mm (TDS).
- A stale overview page (`/pages/bambu-filament-overview`) still shows an older structure: "4 rolls from €15,99, 6 rolls from just €13,99", base "From €22,99". Treat it as historical only.

### Print settings (one row per line)

| Line | Density (TDS) | Nozzle (TDS) | Bed (TDS) | Speed (TDS) | Studio preset: nozzle / max flow (X1C 0.4) |
|---|---|---|---|---|---|
| PLA Basic | 1.24 (TDS V3.0); Studio uses 1.26 | 190–230 °C | 35–45 °C | < 300 mm/s | 220 °C / 21 mm³/s |
| PLA Matte | 1.31 (TDS V3.0); Studio uses 1.32 | 190–230 °C | 35–45 °C | < 300 mm/s | 220 °C / 22 mm³/s |
| PETG HF | 1.28 (TDS V1.0) | 230–260 °C | 65–75 °C | < 300 mm/s | 245 °C / 21 mm³/s |
| PETG Translucent | 1.25 (TDS V1.0) | 230–270 °C | 65–75 °C | < 220 mm/s | 245 °C / 6 mm³/s |
| PETG Basic | 1.25 (TDS V3.0) | 230–260 °C | 65–75 °C | < 200 mm/s | 255 °C / 15 mm³/s |
| ABS | 1.05 (TDS V3.0) | 240–270 °C | 80–100 °C | < 300 mm/s | 270 °C / 16 mm³/s |
| ASA | 1.05 (TDS V3.0) | 240–270 °C | 80–100 °C | < 250 mm/s | 270 °C / 18 mm³/s |
| TPU for AMS | 1.26 (TDS V1.0) | 220–240 °C | 30–35 °C | < 250 mm/s | 230 °C / 18 mm³/s |

Studio's PLA presets set the textured plate to 55 °C (65 °C on the A1), which is higher than the TDS range.

### PLA Basic: 30 solid colours (hex official)

All 30 are sold as refill; "spool" marks the 13 also sold with spool. All in stock on 2026-11-12.

| Colour | Hex | Notes |
|---|---|---|
| Jade White | #FFFFFF | 10100; spool |
| Black | #000000 | 10101; spool |
| Silver | #A6A9AA | 10102 |
| Gray | #8E9089 | 10103; spool |
| Light Gray | #D1D3D5 | 10104 |
| Dark Gray | #545454 | 10105 |
| Red | #C12E1F | 10200; spool |
| Beige | #F7E6DE | 10201 |
| Magenta | #EC008C | 10202 |
| Pink | #F55A74 | 10203 |
| Hot Pink | #F5547C | 10204; spool |
| Maroon Red | #9D2235 | 10205 |
| Orange | #FF6A13 | 10300 |
| Pumpkin Orange | #FF9016 | 10301; spool |
| Yellow | #F4EE2A | 10400 |
| Gold | #E4BD68 | 10401 |
| Sunflower Yellow | #FEC600 | 10402; spool |
| Bambu Green | #00AE42 | 10501; spool |
| Mistletoe Green | #3F8E43 | 10502; spool |
| Bright Green | #BECF00 | 10503 |
| Blue | #0A2989 | 10601; spool |
| Blue Gray | #5B6579 | 10602; store spells it "Blue Grey" |
| Cyan | #0086D6 | 10603; spool |
| Cobalt Blue | #0056B8 | 10604 |
| Turquoise | #00B1B7 | 10605 |
| Purple | #5E43B7 | 10700 |
| Indigo Purple | #482960 | 10701; spool |
| Brown | #9D432C | 10800 |
| Bronze | #847D48 | 10801 |
| Cocoa Brown | #6F5034 | 10802; spool |

The JSON also files eight PLA Basic Gradient colours under "PLA Basic" (two hex stops each; sold as a separate product, prices not checked): Arctic Whisper #9CDBD9→#FFFFFF, Solar Breeze #E94B3C→#FFFFFF, Ocean to Meadow #307FE2→#54FF9B, Pink Citrus #F78F77→#E4505A, Mint Lime #B6FF43→#4EC939, Blueberry Bubblegum #6FCAEF→#8573DD, Dusk Glare #CE4406→#ED9558, Cotton Candy Cloud #E7C1D5→#8EC9E9.

### PLA Matte: 25 colours (hex official)

All 25 are sold as refill; "spool" marks the 6 also sold with spool.

| Colour | Hex | Notes |
|---|---|---|
| Ivory White | #FFFFFF | 11100; spool |
| Charcoal | #000000 | 11101; spool |
| Ash Gray | #9B9EA0 | 11102; spool |
| Bone White | #CBC6B8 | 11103; out of stock |
| Nardo Gray | #757575 | 11104 |
| Scarlet Red | #DE4343 | 11200; spool (refill out of stock) |
| Sakura Pink | #E8AFCF | 11201; out of stock |
| Dark Red | #BB3D43 | 11202 |
| Terracotta | #B15533 | 11203 |
| Plum | #950051 | 11204; out of stock |
| Mandarin Orange | #F99963 | 11300; spool |
| Lemon Yellow | #F7D959 | 11400 |
| Desert Tan | #E8DBB7 | 11401 |
| Grass Green | #61C680 | 11500 |
| Dark Green | #68724D | 11501 |
| Apple Green | #C2E189 | 11502 |
| Marine Blue | #0078BF | 11600; spool |
| Ice Blue | #A3D8E1 | 11601 |
| Dark Blue | #042F56 | 11602 |
| Sky Blue | #56B7E6 | 11603 |
| Lilac Purple | #AE96D4 | 11700 |
| Latte Brown | #D3B7A7 | 11800 |
| Dark Brown | #7D6556 | 11801 |
| Dark Chocolate | #4D3324 | 11802; out of stock |
| Caramel | #AE835B | 11803 |

### PETG HF: 14 colours (hex official; not on the EU store)

| Colour | Hex | Notes |
|---|---|---|
| White | #FFFFFF | 33100 |
| Gray | #ADB1B2 | 33101 |
| Black | #000000 | 33102 |
| Dark Gray | #515151 | 33103 |
| Red | #BC0900 | 33200 |
| Orange | #F75403 | 33300 |
| Yellow | #FFD00B | 33400 |
| Cream | #F9DFB9 | 33401 |
| Green | #00AE42 | 33500 |
| Lime Green | #6EE53C | 33501 |
| Forest Green | #39541A | 33502 |
| Blue | #002E96 | 33600 |
| Lake Blue | #1F79E5 | 33601 |
| Peanut Brown | #875718 | 33801 |

EU price: **none** (not sold). Refill and spool versions existed.

### PETG Translucent: 9 colours (hex official; still sold)

The JSON stores these as RGBA with alpha 80 (about 50%); Clear is `#00000000`. The store drops the "Translucent" prefix.

| Colour | Hex | Notes |
|---|---|---|
| Clear | #00000000 | 32101; fully transparent in the JSON, absent from the hex PDF; refill + spool |
| Translucent Gray | #8E8E8E | 32100; refill only |
| Translucent Pink | #F9C1BD | 32200; refill only |
| Translucent Orange | #FF911A | 32300; refill only |
| Translucent Olive | #748C45 | 32500; refill only |
| Translucent Teal | #77EDD7 | 32501; refill + spool |
| Translucent Light Blue | #61B0FF | 32600; refill + spool |
| Translucent Purple | #D6ABFF | 32700; refill only |
| Translucent Brown | #C9A381 | 32800; refill only |

### PETG Basic: replacement for PETG HF (hex official)

Thirteen colours are on the EU store, each as refill and spool.

| Colour | Hex | Notes |
|---|---|---|
| Black | #000000 | 30105 |
| White | #FFFFFF | 30106; spool out of stock |
| Gray | #7F7E83 | 30107 |
| Misty Blue | #688197 | 30108 |
| Red | #D6001C | 30201 |
| Orange | #FF671F | 30301 |
| Yellow | #FCE300 | 30402 |
| Dark Beige | #DBC8B6 | 30403 |
| Green | #009639 | 30502 |
| Pine Green | #034638 | 30503 |
| Reflex Blue | #001489 | 30603 |
| Navy Blue | #0086D6 | 30604; hex as published, reads as a mid blue |
| Dark Brown | #4F2C1D | 30800 |

In the JSON but not on the EU store today: Purple #8A75D1 (30701), Sunflower Yellow #FFB81C (30404), Bright Green #97D700 (30504), Hot Pink #F277C6 (30702).

## SUNLU (store.sunlu.com, "Ship to Europe" variants)

### Price structure (live)

- **Single rolls:** compare-at "regular price" €17.99; actual sale prices are in the tables below. Refill rolls (PLA, PLA+, PLA+ 2.0, PETG, Matte PLA) are €10.99 each, and SUNLU says they fit the Bambu reusable spool.
- **Quantity tiers on every product page:** "Buy More Save More, or Mix & Match with other Filaments": 4 rolls 5%, 7 rolls 10%, over 10 rolls 15%. I did not test in a cart whether they apply to the Europe variants.
- **Minimum order:** the PLA page says "The total quantity must be at least 3".
- **Bundles:** PETG Black 1 kg ×3 €32.99, ×6 €62.99, ×10 €101.99 (€11.00 / €10.50 / €10.20 per kg). A Europe-only 3 × 1 kg bundle (PLA, PLA+, PLA Meta, PLA Matte) starts at €32.99, minimum two sets.
- **Spool sizes:** 1 kg standard; 250 g (8-roll bundles); 3 kg and 5 kg large spools (3 kg PLA series "from €27.99", region not checked).
- **Shipping:** free over €40. A "Black Friday Filament Mix & Match, from $8.99/kg" banner is up; not examined.
- **Stock is thin:** many Europe colours are out of stock (marked OOS below).

### Amazon.de (delivery to Romania, prices displayed in RON)

| Item | Price shown | Per kg |
|---|---|---|
| PLA 1 kg (white) | RON 69.98 | 69.98 |
| PLA+ 1 kg | RON 67.76 (black) to 93.30 | same |
| PLA+ 2.0 1 kg | RON 79.27 to 87.80 | same |
| PLA Matte 1 kg | RON 74.62 to 93.30 | same |
| PETG 1 kg | RON 76.84 to 87.80 | same |
| PLA refill 4 kg | RON 213.77 | 53.44 |
| PLA+ refill 4 kg | RON 236.07 | 59.02 |
| PLA+ 2.0 refill 4 kg | RON 252.54 | 63.12 |
| PLA Matte refill 4 kg | RON 230.56 | 57.67 |
| PETG refill 4 kg | RON 198.16 | 49.57 |

EUR equivalents are **unverified**: the displayed prices step in increments of about RON 5.49 per German shelf euro, which would put singles at roughly €12.3–17 and 4 kg refill packs at roughly €9–11.5/kg. No coupon text was visible in the search results.

### Print settings (SUNLU wiki comparison table; Bambu Studio presets for max flow)

| Line | Density | Nozzle | Bed | Studio max flow |
|---|---|---|---|---|
| PLA | 1.23 | 200–240 °C | 50–60 °C | no SUNLU PLA preset |
| PLA+ | 1.21 (Studio uses 1.23) | 205–245 °C | 50–60 °C | 12 mm³/s |
| PLA+ 2.0 | 1.21 | 205–245 °C | 50–60 °C | 22 mm³/s |
| PLA Matte | 1.31 (Studio uses 1.30) | 205–245 °C | 50–60 °C | 21 mm³/s |
| PETG | 1.27 | 240–260 °C | 60–70 °C | 12 mm³/s (14 on X1C) |

SUNLU's product pages give 330 m per kg for the PLA lines and 320 m for PETG. I found no per-line TDS PDF.

**Silk and High Speed, one line each:**
- Silk PLA+ is €13.99 and Silk PLA+ 2.0 €14.99 (compare-at €27.99); density 1.23 / 1.25; 210–230 °C.
- High Speed PLA is €11.99–13.99, HS PLA+ and HS PLA+ 2.0 €13.99, HS Matte PLA €11.99–12.99; density 1.28 / 1.27 / 1.27 / 1.36; 210–230 °C.

### SUNLU PLA: 54 Europe colours (all hex approx)

| Colour | Hex | Notes |
|---|---|---|
| Black | #2B2B2B | €11.99 |
| White | #F1EFED | €11.99 |
| Grey | #6C6C6E | €13.99; OOS |
| Midnight | #222438 | €12.99; OOS |
| Ceramic White | #D9DADF | €13.99; OOS |
| Bone White | #EBDFC3 | €13.99; OOS |
| Roasted Chestnut Black | #2E1A18 | €11.99 |
| Blue (Klein Blue) | #1622A8 | €13.99; OOS |
| Yellow | #EEE339 | €13.99; OOS |
| Green | #36A12C | €13.99; OOS |
| Grass Green | #3E7F69 | €13.99; OOS |
| Gold | #B59236 | €13.99; OOS |
| Silver | #C1CCDA | €13.99; OOS |
| Orange | #FD7E2B | €13.99; OOS |
| Sunny Orange | #FD7E2E | €12.99; OOS |
| Pink (Sakura Pink) | #FDA8B6 | €13.99; OOS |
| Lemon Yellow | #EEEE72 | €13.99; OOS |
| Sky Blue | #41CEFB | €13.99; OOS |
| Skin (Beige) | #EECEBA | €13.99; OOS |
| Mint Green | #12B3A0 | €13.99 |
| Red | #BE2C2D | €13.99; OOS |
| Cyan | #0199D2 | €13.99 |
| Purple (Lavender Purple) | #8672CA | €13.99; OOS |
| Oliver Green | #5E6A43 | €13.99; OOS; store's spelling |
| Coffee-Brown (Coffee) | #542F1B | €13.99; OOS |
| Vivid Yellow | #E9C429 | €13.99; OOS |
| Oak (Wood) | #B8A384 | €13.99; OOS |
| Transparent | #DEDEDD | €13.99; OOS; clear, hex is a placeholder |
| Transparent Red | #D32F3A | €13.99 |
| Transparent Blue | #486EFE | €13.99; OOS |
| Transparent Green | #04AE23 | €13.99 |
| Transparent Yellow | #F9E932 | €13.99; OOS |
| Transparent Purple | #8E37C0 | €13.99; OOS |
| Transparent Orange | #F07F4C | €13.99; OOS |
| Magenta | #C3216D | €12.99; OOS |
| Blue Grey | #3D76CF | €13.99; OOS; render reads as mid blue, low confidence |
| Fuchsia | #F843C3 | €13.99; OOS |
| Fluorescent Blue | #353BF0 | €13.99 |
| Fluorescent Green | #00E110 | €13.99; OOS |
| Fluorescent Purple | #8346FE | €13.99 |
| Fluorescent Red | #FE4C1A | €13.99 |
| Fluorescent Orange | #FE7929 | €13.99 |
| Fluorescent Yellow | #E7EA00 | €13.99; OOS |
| Strawberry Jam | #FE5754 | €13.99; transparent series |
| Orange Juice | #FE9619 | €13.99; transparent series |
| Grape Jelly | #B383EF | €13.99; transparent series |
| Mint Ice | #26D8A9 | €13.99; transparent series |
| Ocean Haze | #4B8AB6 | €13.99; transparent series |
| Mist Black | #2C313E | €13.99; transparent series |
| Pistachio Green | #B3D289 | €12.99; pastel |
| Sage Green | #9DB7A4 | €12.99; OOS; pastel |
| Pastel Blue | #86BDD4 | €12.99; pastel |
| Peach Pink | #EB9484 | €12.99; pastel |
| Earth Green | #34421E | €12.99; vibrant |

### SUNLU PLA+: 35 Europe colours (all hex approx)

| Colour | Hex | Notes |
|---|---|---|
| Black | #2B2B2B | €11.99 |
| White | #F1EFED | €12.99 |
| Grey | #6C6C6E | €13.99; OOS |
| Blue (Klein Blue) | #1622A8 | €12.99 |
| Red | #BE2C2D | €12.99; OOS |
| Bone White | #EBDFC3 | €12.99; OOS |
| Midnight | #222438 | €13.99; OOS |
| Roasted Chestnut Black | #2E1A18 | €13.99; OOS |
| Mint Green | #12B3A0 | €12.99 |
| Cherry Red | #F84A4D | €13.99; OOS |
| Ceramic White | #D9DADF | €13.99 |
| Yellow | #EEE339 | €12.99 |
| Lemon Yellow | #EEEE72 | €12.99 |
| Green | #36A12C | €12.99 |
| Orange | #FD7E2B | €13.99; OOS |
| Silver | #C1CCDA | €13.99; OOS |
| Purple (Lavender Purple) | #8672CA | €12.99 |
| Sakura Pink | #FDA8B6 | €12.99; OOS |
| Sunny Orange | #FD7E2E | €12.99; OOS |
| Sky Blue | #41CEFB | €12.99; OOS |
| Oak (Wood) | #B8A384 | €13.99; OOS |
| Oliver Green | #5E6A43 | €13.99; OOS |
| Transparent | #DEDEDD | €13.99; OOS; clear, placeholder |
| Transparent Blue | #486EFE | €12.99 |
| Transparent Red | #D32F3A | €12.99 |
| Transparent Green | #04AE23 | €12.99 |
| Transparent Yellow | #F9E932 | €12.99 |
| Transparent Purple | #8E37C0 | €13.99 |
| Transparent Orange | #F07F4C | €12.99 |
| Coffee Brown | #542F1B | €13.99; OOS |
| Magenta (Fuchsia) | #F843C3 | €12.99 |
| Gold | #B59236 | €12.99; OOS |
| Grass Green | #3E7F69 | €13.99; OOS |
| Beige (Skin) | #EECEBA | €13.99; OOS |
| Vivid Yellow | #E9C429 | €13.99; OOS |

### SUNLU PLA+ 2.0: 27 Europe colours (all hex approx)

| Colour | Hex | Notes |
|---|---|---|
| Black | #2B2B2B | €11.99 |
| White | #F1EFED | €12.99 |
| Grey | #6C6C6E | €12.99; OOS |
| Magenta (Fuchsia) | #C3216D | €11.99; OOS |
| Red | #BE2C2D | €11.99; OOS |
| Blue (Klein Blue) | #1622A8 | €13.99; OOS |
| Pure Yellow (Vivid Yellow) | #E9C429 | €13.99; OOS |
| Green | #36A12C | €11.99; OOS |
| Sunny Orange | #FD7E2E | €12.99; OOS |
| Silver | #C1CCDA | €13.99; OOS |
| Gold | #B59236 | €13.99; OOS |
| Blue Grey | #3D76CF | €13.99; OOS; low confidence |
| Coffee Brown | #542F1B | €13.99; OOS |
| Ceramic White | #D9DADF | €11.99; OOS |
| Bone White | #EBDFC3 | €11.99; OOS |
| Midnight | #222438 | €13.99; OOS |
| Roasted Chestnut Black | #2E1A18 | €13.99; OOS |
| Oak (Wood) | #B8A384 | €13.99; OOS |
| Cyan | #0199D2 | €13.99; OOS |
| Lemon Yellow | #EEEE72 | €13.99 |
| Cherry Red | #F84A4D | €13.99 |
| Mint Green | #12B3A0 | €13.99 |
| Chocolate | #563835 | €13.99 |
| Orange | #FD7E2B | €13.99; OOS |
| Grass Green | #3E7F69 | €13.99 |
| Yellow | #EEE339 | €13.99 |
| Skin (Beige) | #EECEBA | €13.99; OOS |

### SUNLU PLA Matte: 16 Europe colours (all hex approx)

| Colour | Hex | Notes |
|---|---|---|
| Matte Black | #181818 | €11.99 |
| Matte White | #DCDCD9 | €11.99 |
| Matte Grey | #4D5151 | €11.99 |
| Matte Red | #962322 | €11.99 |
| Matte Klein Blue | #262D97 | €11.99 |
| Matte Bright Yellow | #EAF744 | €12.99; OOS |
| Matte Green | #149738 | €12.99; OOS |
| Matte Light Blue | #7CC5DC | €12.99; OOS; shares its image with Ocean Blue, low confidence |
| Matte Powder Blue | #C1E7E0 | €12.99; OOS |
| Matte Purple (Lavender Purple) | #584EB8 | €11.99 |
| Matte Clay | #666352 | €12.99; OOS |
| Matte Pink | #E07395 | €12.99 |
| Matte Ocean Blue | #7CC5DC | €11.99 |
| Matte Sprout Green | #A5C320 | €11.99; OOS |
| Matte Blue | #475FBF | €12.99; OOS |
| Matte Yellow | #FAEA07 | €12.99 |

### SUNLU PETG: 35 Europe colours (all hex approx)

| Colour | Hex | Notes |
|---|---|---|
| Black | #2B2B2B | €10.99; also 3/6/10-roll bundles |
| White | #F1EFED | €11.99; OOS |
| Grey | #6C6C6E | €11.99 |
| Red | #BE2C2D | €11.99 |
| Blue (Klein Blue) | #1622A8 | €11.99 |
| Green | #36A12C | €12.99 |
| Clear (Transparent) | #DEDEDD | €12.99; OOS; clear, placeholder |
| Orange | #FD7E2B | €12.99; OOS |
| Ceramic White | #D9DADF | €12.99; OOS |
| Bone White | #EBDFC3 | €12.99 |
| Midnight | #222438 | €12.99; store spells it "Midnigh" |
| Roasted Chestnut | #2E1A18 | €12.99 |
| Coffee Brown | #542F1B | €12.99 |
| Vivid Yellow | #E9C429 | €12.99 |
| Cyan | #0199D2 | €12.99 |
| Lavender Purple (Purple) | #8672CA | €12.99 |
| Magenta | #C3216D | €12.99 |
| Beige (Skin) | #EECEBA | €12.99 |
| Oak (Wood) | #B8A384 | €12.99 |
| Transparent Blue | #486EFE | €12.99 |
| Transparent Green | #04AE23 | €12.99 |
| Transparent Purple | #716CE0 | €12.99 |
| Transparent Red | #D32F3A | €12.99 |
| Transparent Orange | #F07F4C | €12.99 |
| Sakura Pink | #FCBBD4 | €11.99 |
| Sky Blue | #41CEFB | €12.99 |
| Chocolate | #563835 | €12.99 |
| Cherry Red | #F84A4D | €12.99 |
| Lemon Yellow | #EEEE72 | €12.99 |
| Mint Green | #12B3A0 | €12.99 |
| Oliver Green | #5E6A43 | €12.99 |
| Transparent Yellow | #F9E932 | €11.99 |
| Sunny Orange | #FD7E2E | €12.99 |
| Yellow | #EEE339 | €12.99 |
| Coffee | #57586A | €12.99; OOS; sampled from a different photo style, low confidence |

## Summary table

Low = best bulk price shown today; high = single-roll list price.

| Brand | Line | Density g/cm³ | EUR/kg low | EUR/kg high | VAT note | Source URL |
|---|---|---|---|---|---|---|
| Bambu Lab | PLA Basic | 1.24 | 9.00 (14+ refills, sale to Dec 1; 12.74 at 4) | 19.99 spool (16.99 refill) | Shown incl. VAT for generic "Europe"; RO checkout unverified | https://eu.store.bambulab.com/products/pla-basic-filament |
| Bambu Lab | PLA Matte | 1.31 | 9.00 (same tiers) | 19.99 spool (16.99 refill) | same | https://eu.store.bambulab.com/products/pla-matte |
| Bambu Lab | PETG HF | 1.28 | not sold in EU | not sold in EU | n/a | https://store.bblcdn.com/ce12d65176a94f1086e6aefa238e62e2.pdf (TDS) |
| Bambu Lab | PETG Translucent | 1.25 | 9.00 (same tiers) | 19.99 spool (16.99 refill) | same | https://eu.store.bambulab.com/products/petg-translucent |
| Bambu Lab | PETG Basic (HF replacement) | 1.25 | 8.47 (14+; 11.99 at 4) | 18.99 spool (15.99 refill) | same | https://eu.store.bambulab.com/products/petg-basic |
| Bambu Lab | ABS (other) | 1.05 | 9.00 (same tiers as PLA) | 19.99 spool (16.99 refill) | same | https://eu.store.bambulab.com/products/abs-filament |
| Bambu Lab | ASA (other) | 1.05 | 14.99 (sale, spool only) | 24.99 ("was") | same | https://eu.store.bambulab.com/products/asa-filament |
| Bambu Lab | TPU for AMS (other) | 1.26 | 21.59 (refill, sale) | 35.99 ("was"); 23.99 spool now | same | https://eu.store.bambulab.com/products/tpu-for-ams |
| SUNLU | PLA | 1.23 | 10.19 (11.99 less 15% at 10+; computed) | 13.99 sale single; 17.99 compare-at | "Tax included", store localised to Romania (EUR) | https://store.sunlu.com/products/over-6kg-of-pla-pla-meta-3d-filaments-1kg-2-2lbs-fit-most-of-fdm-printer |
| SUNLU | PLA+ | 1.21 | 10.19 (computed) | 13.99; 17.99 compare-at | same | https://store.sunlu.com/products/over-6kg-bundle-sale-pla-and-pla-plus-pla-meta-macaron-filament1kg-roll |
| SUNLU | PLA+ 2.0 | 1.21 | 10.19 (computed) | 13.99; 17.99 compare-at | same | https://store.sunlu.com/products/moq-6kg-pla-2-0-upgraded-pla-pla-plus-3d-printer-filament-1kg |
| SUNLU | PLA Matte | 1.31 | 10.19 (computed) | 12.99; 17.99 compare-at | same | https://store.sunlu.com/products/over-6kg-bulk-sale-pla-matte-filament-neatly-wound-filament |
| SUNLU | PETG | 1.27 | 10.20 (10-roll black bundle, listed); 9.34 if 15% stacks on 10.99 (computed) | 12.99; 17.99 compare-at | same | https://store.sunlu.com/products/over-6kg-bundle-sale-petg-3d-printer-filament-1-75mm-1kg-roll |
| SUNLU | Refill (PLA, PLA+, PLA+ 2.0, PETG, Matte) | as line | 9.34 (10.99 less 15%; computed) | 10.99; 17.99 compare-at | same | https://store.sunlu.com/products/sunlu-refill-filament-pla-pla-2-0-compatible-with-2025-sunlu-third-generation-reusable-spool-bambulab-reusable-spool-spool-free-filament |

SUNLU densities are from https://www.sunlu.com/wiki/fdm-performance-comparison. "Computed" lows assume the page's tier discount applies to the Europe variant price; that is **unverified**.

## Short answers

**Machine-readable colour lists**

- **Bambu: yes.** `resources/profiles/BBL/filament/filaments_color_codes.json` in `bambulab/BambuStudio` (branch `master`, AGPL-3.0). It has 342 entries with `fila_type`, `fila_id`, `fila_color_code`, `fila_color` (array of `#RRGGBBAA`; two entries for gradients) and `fila_color_name` in 12 languages. Raw URL: https://raw.githubusercontent.com/bambulab/BambuStudio/master/resources/profiles/BBL/filament/filaments_color_codes.json
- The same file exists in `SoftFever/OrcaSlicer` (branch `main`) at the same path, slightly smaller, so probably older.
- The filament presets (`Bambu PLA Basic @base.json` and friends, same folder) carry density, flow limit, temperatures and `filament_cost`, but **no** per-colour field; I found no `default_filament_colour` in any of the 30 or so base and printer presets I checked (not the whole folder).
- Bambu's store pages also embed a schema.org `ProductGroup` JSON-LD block with every variant, price and stock state. The site sits behind Cloudflare, so automated fetching is unreliable (see below).
- **SUNLU: no hex list anywhere.** Slicer presets exist without colours: `resources/profiles/BBL/filament/SUNLU/` in BambuStudio (PLA+, PLA+ 2.0, PLA Matte, PETG, Silk PLA+, Marble PLA, Wood PLA) and `resources/profiles/OrcaFilamentLibrary/filament/SUNLU/` in OrcaSlicer. The Shopify storefront gives names, localised prices, stock and one image per colour at `https://store.sunlu.com/products/<handle>.js`, which is how I sampled the approximations.

**Licensing / trademark caveat**

Naming brands and their colour names to describe compatible products is ordinary referential use; avoid logos and anything implying endorsement, and add a "not affiliated" line. If you copy the BambuStudio JSON file itself rather than just the facts in it, credit the repo and keep its AGPL-3.0 licence in mind.

## Pages I could not open, and other gaps

- **eu.store.bambulab.com via plain fetch:** HTTP 402. It worked in the in-app browser, but Cloudflare issued a challenge or 429 after about three quick page loads; I waited and retried rather than solving anything.
- **wiki.bambulab.com filament guide:** HTTP 402, not read. Densities and temperatures come from the TDS PDFs instead.
- **Bambu's 2026 Black Friday terms page:** the old URL returns 404; the sale page's own terms say nothing about filament tiers.
- **all3dp.com (German sale article) and geizhals.eu:** HTTP 403.
- **amazon.de via plain fetch:** HTTP 503; read in the in-app browser instead, RON prices only.
- **Not checked:** TPU 95A HF, PLA Basic Gradient prices, a separate SUNLU EU domain (none found or visited), SUNLU cart behaviour for tier discounts, Bambu checkout price for Romania.
- **Not verified here:** Romania's standard VAT rate (21% from memory).
