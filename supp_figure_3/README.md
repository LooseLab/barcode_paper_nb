```bash 
time python -m samplot plot     -n "GridION NA12878" "GridION NB4" "GridION 22Rv1" "PromethION NA12878" "PromethION NB4" "Promethion 22Rv1" -b barcode01_sort.bam barcode02_sort.bam barcode03_sort.bam all_barcode05.unblocked.fastq.bam all_barcode06.sequenced.fastq.bam all_barcode07.sequenced.fastq.bam -o figure_4_prom.png -c chr15 -s 74020000 -e 74020001 -c chr17 -e 40345002 -s 40345001 --zoom 50000 -t BND
```

Command run on all the bam files to draw samplot

Genome ribbon was used genomeribbon.com

With cuteSV vcf output.

MUST BE RUN ON CHROME

Then when all images are in the directory run 
```bash
./concatenate_figure.sh
```
