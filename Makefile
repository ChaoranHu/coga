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
	sed 's/^Version: [0-9]\.[0-9]\.[0-9]\.*[0-9]*[0-9]*[0-9]*[0-9]*/Version: '$$NEWVER'/' DESCRIPTION >> description_tem;\
	sed 's/version [0-9]\.[0-9]\.[0-9]\.*[0-9]*[0-9]*[0-9]*[0-9]*/version '$$NEWVER'/g' inst/CITATION >> inst/citation_tem;\
	sed 's/Version: [0-9]\.[0-9]\.[0-9]\.*[0-9]*[0-9]*[0-9]*[0-9]*/Version: '$$NEWVER'/' README.md >> README_tem;\
	sed 's/], [0-9]\.[0-9]\.[0-9]\.*[0-9]*[0-9]*[0-9]*[0-9]*/], '$$NEWVER'/' configure.ac >> configure_tem

	@mv description_tem DESCRIPTION
	@mv inst/citation_tem inst/CITATION
	@mv README_tem README.md
	@mv configure_tem configure.ac
	@rm configure
	@autoconf
	@rm -rf autom4te.cache/
	@echo "NEWS.md and cran-comment should be modified manually."


.PHONY: updateTime
updateTime:
	@echo "updating date"
	@sed 's/Date: [0-9]\{4\}-[0-9]\{1,2\}-[0-9]\{1,2\}/Date: $(dt)/' DESCRIPTION >> description_tem
	@mv description_tem DESCRIPTION
	@sed 's/Copyright (C) 2017-[0-9]\{4\}/Copyright (C) 2017-$(yr)/' COPYRIGHT >> copyright_tem
	@mv copyright_tem COPYRIGHT
	@sed 's/20[0-9]\{2\}/$(yr)/g' inst/CITATION >> inst/citation_tem
	@mv inst/citation_tem inst/CITATION


.PHONY: clean
clean:
	rm -rf *~ */*~ *.Rhistroy *.tar.gz *.Rcheck/ .\#* src/*.so src/*.o vignettes/*.html
	rm -rf config.log config.status src/Makevars autom4te.cache/
