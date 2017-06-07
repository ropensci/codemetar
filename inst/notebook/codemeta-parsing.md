Parsing codemeta data
================

``` r
library(jsonld)
library(jsonlite)
library(magrittr)
library(codemetar)
library(tidyverse)
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
map_chr(corpus, "name")
```

    ##   [1] "AntWeb: programmatic interface to the AntWeb"                                                            
    ##   [2] "aRxiv: Interface to the arXiv API"                                                                       
    ##   [3] "chromer: Interface to Chromosome Counts Database API"                                                    
    ##   [4] "ckanr: Client for the Comprehensive Knowledge Archive Network ('CKAN') 'API'"                            
    ##   [5] "dashboard: A package status dashboard"                                                                   
    ##   [6] "ggit: Git Graphics"                                                                                      
    ##   [7] "musemeta: Client for Scraping Museum Metadata"                                                           
    ##   [8] "rdpla: Client for the Digital Public Library of America ('DPLA')"                                        
    ##   [9] "rerddap: General Purpose Client for 'ERDDAP' Servers"                                                    
    ##  [10] "EML: Read and Write Ecological Metadata Language Files"                                                  
    ##  [11] "reuropeana: Interface to 'Europeana' 'APIs'"                                                             
    ##  [12] "rGEM: Access data from Global Entrepreneurship Monitor (GEM) project"                                    
    ##  [13] "taxizesoap: Taxonomic Information from Around the Soap Web"                                              
    ##  [14] "webmockr: Stubbing and Setting Expectations on 'HTTP' Requests"                                          
    ##  [15] "binomen: 'Taxonomic' Specification and Parsing Methods"                                                  
    ##  [16] "cartographer: Interactive Maps for Data Exploration"                                                     
    ##  [17] "seasl: Parse Citation Style Language (CSL) Texts"                                                        
    ##  [18] "elasticdsl: Elasticsearch DSL"                                                                           
    ##  [19] "etseed: Client for 'etcd', a 'Key-value' Database"                                                       
    ##  [20] "finch: Parse Darwin Core Files"                                                                          
    ##  [21] "genderdata: Historical Datasets for Predicting Gender from Names"                                        
    ##  [22] "hathi: An R client for HathiTrust API"                                                                   
    ##  [23] "internetarchive: An API Client for the Internet Archive"                                                 
    ##  [24] "fulltext: Full Text of 'Scholarly' Articles Across Many Data Sources"                                    
    ##  [25] "jqr: Client for 'jq', a JSON Processor"                                                                  
    ##  [26] "nodbi: NoSQL Database Connector"                                                                         
    ##  [27] "opencontext: API Client for the Open Context Archeological Database"                                     
    ##  [28] "helminthR: Access London Natural History Museum host-helminth record database"                           
    ##  [29] "proj: R Client for proj4js"                                                                              
    ##  [30] "rchie: A Parser for ArchieML"                                                                            
    ##  [31] "rdopa: R client to Joint Research Centre's DOPA REST API"                                                
    ##  [32] "RedisAPI: Wrapper for 'Redis' 'API'"                                                                     
    ##  [33] "rif: Client for 'Neuroscience' Information Framework 'APIs'"                                             
    ##  [34] "rrlite: R Bindings to rlite"                                                                             
    ##  [35] "sofa: Connector to 'CouchDB'"                                                                            
    ##  [36] "webchem: Chemical Information from the Web"                                                              
    ##  [37] "wellknown: Convert Between 'WKT' and 'GeoJSON'"                                                          
    ##  [38] "rotl: Interface to the 'Open Tree of Life' API"                                                          
    ##  [39] "ropkgs: Install rOpenSci Packages"                                                                       
    ##  [40] "rusda: Interface to USDA Databases"                                                                      
    ##  [41] "oai: General Purpose 'Oai-PMH' Services Client"                                                          
    ##  [42] "apipkgen: Package Generator for HTTP API Wrapper Packages"                                               
    ##  [43] "geojsonio: Convert Data from and to 'GeoJSON' or 'TopoJSON'"                                             
    ##  [44] "appl: Approximate POMDP Planning Software"                                                               
    ##  [45] "aspacer: Client for the ArchiveSpace API"                                                                
    ##  [46] "atomize: Scatter Functions into New Packages"                                                            
    ##  [47] "brranching: Fetch 'Phylogenies' from Many Sources"                                                       
    ##  [48] "ccafs: Client for 'CCAFS' 'GCM' Data"                                                                    
    ##  [49] "cmipr: Client for Coupled Model Intercomparison Project (CMIP) Data"                                     
    ##  [50] "colorpiler: Provides community-driven color palettes"                                                    
    ##  [51] "convertr: Convert Between Units"                                                                         
    ##  [52] "rcore: Client for the CORE API"                                                                          
    ##  [53] "datapack: A Flexible Container to Transport and Manipulate Data and Associated Resources "               
    ##  [54] "datapkg: Read and Write Data Packages"                                                                   
    ##  [55] "dirdf: Extracts Metadata from Directory and File Names"                                                  
    ##  [56] "eechidna: Exploring Election and Census Highly Informative Data Nationally for\n    Australia"           
    ##  [57] "gdoc: An R Markdown Template for Google Docs"                                                            
    ##  [58] "gender: Predict Gender from Names Using Historical Data"                                                 
    ##  [59] "geoaxe: Split 'Geospatial' Objects into Pieces"                                                          
    ##  [60] "geojson: Classes for 'GeoJSON'"                                                                          
    ##  [61] "geojsonlint: Tools for Validating 'GeoJSON'"                                                             
    ##  [62] "geoops: 'GeoJSON' Manipulation Operations"                                                               
    ##  [63] "getlandsat: Get Landsat 8 Data from Amazon Public Data Sets"                                             
    ##  [64] "gtfsr: Working with GTFS (General Transit Feed Specification) feeds in R"                                
    ##  [65] "gutenbergr: Download and Process Public Domain Works from Project Gutenberg"                             
    ##  [66] "hunspell: High-Performance Stemmer, Tokenizer, and Spell Checker for R"                                  
    ##  [67] "jsonvalidate: Validate 'JSON'"                                                                           
    ##  [68] "mapr: Visualize Species Occurrence Data"                                                                 
    ##  [69] "mregions: Marine Regions Data from 'Marineregions.org'"                                                  
    ##  [70] "opencage: Interface to the OpenCage API"                                                                 
    ##  [71] "geonames: Interface To www.geonames.org Spatial Query Web Service"                                       
    ##  [72] "originr: Fetch Species Origin Data from the Web"                                                         
    ##  [73] "osmplotr: Customisable Images of OpenStreetMap Data"                                                     
    ##  [74] "pdftools: Text Extraction and Rendering of PDF Documents"                                                
    ##  [75] "rgeospatialquality: Wrapper for the Geospatial Data Quality REST API"                                    
    ##  [76] "gistr: Work with 'GitHub' 'Gists'"                                                                       
    ##  [77] "riodata: Get data related to transportation and cultural places from Rio de\n    Janeiro, Brazil."       
    ##  [78] "robotstxt: A 'robots.txt' Parser and 'Webbot'/'Spider'/'Crawler' Permissions Checker"                    
    ##  [79] "ropenaq: Accesses Air Quality Data from the Open Data Platform OpenAQ"                                   
    ##  [80] "rredlist: 'IUCN' Red List Client"                                                                        
    ##  [81] "rwdpa: World Database of Protected Areas"                                                                
    ##  [82] "scrubr: Clean Biological Occurrence Records"                                                             
    ##  [83] "snowball: Spin up a managed cluster and perform parallel calculations"                                   
    ##  [84] "solrium: General Purpose R Interface to 'Solr'"                                                          
    ##  [85] "spenv: Add Environmental Data to Spatial Data"                                                           
    ##  [86] "splister: Match Species Lists Against Reference List"                                                    
    ##  [87] "spplist: Get Species Lists from Many Data Sources"                                                       
    ##  [88] "spplit: Combine Literature and Species Occurrence Data"                                                  
    ##  [89] "stplanr: Sustainable Transport Planning"                                                                 
    ##  [90] "git2r: Provides Access to Git Repositories"                                                              
    ##  [91] "taxa: Taxonomic Classes for R"                                                                           
    ##  [92] "taxizedb: Tools for Working with 'Taxonomic' Databases"                                                  
    ##  [93] "vcr: Record 'HTTP' Calls to Disk"                                                                        
    ##  [94] "dissem: Client for 'dissem.in' 'API' for Scholarly Metadata"                                             
    ##  [95] "sparqldsl: SPARQL DSL Client"                                                                            
    ##  [96] "historydata: Data Sets for Historians"                                                                   
    ##  [97] "riem: Accesses Weather Data from the Iowa Environment Mesonet"                                           
    ##  [98] "genbankr: Parsing GenBank files into semantically useful objects"                                        
    ##  [99] "monkeylearn: Accesses the Monkeylearn API for Text Classifiers and Extractors"                           
    ## [100] "rnaturalearthdata: World Vector Map Data from Natural Earth Used in 'rnaturalearth'"                     
    ## [101] "rnaturalearth: World Map Data from Natural Earth"                                                        
    ## [102] "assertr: Assertive Programming for R Analysis Pipelines"                                                 
    ## [103] "IEEER: Interface to the IEEE Xplore Gateway"                                                             
    ## [104] "geoparser: Interface to the Geoparser.io API for Identifying and Disambiguating Places Mentioned in Text"
    ## [105] "magick: Advanced Image-Processing in R"                                                                  
    ## [106] "tokenizers: A Consistent Interface to Tokenize Natural Language Text"                                    
    ## [107] "laselva: FIA Data"                                                                                       
    ## [108] "hoasts: Host and Parasite Data Across Sources"                                                           
    ## [109] "ezknitr: Avoid the Typical Working Directory Pain When Using 'knitr'"                                    
    ## [110] "natserv: 'NatureServe' Interface"                                                                        
    ## [111] "jaod: Directory of Open Access Journals Client"                                                          
    ## [112] "rdefra: Interact with the UK AIR Pollution Database from DEFRA"                                          
    ## [113] "bmc: Search the BiomedCentral API and get full text articles."                                           
    ## [114] "scitations: Bibliographic Citation Tools"                                                                
    ## [115] "neotoma: Access to the Neotoma Paleoecological Database Through R"                                       
    ## [116] "tabulizer: Bindings for Tabula PDF Table Extractor Library"                                              
    ## [117] "ghql: General Purpose GraphQL Client"                                                                    
    ## [118] "graphql: A GraphQL Query Parser"                                                                         
    ## [119] "plater: Read, Tidy, and Display Data from Microtiter Plates"                                             
    ## [120] "dbhydroR: 'DBHYDRO' Hydrologic and Water Quality Data"                                                   
    ## [121] "crevents: Client for the Crossref Events API"                                                            
    ## [122] "nneo: NEON API Client"                                                                                   
    ## [123] "isdparser: Parse 'NOAA' Integrated Surface Data Files"                                                   
    ## [124] "crul: HTTP Client"                                                                                       
    ## [125] "travis: Set Up Travis for R package"                                                                     
    ## [126] "tic: Tasks Integrating Continuously"                                                                     
    ## [127] "crminer: Fetch 'Scholary' Full Text from 'Crossref'"                                                     
    ## [128] "phyrmeta: Client to Handle Phylometa Output"                                                             
    ## [129] "geojsonrewind: Fix 'GeoJSON' Winding Direction"                                                          
    ## [130] "ots: Client for Various Ocean Time Series 'Datasets'"                                                    
    ## [131] "tesseract: Open Source OCR Engine"                                                                       
    ## [132] "agent: Encrypted Key-Value Store for Sensitive Data"                                                     
    ## [133] "fauxpas: HTTP Error Helpers"                                                                             
    ## [134] "camsRad: Client for CAMS Radiation Service"                                                              
    ## [135] "phylocomr: Interface to 'Phylocom'"                                                                      
    ## [136] "geofilter: 'GeoJSON' Filtering"                                                                          
    ## [137] "scatr: Scholastic Commentaries and Texts Archive Client"                                                 
    ## [138] "rbace: Bielefeld Academic Search Engine ('BASE') Client"                                                 
    ## [139] "ridb: Client for the Index Database of Remote Sensing Indices"                                           
    ## [140] "jsonld: JSON for Linking Data"                                                                           
    ## [141] "wikitaxa: Taxonomic Information from 'Wikipedia'"                                                        
    ## [142] "charlatan: Make Fake Data"                                                                               
    ## [143] "paleobioDB: Download and Process Data from the Paleobiology Database"                                    
    ## [144] "zissou: 'AquaMaps' Interface"                                                                            
    ## [145] "worrms: World Register of Marine Species (WoRMS) Client"                                                 
    ## [146] "xslt: XSLT 1.0 Transformations"                                                                          
    ## [147] "wicket: Utilities to Handle WKT Spatial Data"                                                            
    ## [148] "rjsonapi: Consumer for APIs that Follow the JSON API Specification"                                      
    ## [149] "hoardr: Manage Cached Files"                                                                             
    ## [150] "hddtools: Hydrological Data Discovery Tools"                                                             
    ## [151] "randgeo: Generate Random 'WKT' or 'GeoJSON'"                                                             
    ## [152] "rdataretriever: R Interface to the Data Retriever"                                                       
    ## [153] "rzmq: R Bindings for ZeroMQ"                                                                             
    ## [154] "extractr: Extract Text from 'PDFs'"                                                                      
    ## [155] "pangaear: Client for the 'Pangaea' Database"                                                             
    ## [156] "reeack: Client for Riak"                                                                                 
    ## [157] "microdemic: Microsoft Academic Client"                                                                   
    ## [158] "seaaroundus: Sea Around Us API Wrapper"                                                                  
    ## [159] "getCRUCLdata: Use and Explore CRU CL v. 2.0 Climatology Elements in R"                                   
    ## [160] "datastorr: Simple Data Versioning"                                                                       
    ## [161] "antiword: Extract Text from Microsoft Word Documents"                                                    
    ## [162] "tif: Text Interchange Format"                                                                            
    ## [163] "lingtypology: Linguistic Typology and Mapping"                                                           
    ## [164] "osmdata: Import OpenStreetMap Data as Simple Features or Spatial Objects"                                
    ## [165] "cld2: Google's Compact Language Detector 2"                                                              
    ## [166] "pleiades: Interface to the 'Pleiades' 'Archeological' Database"                                          
    ## [167] "plotly: Create Interactive Web Graphics via 'plotly.js'"                                                 
    ## [168] "bold: Interface to Bold Systems 'API'"                                                                   
    ## [169] "rAltmetric: Retrieves Altmerics Data for Any Published Paper from 'Altmetric.com'"                       
    ## [170] "rAvis: Interface to the Bird-Watching Dataset Proyecto AVIS"                                             
    ## [171] "rbhl: Interface to the 'Biodiversity' 'Heritage' Library"                                                
    ## [172] "rbison: Interface to the 'USGS' 'BISON' 'API'"                                                           
    ## [173] "rcrossref: Client for Various 'CrossRef' 'APIs'"                                                         
    ## [174] "rdatacite: 'DataCite' Client for 'OAI-PMH' Methods and their Search 'API'"                               
    ## [175] "rdryad: Access for Dryad Web Services"                                                                   
    ## [176] "europepmc: R Interface to the Europe PubMed Central RESTful Web Service"                                 
    ## [177] "rebird: R Client for the eBird Database of Bird Observations"                                            
    ## [178] "rentrez: Entrez in R"                                                                                    
    ## [179] "Reol: R Interface to the Encyclopedia of Life"                                                           
    ## [180] "rfigshare: An R Interface to 'figshare'"                                                                 
    ## [181] "clifro: Easily Download and Visualise Climate Data from CliFlo"                                          
    ## [182] "rfishbase: R Interface to 'FishBase'"                                                                    
    ## [183] "rfisheries: 'Programmatic Interface to the 'openfisheries.org' API'"                                     
    ## [184] "rgbif: Interface to the Global 'Biodiversity' Information Facility 'API'"                                
    ## [185] "rglobi: R Interface to Global Biotic Interactions"                                                       
    ## [186] "rinat: Access iNaturalist Data Through APIs"                                                             
    ## [187] "ritis: Integrated Taxonomic Information System Client"                                                   
    ## [188] "rmetadata: Work with many Scholarly Metadata APIs in R."                                                 
    ## [189] "RNeXML: Semantically Rich I/O for the 'NeXML' Format"                                                    
    ## [190] "rnoaa: 'NOAA' Weather Data from R"                                                                       
    ## [191] "dvn: Access to Dataverse 3 APIs"                                                                         
    ## [192] "rnpn: Interface to the National 'Phenology' Network 'API'"                                               
    ## [193] "rorcid: Interface to the 'Orcid.org' 'API'"                                                              
    ## [194] "rplos: Interface to the Search 'API' for 'PLoS' Journals"                                                
    ## [195] "RSelenium: R Bindings for 'Selenium WebDriver'"                                                          
    ## [196] "rsnps: Get 'SNP' ('Single-Nucleotide' 'Polymorphism') Data on the Web"                                   
    ## [197] "ecoengine: Programmatic Interface to the API Serving UC Berkeley's Natural History\n    Data"            
    ## [198] "rvertnet: Search 'Vertnet', a 'Database' of Vertebrate Specimen Records"                                 
    ## [199] "rWBclimate: A package for accessing World Bank climate data"                                             
    ## [200] "solrium: General Purpose R Interface to 'Solr'"                                                          
    ## [201] "spocc: Interface to Species Occurrence Data Sources"                                                     
    ## [202] "taxize: Taxonomic Information from Around the Web"                                                       
    ## [203] "testdat: A suite for running automated tests for data"                                                   
    ## [204] "traits: Species Trait Data from Around the Web"                                                          
    ## [205] "treebase: Discovery, Access and Manipulation of 'TreeBASE' Phylogenies"                                  
    ## [206] "USAboundaries: Historical and Contemporary Boundaries of the United States of America"                   
    ## [207] "elastic: General Purpose Interface to 'Elasticsearch'"                                                   
    ## [208] "USAboundariesData: Datasets for the 'USAboundaries' package"                                             
    ## [209] "zenodo: Programmatic Interface to the Zenodo Research Data Archive"

``` r
## 60 unique maintainers
map_chr(corpus, c("maintainer", "familyName")) %>% unique() %>% length()
```

    ## [1] 60

``` r
## Mostly Scott
map_chr(corpus, c("maintainer", "familyName")) %>% table() %>% sort(TRUE)
```

    ## .
    ##  Chamberlain         Ooms       Mullen          Ram    Boettiger 
    ##          105           12            8            8            6 
    ##       Salmon     FitzJohn         Hart       Leeper      Marwick 
    ##            5            4            2            2            2 
    ##       Müller      Padgham        South       Varela       Vitolo 
    ##            2            2            2            2            2 
    ##       Arnold       Attali      Banbury       Becker    Bengtsson 
    ##            1            1            1            1            1 
    ##    Braginsky       Broman        Bryan       Dallas   de Queiroz 
    ##            1            1            1            1            1 
    ##    Fischetti    Ghahraman       Goring hackathoners     Harrison 
    ##            1            1            1            1            1 
    ##       Hughes         Jahn        Jones        Keyes         Krah 
    ##            1            1            1            1            1 
    ##    Lehtomaki     Lovelace    Lundstrom      McGlinn        McVey 
    ##            1            1            1            1            1 
    ##     Meissner   Michonneau        Moroz       Otegui        Pardo 
    ##            1            1            1            1            1 
    ##      Pennell       Poelen     Robinson         Ross   Rowlingson 
    ##            1            1            1            1            1 
    ##        Scott        Seers     Shotwell      Sievert       Sparks 
    ##            1            1            1            1            1 
    ##    Stachelek        Szöcs      Widgren       Wiggin       Winter 
    ##            1            1            1            1            1

``` r
## number of co-authors ... 
map_int(corpus, function(r) length(r$author)) %>% table() %>% sort(TRUE)
```

    ## .
    ##   1   2   3   4   5   7  13 
    ## 145  30  17   8   5   3   1

``` r
## Contributors isn't used as much...
map_int(corpus, function(r) length(r$contributor)) %>% table() %>% sort(TRUE)
```

    ## .
    ##   0   2   4   3   5   6   8 
    ## 177  13   9   7   1   1   1

``` r
## authors + ctb 
map_int(corpus, function(r) length(r$author) + length(r$contributor)) %>% table() %>% sort(TRUE)
```

    ## .
    ##   1   2   3   4   5   7   6   8   9  13 
    ## 120  27  25  15  12   3   2   2   2   1

Dependencies

``` r
map_int(corpus, function(r) length(r$softwareRequirements))
```

    ##   [1]  6  4  5  8  9  5  6  4 11  4  2  5  9  6  5  5  2  5  3  6  4  2  3
    ##  [24] 18  3  2  3  5  2  2  7  3  4  2  4  8  5  7  3  8  5  4 11  4  2  2
    ##  [47]  6  8  5  8  5  3  7  5  4 13  6  6  4  7  5  5  7 12  7  2  4  8  8
    ##  [70]  4  2  6 12  5  3  7  0  3  6  2  7 12  2  7  9  3  2  7 23  4  8  7
    ##  [93]  8  2  4  4  4 11  5  2  4  5  3  9  2  4  6  3  4  5  3  8  6  4  7
    ## [116]  5  4  2  3  4  5  5  2  5  5  9  5  2  5  7  3  3  3  3  3  4  2  4
    ## [139]  4  3  8  4  7  4  3  5  4  4  3 12  0  2  4  5  7  3  2 10 10  4  4
    ## [162]  4 10 11  4  5 21 12  4 11  5  8 12  2  5  8  6  4  4  9 10  7  6 11
    ## [185]  3  5  5  9 13 17  3  6  4  9 10  5 10  5  7  7 13 22  6 12  7  2  5
    ## [208]  4  6

``` r
#map_df(corpus, function(r) tibble(pkg = r$identifier, dep = map_chr(r$softwareRequirements, "name")))
```

Counts:

-   maintainer : number packages maintained
-   author : number of packages
-   number of authors, author vs contributor
