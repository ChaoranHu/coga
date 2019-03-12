objects := $(wildcard R/*.R) DESCRIPTION
dir := $(shell pwd)
version := $(shell grep "Version" DESCRIPTION | sed "s/Version: //")
pkg := $(shell grep "Package" DESCRIPTION | sed "s/Package: //")
tar := $(pkg)_$(version).tar.gz
tests := $(wildcard tests/testthat/*.R)
checkLog := $(pkg).Rcheck/00check.log

yr := $(shell date +"%Y")
dt := $(shell date +"%Y-%m-%d")


.PHONY: check
check: $(checkLog)

.PHONY: build
build: $(tar)

.PHONY: install
install: $(tar)
	R CMD INSTALL $(tar)


$(tar): $(objects)
	@make -s updateTime
	Rscript -e "library(methods); devtools::document();"
	R CMD build $(dir)

$(checkLog): $(tar) $(tests)
	R CMD check --as-cran $(tar)


.PHONY: newVersion
newVersion:
	@read -p "new version number: " NEWVER;\
	gsed -i 's/^Version: [0-9]\.[0-9]\.[0-9]\.*[0-9]*[0-9]*[0-9]*[0-9]*/Version: '$$NEWVER'/' DESCRIPTION;\
	gsed -i 's/version [0-9]\.[0-9]\.[0-9]\.*[0-9]*[0-9]*[0-9]*[0-9]*/version '$$NEWVER'/g' inst/CITATION;\
	gsed -i 's/Version: [0-9]\.[0-9]\.[0-9]\.*[0-9]*[0-9]*[0-9]*[0-9]*/Version: '$$NEWVER'/' README.md;\
	gsed -i 's/], [0-9]\.[0-9]\.[0-9]\.*[0-9]*[0-9]*[0-9]*[0-9]*/], '$$NEWVER'/' configure.ac

	@rm configure
	@autoconf
	@rm -rf autom4te.cache/
	@echo "NEWS.md and cran-comment should be modified manually."


.PHONY: updateTime
updateTime:
	@echo "updating date"
	@gsed -i 's/Date: [0-9]\{4\}-[0-9]\{1,2\}-[0-9]\{1,2\}/Date: $(dt)/' DESCRIPTION
	@gsed -i 's/Copyright (C) 2017-[0-9]\{4\}/Copyright (C) 2017-$(yr)/' COPYRIGHT
	@gsed -i '3,16 s/20[0-9]\{2\}/$(yr)/' inst/CITATION


.PHONY: clean
clean:
	rm -rf *~ */*~ *.Rhistroy *.tar.gz *.Rcheck/ .\#* src/*.so src/*.o vignettes/*.html
	rm -rf config.log config.status src/Makevars autom4te.cache/
