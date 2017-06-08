Parsing codemeta data
================

``` r
library(jsonld)
library(jsonlite)
library(magrittr)
library(codemetar)
library(tidyverse)
library(printr)
```

``` r
write_codemeta("codemetar", "codemeta.json")
```

Digest input with a frame:

``` r
frame <- system.file("schema/frame_schema.json", package="codemetar")

meta <- 
  jsonld_frame("codemeta.json", frame) %>%
  fromJSON(FALSE) %>% getElement("@graph") %>% getElement(1)
```

Construct a citation

``` r
authors <- 
lapply(meta$author, 
       function(author) 
         person(given = author$given, 
                family = author$family, 
                email = author$email,
                role = "aut"))
year <- meta$datePublished
if(is.null(year)) 
  year <- format(Sys.Date(), "%Y")
bibitem <- 
 bibentry(
     bibtype = "Manual",
     title = meta$name,
     author = authors,
     year = year,
     note = paste0("R package version ", meta$version),
     url = meta$URL,
     key = meta$identifier
   )

cat(format(bibitem, "bibtex"))
```

    ## @Manual{codemetar,
    ##   title = {codemetar: Generate CodeMeta Metadata for R Packages},
    ##   author = {Carl Boettiger},
    ##   year = {2017},
    ##   note = {R package version 0.1.0},
    ## }

``` r
bibitem
```

    ## Boettiger C (2017). _codemetar: Generate CodeMeta Metadata for R
    ## Packages_. R package version 0.1.0.

Parsing the ropensci corpus
---------------------------

Frame, expanding any referenced nodes

``` r
corpus <- 
    jsonld_frame("ropensci.json", frame) %>%
    fromJSON(simplifyVector = FALSE) %>%
    getElement("@graph") 
```

Some basics:

``` r
## deal with nulls explicitly by starting with map
pkgs <- map(corpus, "name") %>% compact() %>% as.character()

# keep only those with package identifiers (names)
keep <- map_lgl(corpus, ~ length(.x$identifier) > 0)
corpus <- corpus[keep]

## now we can just do
all_pkgs <- map_chr(corpus, "name")
head(all_pkgs)
```

    ## [1] "AntWeb: programmatic interface to the AntWeb"                                
    ## [2] "aRxiv: Interface to the arXiv API"                                           
    ## [3] "chromer: Interface to Chromosome Counts Database API"                        
    ## [4] "ckanr: Client for the Comprehensive Knowledge Archive Network ('CKAN') 'API'"
    ## [5] "dashboard: A package status dashboard"                                       
    ## [6] "ggit: Git Graphics"

``` r
## 60 unique maintainers
map_chr(corpus, c("maintainer", "familyName")) %>% unique() %>% length()
```

    ## [1] 61

``` r
## Mostly Scott
map_chr(corpus, c("maintainer", "familyName")) %>% 
  as_tibble() %>%
  group_by(value) %>%
  tally(sort=TRUE)
```

| value        |    n|
|:-------------|----:|
| Chamberlain  |  105|
| Ooms         |   12|
| Mullen       |    8|
| Ram          |    8|
| Boettiger    |    6|
| Salmon       |    5|
| FitzJohn     |    4|
| Hart         |    2|
| Leeper       |    2|
| Marwick      |    2|
| Müller       |    2|
| Padgham      |    2|
| South        |    2|
| Varela       |    2|
| Vitolo       |    2|
| Arnold       |    1|
| Attali       |    1|
| Banbury      |    1|
| Becker       |    1|
| Bengtsson    |    1|
| Braginsky    |    1|
| Broman       |    1|
| Bryan        |    1|
| Dallas       |    1|
| de Queiroz   |    1|
| Drost        |    1|
| Fischetti    |    1|
| Ghahraman    |    1|
| Goring       |    1|
| hackathoners |    1|
| Harrison     |    1|
| Hughes       |    1|
| Jahn         |    1|
| Jones        |    1|
| Keyes        |    1|
| Krah         |    1|
| Lehtomaki    |    1|
| Lovelace     |    1|
| Lundstrom    |    1|
| McGlinn      |    1|
| McVey        |    1|
| Meissner     |    1|
| Michonneau   |    1|
| Moroz        |    1|
| Otegui       |    1|
| Pardo        |    1|
| Pennell      |    1|
| Poelen       |    1|
| Robinson     |    1|
| Ross         |    1|
| Rowlingson   |    1|
| Scott        |    1|
| Seers        |    1|
| Shotwell     |    1|
| Sievert      |    1|
| Sparks       |    1|
| Stachelek    |    1|
| Szöcs        |    1|
| Widgren      |    1|
| Wiggin       |    1|
| Winter       |    1|

``` r
## number of co-authors ... 
map_int(corpus, function(r) length(r$author)) %>% 
  as_tibble() %>%
  group_by(value) %>%
  tally(sort=TRUE)
```

|  value|    n|
|------:|----:|
|      1|  146|
|      2|   30|
|      3|   17|
|      4|    8|
|      5|    5|
|      7|    3|
|     13|    1|

``` r
## Contributors isn't used as much...
map_int(corpus, function(r) length(r$contributor)) %>% 
  as_tibble() %>%
  group_by(value) %>%
  tally(sort=TRUE)
```

|  value|    n|
|------:|----:|
|      0|  178|
|      2|   13|
|      4|    9|
|      3|    7|
|      5|    1|
|      6|    1|
|      8|    1|

Numbers (n) of packages with a total of (value) dependencies:

``` r
map_int(corpus, function(r) length(r$softwareRequirements))  %>% 
  as_tibble() %>%
  group_by(value) %>%
  tally(sort=TRUE)
```

|  value|    n|
|------:|----:|
|      4|   39|
|      5|   35|
|      2|   25|
|      3|   25|
|      7|   19|
|      6|   16|
|      8|   13|
|      9|    8|
|     12|    7|
|     10|    6|
|     11|    6|
|     13|    3|
|      0|    2|
|     14|    1|
|     17|    1|
|     18|    1|
|     21|    1|
|     22|    1|
|     23|    1|

which dependencies are used most frequently?

``` r
corpus %>%
map_df(function(x){
  ## single, unboxed dep
  if("name" %in% names(x$softwareRequirements))
    dep <- x$name
  else if("name" %in% names(x$softwareRequirements[[1]]))
    dep <- map_chr(x$softwareRequirements, "name")
  else { ## No requirementsß
    dep <- NA
  }
  
  tibble(identifier = x$identifier, dep = dep)
}) -> dep_df


dep_df %>%
group_by(dep) %>% 
  tally(sort = TRUE)
```

| dep                                                              |    n|
|:-----------------------------------------------------------------|----:|
| jsonlite                                                         |   99|
| httr                                                             |   92|
| R                                                                |   66|
| tibble                                                           |   46|
| dplyr                                                            |   43|
| methods                                                          |   37|
| xml2                                                             |   37|
| data.table                                                       |   35|
| utils                                                            |   35|
| crul                                                             |   31|
| plyr                                                             |   29|
| XML                                                              |   25|
| magrittr                                                         |   24|
| sp                                                               |   22|
| stringr                                                          |   21|
| curl                                                             |   18|
| ggplot2                                                          |   18|
| lazyeval                                                         |   17|
| stats                                                            |   17|
| lubridate                                                        |   14|
| R6                                                               |   14|
| rappdirs                                                         |   13|
| assertthat                                                       |   12|
| digest                                                           |   12|
| RCurl                                                            |   12|
| readr                                                            |   11|
| rgdal                                                            |   10|
| whisker                                                          |   10|
| scales                                                           |    9|
| ape                                                              |    8|
| raster                                                           |    8|
| tidyr                                                            |    8|
| Rcpp                                                             |    7|
| reshape2                                                         |    7|
| rvest                                                            |    7|
| rgeos                                                            |    6|
| V8                                                               |    6|
| hoardr                                                           |    5|
| rjson                                                            |    5|
| taxize                                                           |    5|
| tools                                                            |    5|
| git2r                                                            |    4|
| maps                                                             |    4|
| oai                                                              |    4|
| openssl                                                          |    4|
| R(&gt;=3.2.1)                                                    |    4|
| solrium                                                          |    4|
| urltools                                                         |    4|
| foreach                                                          |    3|
| knitr                                                            |    3|
| leaflet                                                          |    3|
| maptools                                                         |    3|
| memoise                                                          |    3|
| mime                                                             |    3|
| pdftools                                                         |    3|
| purrr                                                            |    3|
| RColorBrewer                                                     |    3|
| rgbif                                                            |    3|
| rmarkdown                                                        |    3|
| shiny                                                            |    3|
| spocc                                                            |    3|
| stringi                                                          |    3|
| uuid                                                             |    3|
| wicket                                                           |    3|
| yaml                                                             |    3|
| base64enc                                                        |    2|
| bibtex                                                           |    2|
| Biostrings                                                       |    2|
| crayon                                                           |    2|
| devtools                                                         |    2|
| downloader                                                       |    2|
| fauxpas                                                          |    2|
| gdata                                                            |    2|
| gistr                                                            |    2|
| graphics                                                         |    2|
| grid                                                             |    2|
| htmltools                                                        |    2|
| htmlwidgets                                                      |    2|
| httpcode                                                         |    2|
| igraph                                                           |    2|
| jqr                                                              |    2|
| MASS                                                             |    2|
| miniUI                                                           |    2|
| ncdf4                                                            |    2|
| png                                                              |    2|
| R.cache                                                          |    2|
| R.utils                                                          |    2|
| rcrossref                                                        |    2|
| rentrez                                                          |    2|
| reshape                                                          |    2|
| rmapshaper                                                       |    2|
| rplos                                                            |    2|
| rvertnet                                                         |    2|
| shinyjs                                                          |    2|
| storr                                                            |    2|
| tm                                                               |    2|
| NA                                                               |    2|
| analogue                                                         |    1|
| antiword: Extract Text from Microsoft Word Documents             |    1|
| apipkgen: Package Generator for HTTP API Wrapper Packages        |    1|
| appl: Approximate POMDP Planning Software                        |    1|
| aRxiv                                                            |    1|
| binman                                                           |    1|
| Biobase                                                          |    1|
| BiocGenerics                                                     |    1|
| biomaRt                                                          |    1|
| bold                                                             |    1|
| caTools                                                          |    1|
| ckanr                                                            |    1|
| cld2: Google's Compact Language Detector 2                       |    1|
| countrycode                                                      |    1|
| cranlogs                                                         |    1|
| crminer                                                          |    1|
| crosstalk                                                        |    1|
| DBI                                                              |    1|
| dirdf: Extracts Metadata from Directory and File Names           |    1|
| doParallel                                                       |    1|
| DT(&gt;=0.1)                                                     |    1|
| elastic                                                          |    1|
| EML                                                              |    1|
| fastmatch                                                        |    1|
| foreign                                                          |    1|
| functionMap                                                      |    1|
| genderdata: Historical Datasets for Predicting Gender from Names |    1|
| GenomeInfoDb                                                     |    1|
| GenomicFeatures                                                  |    1|
| GenomicRanges(&gt;=1.23.24)                                      |    1|
| geoaxe                                                           |    1|
| geojson                                                          |    1|
| geojsonrewind: Fix 'GeoJSON' Winding Direction                   |    1|
| geonames                                                         |    1|
| geoops: 'GeoJSON' Manipulation Operations                        |    1|
| geosphere                                                        |    1|
| getPass                                                          |    1|
| ggm                                                              |    1|
| ggmap                                                            |    1|
| ggthemes                                                         |    1|
| graphql                                                          |    1|
| grDevices                                                        |    1|
| gridExtra                                                        |    1|
| gtools                                                           |    1|
| hash                                                             |    1|
| hexbin                                                           |    1|
| historydata: Data Sets for Historians                            |    1|
| Hmisc                                                            |    1|
| httpuv                                                           |    1|
| IRanges                                                          |    1|
| isdparser                                                        |    1|
| jsonvalidate                                                     |    1|
| jsonvalidate: Validate 'JSON'                                    |    1|
| leafletR                                                         |    1|
| loggr                                                            |    1|
| mapproj                                                          |    1|
| markdown                                                         |    1|
| Matrix                                                           |    1|
| memisc                                                           |    1|
| miniUI(&gt;=0.1.1)                                               |    1|
| nabor                                                            |    1|
| natserv                                                          |    1|
| openxlsx                                                         |    1|
| osmar                                                            |    1|
| outliers                                                         |    1|
| pdftools: Text Extraction and Rendering of PDF Documents         |    1|
| phytools                                                         |    1|
| plotly                                                           |    1|
| plumber                                                          |    1|
| progress                                                         |    1|
| protolite                                                        |    1|
| qlcMatrix                                                        |    1|
| RApiSerialize                                                    |    1|
| rapport                                                          |    1|
| rbhl                                                             |    1|
| rbison                                                           |    1|
| rebird                                                           |    1|
| redland                                                          |    1|
| redux                                                            |    1|
| remotes                                                          |    1|
| ridigbio                                                         |    1|
| ritis                                                            |    1|
| rJava                                                            |    1|
| RJSONIO                                                          |    1|
| rlist                                                            |    1|
| Rmpfr                                                            |    1|
| RMySQL                                                           |    1|
| rncl                                                             |    1|
| rnoaa                                                            |    1|
| rnrfa                                                            |    1|
| rotl                                                             |    1|
| rowr                                                             |    1|
| RPostgreSQL                                                      |    1|
| rredis                                                           |    1|
| rredlist                                                         |    1|
| RSQLite                                                          |    1|
| rstudioapi(&gt;=0.5)                                             |    1|
| rtracklayer                                                      |    1|
| rworldmap                                                        |    1|
| rzmq: R Bindings for ZeroMQ                                      |    1|
| S4Vectors                                                        |    1|
| scrapeR                                                          |    1|
| selectr                                                          |    1|
| sf                                                               |    1|
| shiny(&gt;=0.13.2)                                               |    1|
| snow                                                             |    1|
| SnowballC                                                        |    1|
| spatstat                                                         |    1|
| SSOAP                                                            |    1|
| stringdist                                                       |    1|
| sys                                                              |    1|
| tabulizerjars                                                    |    1|
| testthat                                                         |    1|
| tif: Text Interchange Format                                     |    1|
| USAboundariesData: Datasets for the 'USAboundaries' package      |    1|
| VariantAnnotation                                                |    1|
| viridisLite                                                      |    1|
| wdman(&gt;=0.2.2)                                                |    1|
| wellknown                                                        |    1|
| wicket: Utilities to Handle WKT Spatial Data                     |    1|
| WikidataR                                                        |    1|
| wikitaxa                                                         |    1|
| withr                                                            |    1|
| worrms                                                           |    1|
| xslt: XSLT 1.0 Transformations                                   |    1|
| zoo                                                              |    1|

Alternate approach using a frame, gets all Depends and suggests (really all `SoftwareApplication` types mentioned)

``` r
dep_frame <- '{
  "@context": "https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta.jsonld",
  "@explicit": "true",
  "name": {}
}'
jsonld_frame("ropensci.json", dep_frame) %>% 
  fromJSON() %>% 
  getElement("@graph") %>%
  filter(type == "SoftwareApplication") %>%
  group_by(name) %>% 
  tally(sort = TRUE)
```

| name                        |    n|
|:----------------------------|----:|
| testthat                    |  168|
| knitr                       |  122|
| jsonlite                    |  105|
| httr                        |   96|
| roxygen2                    |   92|
| R                           |   72|
| rmarkdown                   |   68|
| covr                        |   52|
| dplyr                       |   49|
| tibble                      |   48|
| xml2                        |   41|
| methods                     |   38|
| utils                       |   37|
| data.table                  |   36|
| ggplot2                     |   36|
| crul                        |   33|
| plyr                        |   32|
| magrittr                    |   28|
| sp                          |   26|
| XML                         |   25|
| curl                        |   21|
| stringr                     |   21|
| lazyeval                    |   18|
| stats                       |   18|
| lubridate                   |   16|
| R6                          |   14|
| readr                       |   14|
| rgdal                       |   14|
| rappdirs                    |   13|
| assertthat                  |   12|
| devtools                    |   12|
| digest                      |   12|
| raster                      |   12|
| RCurl                       |   12|
| scales                      |   12|
| Rcpp                        |   11|
| whisker                     |   11|
| leaflet                     |   10|
| rgeos                       |   10|
| taxize                      |   10|
| tidyr                       |   10|
| reshape2                    |    9|
| ape                         |    8|
| maps                        |    8|
| V8                          |    8|
| maptools                    |    7|
| purrr                       |    7|
| rvest                       |    7|
| pdftools                    |    6|
| rgbif                       |    6|
| shiny                       |    6|
| ggmap                       |    5|
| git2r                       |    5|
| hoardr                      |    5|
| ncdf4                       |    5|
| png                         |    5|
| rjson                       |    5|
| tools                       |    5|
| oai                         |    4|
| openssl                     |    4|
| R(&gt;=3.2.1)               |    4|
| rcrossref                   |    4|
| RSQLite                     |    4|
| sf                          |    4|
| solrium                     |    4|
| urltools                    |    4|
| uuid                        |    4|
| yaml                        |    4|
| DBI                         |    3|
| fauxpas                     |    3|
| foreach                     |    3|
| gdata                       |    3|
| gistr                       |    3|
| graphics                    |    3|
| lintr                       |    3|
| MASS                        |    3|
| memoise                     |    3|
| mime                        |    3|
| miniUI                      |    3|
| R.utils                     |    3|
| RColorBrewer                |    3|
| rentrez                     |    3|
| rmapshaper                  |    3|
| rvertnet                    |    3|
| rworldmap                   |    3|
| spocc                       |    3|
| stringi                     |    3|
| wicket                      |    3|
| base64enc                   |    2|
| bibtex                      |    2|
| Biostrings                  |    2|
| broom                       |    2|
| crayon                      |    2|
| downloader                  |    2|
| elastic                     |    2|
| geiger                      |    2|
| getPass                     |    2|
| GGally                      |    2|
| ggthemes                    |    2|
| grDevices                   |    2|
| grid                        |    2|
| gridExtra                   |    2|
| htmltools                   |    2|
| htmlwidgets                 |    2|
| httpcode                    |    2|
| igraph                      |    2|
| jqr                         |    2|
| jsonvalidate                |    2|
| listviewer                  |    2|
| mapproj                     |    2|
| Matrix                      |    2|
| phylobase                   |    2|
| phytools                    |    2|
| R.cache                     |    2|
| RcppRedis                   |    2|
| readxl                      |    2|
| remotes                     |    2|
| reshape                     |    2|
| rplos                       |    2|
| shinyjs                     |    2|
| storr                       |    2|
| sys                         |    2|
| tm                          |    2|
| viridis                     |    2|
| webp                        |    2|
| zoo                         |    2|
| akima                       |    1|
| analogue                    |    1|
| aRxiv                       |    1|
| binman                      |    1|
| Biobase                     |    1|
| BiocGenerics                |    1|
| biomaRt                     |    1|
| bold                        |    1|
| Cairo                       |    1|
| caTools                     |    1|
| ckanr                       |    1|
| corrplot                    |    1|
| countrycode                 |    1|
| cranlogs                    |    1|
| crminer                     |    1|
| crosstalk                   |    1|
| dendextend                  |    1|
| doParallel                  |    1|
| dplyr(&gt;=0.3.0.2)         |    1|
| DT(&gt;=0.1)                |    1|
| EML                         |    1|
| etseed                      |    1|
| fastmatch                   |    1|
| fields                      |    1|
| forecast                    |    1|
| foreign                     |    1|
| fulltext                    |    1|
| functionMap                 |    1|
| genderdata                  |    1|
| GenomeInfoDb                |    1|
| GenomicFeatures             |    1|
| GenomicRanges(&gt;=1.23.24) |    1|
| geoaxe                      |    1|
| geojson                     |    1|
| geojsonio                   |    1|
| geojsonlint                 |    1|
| geonames                    |    1|
| geosphere                   |    1|
| ggalt                       |    1|
| ggm                         |    1|
| graphql                     |    1|
| GSODR                       |    1|
| gtools                      |    1|
| hash                        |    1|
| hexbin                      |    1|
| historydata                 |    1|
| Hmisc                       |    1|
| httpuv                      |    1|
| IRanges                     |    1|
| IRdisplay                   |    1|
| isdparser                   |    1|
| janeaustenr                 |    1|
| jpeg                        |    1|
| knitcitations               |    1|
| leafletR                    |    1|
| loggr                       |    1|
| magick                      |    1|
| mapdata                     |    1|
| markdown                    |    1|
| MCMCglmm                    |    1|
| memisc                      |    1|
| miniUI(&gt;=0.1.1)          |    1|
| mongolite                   |    1|
| nabor                       |    1|
| natserv                     |    1|
| openair                     |    1|
| openxlsx                    |    1|
| osmar                       |    1|
| outliers                    |    1|
| pander                      |    1|
| parallel                    |    1|
| plot3D                      |    1|
| plotKML                     |    1|
| plotly                      |    1|
| plumber                     |    1|
| progress                    |    1|
| protolite                   |    1|
| purrrlyr                    |    1|
| qlcMatrix                   |    1|
| RApiSerialize               |    1|
| rapport                     |    1|
| rbhl                        |    1|
| rbison                      |    1|
| rcdk                        |    1|
| Rcompression                |    1|
| readtext                    |    1|
| rebird                      |    1|
| RedisAPI                    |    1|
| redland                     |    1|
| redux                       |    1|
| reeack                      |    1|
| rfigshare                   |    1|
| ridigbio                    |    1|
| rinat                       |    1|
| ritis                       |    1|
| rJava                       |    1|
| RJSONIO                     |    1|
| rlist                       |    1|
| Rmpfr                       |    1|
| RMySQL                      |    1|
| rnaturalearthdata           |    1|
| rnaturalearthhires          |    1|
| rncl                        |    1|
| RNeXML                      |    1|
| rnoaa                       |    1|
| rnrfa                       |    1|
| ropenaq                     |    1|
| rotl                        |    1|
| rowr                        |    1|
| RPostgreSQL                 |    1|
| rrdf                        |    1|
| rredis                      |    1|
| rredlist                    |    1|
| rrlite                      |    1|
| RSclient                    |    1|
| RSelenium                   |    1|
| Rserve                      |    1|
| rstudioapi(&gt;=0.5)        |    1|
| rsvg                        |    1|
| rtracklayer                 |    1|
| RUnit                       |    1|
| S4Vectors                   |    1|
| sangerseqR                  |    1|
| scrapeR                     |    1|
| selectr                     |    1|
| seqinr                      |    1|
| shiny(&gt;=0.13.2)          |    1|
| snow                        |    1|
| SnowballC                   |    1|
| sofa                        |    1|
| spacetime                   |    1|
| spatstat                    |    1|
| SSOAP                       |    1|
| stringdist                  |    1|
| Suggests:testthat           |    1|
| Sxslt                       |    1|
| tabulizerjars               |    1|
| testthat(&gt;=0.7)          |    1|
| tidytext                    |    1|
| tidyverse                   |    1|
| tiff                        |    1|
| tmap                        |    1|
| USAboundaries               |    1|
| USAboundariesData           |    1|
| VariantAnnotation           |    1|
| vegan                       |    1|
| viridisLite                 |    1|
| wdman(&gt;=0.2.2)           |    1|
| weathermetrics              |    1|
| webmockr                    |    1|
| webshot                     |    1|
| wellknown                   |    1|
| WikidataR                   |    1|
| wikitaxa                    |    1|
| withr                       |    1|
| wordcloud2                  |    1|
| worrms                      |    1|
| XMLSchema                   |    1|
| xtable                      |    1|
| xts                         |    1|

``` r
#  summarise(count(name))
```
