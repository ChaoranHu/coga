## Test enviroments

* local macOS 10.14.6 install, R 3.5.0

* win-builder (devel and release)

* ubuntu 16.04.6 LTS (on travis-ci), (devel, release, and oldrel)


## R CMD check results

```
* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Chaoran Hu <chaoran.hu@uconn.edu>’

Found the following (possibly) invalid DOIs:
  DOI: 10.1007/s00180-019-00924-9
    From: DESCRIPTION
          inst/CITATION
    Status: Not Found
    Message: 404
```

Actually, this paper we adds to the citation file is a to-appear paper, which
has been accepted and has been assigned this DOI. It may take some time to be
published formally. We want to include it in this update of package.



## Downstream dependencies

There are currently no downstream dependencies for this package.


## Newer Version of R package coga

The R package coga 1.1.0 has already in CRAN. This is the next version of coga. The version number of this package is 1.1.0.9000.
