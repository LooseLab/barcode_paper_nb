#!/bin/bash
FONT="JetBrainsMono-Regular.ttf"
POINTSIZE=66

magick  figure_4_prom_nb4_only.png -gravity NorthWest -font "${FONT}" -pointsize $POINTSIZE -annotate +30+10 'A' figure_4_prom_nb4_only.labelled.png
# First, get the width and height of the top image
read top_width top_height <<< $(magick identify -format "%w %h" figure_4_prom_nb4_only.png)

# Calculate width and height for the bottom images
bottom_width=$((top_width / 2))
bottom_height=$((top_height))

# Resize bottom row
#magick \( Barcode02_chr17_chr15_fusion.ribbon.png -resize ${bottom_width}x${bottom_height}! \) 
#        \( Barcode06_chr17_chr15_fusion.ribbon.png -resize ${bottom_width}x${bottom_height}! \) 


# Add labels to the bottom images and sizes
magick /home/adoni5/Projects/Readfish-2.0-Paper/barcode_paper_nb/figure_3_supp_figure_3/cuteSVoutput/barcode06.pdf -resize ${bottom_width}x${bottom_height}! -gravity NorthWest -font "${FONT}" -pointsize $POINTSIZE -annotate +30+10 'B' Barcode02_chr17_chr15_fusion.ribbon.labelled.pdf

#magick Barcode06_chr17_chr15_fusion.ribbon.png  -resize ${bottom_width}x${bottom_height}! -gravity NorthWest -font "${FONT}" -pointsize $POINTSIZE -annotate +30+10 'C' Barcode06_chr17_chr15_fusion.ribbon.labelled.png 
# Append the bottom row together horizontally
#
magick \( Barcode02_chr17_chr15_fusion.ribbon.labelled.png \) +append bottom_row.png
magick -page ${bottom_width}x$((bottom_height * 2)) figure_4_prom_nb4_only.labelled.png cuteSVoutput/barcode06.pdf  -append Supplemental_Fig_S3.jpg
