README
===

This is the companion repo for the preprint [Barcode aware adaptive sampling for Oxford Nanopore sequencers][1].
It contains the data and code required for reproducing the figures and some of the analysis done.


Figures contained in the unused directory were used in the initial pre-print but not in the updated manuscript.

Some directories, which do not contain a jupyter notebook to generate images, should ocntain a README explaining how to generate the image.
### Setting up the environment

The minimal environment required to run these notebooks is specified in the [`environment.yml`][2] file.
To create the environment use [conda][3] (or [mamba][4]) like so:

```bash
git clone https://github.com/LooseLab/barcode_paper_nb
cd barcode_paper_nb
conda env create -f environment.yml
conda activate rf_barcode_nb
```


 [1]: https://doi.org/10.1101/2021.12.01.470722
 [2]: environment.yml
 [3]: https://docs.conda.io/en/latest/miniconda.html
 [4]: https://github.com/mamba-org/mamba