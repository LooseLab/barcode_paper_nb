#!/bin/sh

# Use imagemagick to create this figure

# Add row lables
convert A_a.png -font Arial -pointsize 180 -gravity northwest -annotate +50+50 "A" A_a_lab.png
convert B_a.png -font Arial -pointsize 180 -gravity northwest -annotate +50+50 "B" B_a_lab.png
convert C_a.png -font Arial -pointsize 180 -gravity northwest -annotate +50+50 "C" C_a_lab.png

# Create rows
convert A_a_lab.png A_b.png A_c.png -gravity center +append row_A.png
convert B_a_lab.png B_b.png B_c.png -gravity center +append row_B.png
convert C_a_lab.png C_b.png C_c.png -gravity center +append row_C.png

# Append rows for final figure
convert -append row_*.png figure_4.png