
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hmtp

<!-- badges: start -->

<!-- badges: end -->

The goal of hmtp is to prepare templates for homology modeling. This
package can pick out less than 5 best protein sequences that can do
homology modling with target sequence as templates from given database
based on pairwise alignment. The alignment files for picked templates
and target protein, and pdb file of templates are generated/downloaded
to users for homology modeling. This package also provide a rough
visualization of how similar two provided aligned proteins are in both
1D and 3D. The highlight of this package is that currently there is no R
package which can generate 3D alignment structure of given proteins
which is a indeed helpful visualization for homology modeling and other
bioinformatics work flow after paiwise alignments.

## Installation

You can install the released version of hmtp from github with:

``` r
library(devtools)
install_github("MichelleMengzhi/hmtp")
library(hmtp)
```

To run the shinyApp:

``` r
runHmtp()
```

## Overview

``` r
browseVignettes("hmtp") 
```

![](./inst/extdata/hmtp.png)

This package contains two main functions: **selectTemplates** which
selects templates for the target in the later homology modeling and gets
their pdb files and alignment file, **alignment3dVisualization** whcih
provides a visualization of how similar the template and target
sequences are in 3D, helper functions *crossReferenceList*,
*GetPdbFileGenerator*, *pathGeneratorMovement*, which contribute in main
functions but can also be used separately.

## Contrbutions

``` r
lsf.str("package:hmtp")
```

The author of the package is Yuexin Yu.

In **selectTemplates** function,
[Biostrings](https://www.bioconductor.org/packages/devel/bioc/manuals/Biostrings/man/Biostrings.pdf),
[DECIPHER](https://bioconductor.org/packages/release/bioc/html/DECIPHER.html)
packages are imported for capturing protein sequences from fasta file
and 1D visualization respectively. Yuexin Yu built up the filter to
capture information for pairwise alignment, the html download of
selected pdb files, and the generation of alignment files for later
homology modeling.

In **alignment3dVisualization** function,
[rgl](https://cran.r-project.org/web/packages/rgl/rgl.pdf) package is
used to help to generate a line plot graph. Yuexin Yu built up the
filter to capture the xyz coordinates from the input and output a 3D
image which plots two set of data and line all points all to generate a
rough 3D structure of proteins.

## Example

You can use example data in the package with the following code

``` r
selectTemplates("targetExample.fasta", "databaseExample.fasta", "databaseExample.txt")
```

which generates tio 5 pairwise sequence alignments and visualization of
the first argument as the target sequence and the second argument as the
protein database.

``` r
alignment3dVisulization("align.pdb", "4GSA", "5TE2")
```

which generates a quick 3D visualization of the alignment of the second
and third arguments

## References

H. Pages, et al. Efficient manipulation of biological strings. Rereieved
from
<https://www.bioconductor.org/packages/devel/bioc/manuals/Biostrings/man/Biostrings.pdf>

E. Wright. DECIPHER. Retrieved from
<https://bioconductor.org/packages/release/bioc/html/DECIPHER.html>

D. Adler, et al. 3D Visualization Using OpeGL. Retreived from
<https://cran.r-project.org/web/packages/rgl/rgl.pdf>
