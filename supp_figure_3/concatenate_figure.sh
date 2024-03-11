#!/bin/bash
FONT="JetBrains-Mono-NL-Regular"
POINTSIZE=66

magick samplot_output/figure_4_prom.png -gravity NorthWest -font "${FONT}" -pointsize $POINTSIZE -annotate +30+10 'A' samplot_output/figure_4_prom_labelled.png
# First, get the width and height of the top image
read top_width top_height <<< $(magick identify -format "%w %h" samplot_output/figure_4_prom.png)

# Calculate width and height for the bottom images
bottom_width=$((top_width / 2))
bottom_height=$((top_height / 4))

# Resize bottom row
#magick \( Barcode02_chr17_chr15_fusion.ribbon.png -resize ${bottom_width}x${bottom_height}! \) 
#        \( Barcode06_chr17_chr15_fusion.ribbon.png -resize ${bottom_width}x${bottom_height}! \) 


# Add labels to the bottom images and sizes
magick Barcode02_chr17_chr15_fusion.ribbon.png -resize ${bottom_width}x${bottom_height}! -gravity NorthWest -font "${FONT}" -pointsize $POINTSIZE -annotate +30+10 'B' Barcode02_chr17_chr15_fusion.ribbon.labelled.png
magick Barcode06_chr17_chr15_fusion.ribbon.png  -resize ${bottom_width}x${bottom_height}! -gravity NorthWest -font "${FONT}" -pointsize $POINTSIZE -annotate +30+10 'C' Barcode06_chr17_chr15_fusion.ribbon.labelled.png 
# Append the bottom row together horizontally
#
magick \( Barcode02_chr17_chr15_fusion.ribbon.labelled.png \) \( Barcode06_chr17_chr15_fusion.ribbon.labelled.png \) +append bottom_row.png
magick -page 836x1048 samplot_output/figure_4_prom_labelled.png bottom_row.png  -append Supplemental_Fig_S3.pdf
