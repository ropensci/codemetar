Translating between schema using JSON-LD
================

``` r
library("tidyverse")
library("jsonlite")
library("jsonld")
library("httr")
```

One of the central motivations of JSON-LD is making it easy to translate between different representations of what are fundamentally the same data types. Doing so uses the two core algorithms of JSON-LD: *expansion* and *compaction*, as [this excellent short video by JSON-LD creator Manu Sporny](https://www.youtube.com/watch?v=Tm3fD89dqRE) describes.

Here's how we would use JSON-LD (from R) to translate between the two examples of JSON data from different providers as shown in the video. First, the JSON from the original provider:

``` r
ex <-
'{
"@context":{
  "shouter": "http://schema.org/name",
  "txt": "http://schema.org/commentText"
},
"shouter": "Jim",
"txt": "Hello World!"
}'
```

Next, we need the context of the second data provider. This will let us translate the JSON format used by provider one ("Shouttr") to the second ("BigHash"):

``` r
bighash_context <- 
'{
"@context":{
  "user": "http://schema.org/name",
  "comment": "http://schema.org/commentText"
}
}'
```

With this in place, we simply expand the original JSON and then compact using the new context:

``` r
jsonld_expand(ex) %>%
  jsonld_compact(context = bighash_context)
```

    {
      "@context": {
        "user": "http://schema.org/name",
        "comment": "http://schema.org/commentText"
      },
      "comment": "Hello World!",
      "user": "Jim"
    } 

Crosswalk contexts
------------------

The CodeMeta Crosswalk table seeks to accomplish a very similar goal. The crosswalk table provides a human-readable mapping of different software metadata providers into the codemeta context (an extension of schema.org).

We'll start with the actual crosswalk table itself:

``` r
crosswalk <- "https://github.com/codemeta/codemeta/raw/master/crosswalk.csv"
crosswalk <- "../../../codemeta/crosswalk.csv"
cw <- read_csv(crosswalk)
```

    Parsed with column specification:
    cols(
      .default = col_character()
    )

    See spec(...) for full column specifications.

and we will write an R function which turns this data in a context file for the requested column:

``` r
crosswalk <- function(cw, column){
  
  def <- function(r){
    prefix <- strsplit(r[["Parent Type"]], ":")[[1]][[1]]
    if(prefix == "schema")
      out <- paste(prefix, r[["Property"]], sep=":")
    ## Best to declare type on any property we want to explicitly type in the output version (e.g. codemeta objects)
    ## Otherwise the compaction aglorithm will not de-reference the `codemeta:` prefix
    else if(prefix == "codemeta"){
      type <- gsub("(\\w+).*", "\\1", r[["Type"]])
      out <- list("@id" = paste0(prefix, ":", r[["Property"]]),
                  "@type" = paste0("http://schema.org/", type))
    }
    out
  }

  ## apply by row
  cw[c("Parent Type", "Property", "Type", column)] %>% 
    na.omit() %>%
    by_row(def, .to = "def") -> df
  ## 
  context <- df[["def"]]
  names(context) <- gsub("(\\w+).*", "\\1", df[[column]])
  
  context <- c(list(schema = "http://schema.org/", 
                    codemeta = "https://codemeta.github.io/terms/"), 
               as.list(context))
  context
  #toJSON(list(context = context), pretty = TRUE, auto_unbox = TRUE)
}
```

With this in place, we can start converting between data formats.

DataCite
--------

``` r
cm2_context <- "https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta-v2.jsonld"
#cm2_context <- "../examples/codemeta-v2.jsonld"
```

``` r
## nope, sadly this is not quite clean json translation 
# GET("https://doi.org/10.5281/zenodo.573741", add_headers(Accept="application/vnd.datacite.datacite+xml")) %>% content(type="application/xml") %>% xml2::as_list() %>%  toJSON(pretty = TRUE, auto_unbox=TRUE)
## Read tidy version instead
datacite_ex <- "../examples/datacite-xml.json"
cat(readLines(datacite_ex), sep="\n")
```

    {
      "identifier": "10.5281/zenodo.573741",
      "creators": [
        { "givenName": "Jouni",
          "familyName": "Helske"
        },
        {
          "givenName": "Matti",
          "familyName": "Vihola"
        }
      ],
      "title": "Bayesian Inference Of State Space Models With The Bssm Package",
      "publisher": "Zenodo",
      "publicationYear": "2017",
      "resourceType": "Software",
      "date": "2017-05-10",
      "rights": "Open Access",
      "description": [
          "Efficient methods for Bayesian inference of state space models via particle Markov chain Monte Carlo and importance sampling type corrected Markov chain Monte Carlo. Currently supports models with Gaussian, Poisson, binomial, or negative binomial observation densities and Gaussian state dynamics, as well as general non-linear Gaussian models.",
          "Funded by Academy of Finland grant 284513, \"Exact approximate Monte Carlo methods for complex Bayesian inference\"."
      ]
    }

Add the crosswalk context

``` r
datacite_list <- read_json(datacite_ex)
datacite_list$`@context` <- crosswalk(cw, "DataCite")
```

Here we compact into the CodeMeta native context:

``` r
  datacite_list %>% 
  toJSON(auto_unbox=TRUE) %>%
  jsonld_expand() %>% 
  jsonld_compact(context = cm2_context) 
```

    {
      "@context": "https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta-v2.jsonld",
      "author": [
        {
          "familyName": "Helske",
          "givenName": "Jouni"
        },
        {
          "familyName": "Vihola",
          "givenName": "Matti"
        }
      ],
      "dateCreated": "2017-05-10",
      "datePublished": "2017",
      "description": [
        "Efficient methods for Bayesian inference of state space models via particle Markov chain Monte Carlo and importance sampling type corrected Markov chain Monte Carlo. Currently supports models with Gaussian, Poisson, binomial, or negative binomial observation densities and Gaussian state dynamics, as well as general non-linear Gaussian models.",
        "Funded by Academy of Finland grant 284513, \"Exact approximate Monte Carlo methods for complex Bayesian inference\"."
      ],
      "identifier": "10.5281/zenodo.573741",
      "license": "Open Access",
      "publisher": "Zenodo"
    } 

We could also crosswalk into another standard by compacting into that context instead. For instance, here we translate our datacite record into a zenodo record. First we get the context from the crosswalk:

``` r
zenodo_context <- 
  list("@context" = crosswalk(cw, "Zenodo")) %>% 
  toJSON(pretty = TRUE, auto_unbox = TRUE)
cat(zenodo_context)
```

    {
      "@context": {
        "schema": "http://schema.org/",
        "codemeta": "https://codemeta.github.io/terms/",
        "relatedLink": "schema:codeRepository",
        "communities": "schema:applicationCategory",
        "creators": "schema:author",
        "date_published": "schema:datePublished",
        "contributors": "schema:funder",
        "keywords": "schema:keywords",
        "license": "schema:license",
        "description": "schema:description",
        "id": "schema:identifier",
        "title": "schema:name",
        "affiliation": "schema:affiliation",
        "ORCID": "schema:\"@id\"",
        "name": "schema:name",
        "license.1": {
          "@id": "codemeta:licenseId",
          "@type": "http://schema.org/Text"
        }
      }
    }

then apply it as before:

``` r
  datacite_list %>% 
  toJSON(pretty=TRUE, auto_unbox=TRUE) %>%
  jsonld_expand() %>% 
  jsonld_compact(context = zenodo_context) 
```

    {
      "@context": {
        "schema": "http://schema.org/",
        "codemeta": "https://codemeta.github.io/terms/",
        "relatedLink": "schema:codeRepository",
        "communities": "schema:applicationCategory",
        "creators": "schema:author",
        "date_published": "schema:datePublished",
        "contributors": "schema:funder",
        "keywords": "schema:keywords",
        "license": "schema:license",
        "description": "schema:description",
        "id": "schema:identifier",
        "title": "schema:name",
        "affiliation": "schema:affiliation",
        "ORCID": "schema:\"@id\"",
        "name": "schema:name",
        "license.1": {
          "@id": "codemeta:licenseId",
          "@type": "http://schema.org/Text"
        }
      },
      "creators": [
        {
          "schema:familyName": "Helske",
          "schema:givenName": "Jouni"
        },
        {
          "schema:familyName": "Vihola",
          "schema:givenName": "Matti"
        }
      ],
      "schema:dateCreated": "2017-05-10",
      "date_published": "2017",
      "description": [
        "Efficient methods for Bayesian inference of state space models via particle Markov chain Monte Carlo and importance sampling type corrected Markov chain Monte Carlo. Currently supports models with Gaussian, Poisson, binomial, or negative binomial observation densities and Gaussian state dynamics, as well as general non-linear Gaussian models.",
        "Funded by Academy of Finland grant 284513, \"Exact approximate Monte Carlo methods for complex Bayesian inference\"."
      ],
      "id": "10.5281/zenodo.573741",
      "license": "Open Access",
      "schema:publisher": "Zenodo"
    } 

Note that data that cannot be crosswalked into Zenodo is not dropped, but rather is left in the original context (`schema:`).

Comparison to native schema.org translation:
--------------------------------------------

DataCite actually returns data directly in JSON-LD format using exclusively the schema.org context. We can query that data directly:

``` r
library("httr")
resp <- GET("https://doi.org/10.5281/zenodo.573741", add_headers(Accept="application/vnd.schemaorg.ld+json"))
datacite_jsonld <- content(resp, type="application/json")
```

This time we have no need to invoke the crosswalk context, since the data is already in schema.org context (which codemeta also uses):

``` r
datacite_cm <- 
  datacite_jsonld %>% 
  toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
  jsonld_expand() %>% 
  jsonld_compact(context = cm2_context) 

datacite_cm
```

    {
      "@context": "https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta-v2.jsonld",
      "@id": "https://doi.org/10.5281/zenodo.573741",
      "@type": "SoftwareSourceCode",
      "schema:additionalType": {
        "@id": "Software"
      },
      "author": [
        {
          "@type": "Person",
          "familyName": "Helske",
          "givenName": "Jouni",
          "name": "Jouni Helske"
        },
        {
          "@type": "Person",
          "familyName": "Vihola",
          "givenName": "Matti",
          "name": "Matti Vihola"
        }
      ],
      "datePublished": {
        "@type": "schema:Date",
        "@value": "2017-05-10"
      },
      "description": [
        "Efficient methods for Bayesian inference of state space models via particle Markov chain Monte Carlo and importance sampling type corrected Markov chain Monte Carlo. Currently supports models with Gaussian, Poisson, binomial, or negative binomial observation densities and Gaussian state dynamics, as well as general non-linear Gaussian models.",
        "Funded by Academy of Finland grant 284513, \"Exact approximate Monte Carlo methods for complex Bayesian inference\"."
      ],
      "name": "Bayesian Inference Of State Space Models With The Bssm Package",
      "provider": {
        "@type": "Organization",
        "name": "DataCite"
      },
      "publisher": {
        "@type": "Organization",
        "name": "Zenodo"
      },
      "schema:schemaVersion": {
        "@id": "http://datacite.org/schema/kernel-3"
      }
    } 

This is very close to the codemeta document we got by translating the DataCite XML using the crosswalk table.

Codemeta
--------

We can use a similar crosswalk strategy to translate from a JSON-LD file writing using v1 of the codemeta context into the current, v2 context:

``` r
codemetav1 <- crosswalk(cw, "codemeta-V1")

## Add some altered Type definitions from v1
codemetav1 <- c(codemetav1,
                    person = "schema:Person",
                    organization = "schema:Organization",
                    SoftwareSoureCode = "schema:SoftwareSourceCode")
```

To crosswalk a vocabulary, we must use the context the CrossWalk table defines for that vocabulary. Most vocabularies are not already ontologies with their own base URLs, in which case this is relatively intuitive. But we also need to use the CrossWalk context even when the data originates in another context (SoftwareOntology, DOAP, codemeta-v1), since otherwise those terms will stay in their original space (e.g `dcterms:identifer` will remain a different kind of property from a `schema:identifer`, etc)

``` r
v1 <- "https://raw.githubusercontent.com/codemeta/codemetar/master/inst/examples/codemeta-v1.json"
#v1 <- "../examples/codemeta-v1.json" ## or local path
v1_obj <- jsonlite::read_json(v1)
v1_obj$`@context` <- codemetav1
v1_json <- toJSON(v1_obj, pretty=TRUE, auto_unbox = TRUE)

#write_json(v1_obj, "v1.json", pretty=TRUE, auto_unbox = TRUE)
```

With a JSON object in place, along with a context file that defines how that vocabulary is expressed in the context of `schema.org` / `codemeta`, we can now perform the exansion and compaction routine as before. Expansion uses the native context from the file, compaction uses the new context of codemeta terms.

``` r
v2_json <- 
jsonld_expand(v1_json) %>%
  jsonld_compact(context = "https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta-v2.jsonld") 
v2_json
```

    {
      "@context": "https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta-v2.jsonld",
      "@type": "SoftwareSourceCode",
      "author": [
        {
          "@id": "http://orcid.org/0000-0002-2192-403X",
          "@type": "Person",
          "affiliation": "NCEAS",
          "email": "slaughter@nceas.ucsb.edu",
          "name": "Peter Slaughter"
        },
        {
          "@id": "http://orcid.org/0000-0002-3957-2474",
          "@type": "Organization",
          "email": "info@ucop.edu",
          "name": "University of California, Santa Barbara"
        }
      ],
      "citation": "https://github.com/codemeta/codemeta-paper",
      "codeRepository": "https://github.com/codemeta/codemeta",
      "dateModified": "2014-08-15",
      "datePublished": "2014-09-06",
      "description": "Codemeta is a metadata content standard for software.  It includes schemas in JSON-LD and XML Schema for providing semantics and validation.",
      "downloadUrl": "https://github.com/codemeta/codemeta/releases/codemeta_2.1.0-rc.2.tar.gz",
      "identifier": "http://dx.doi.org/10.6084/m9.figshare.828487",
      "keywords": [
        "software",
        "metadata"
      ],
      "license": "Apache-2.0",
      "name": "codemeta",
      "programmingLanguage": {
        "name": "ruby",
        "url": "https://www.ruby-lang.org/en/",
        "version": "2.3.1"
      },
      "publisher": "figshare",
      "version": "2.1.0-rc.2",
      "buildInstructions": "https://github.com/codemeta/codemeta/buildInstructions",
      "contIntegration": "https://github.com/codemeta/codemeta/minitest",
      "codemeta:depends": [
        {
          "identifier": "http://doi.org/10.xxxx/A324566",
          "name": "export_fig",
          "version": "1.99",
          "packageSystem": "http://www.mathworks.com"
        },
        {
          "identifier": "89766228838383883",
          "name": "npplus",
          "operatingSystem": [
            "MacOS",
            "Linux"
          ],
          "version": "0.9.4",
          "packageSystem": "https://pypi.python.org"
        },
        {
          "identifier": "7777575757757-389349843-90898",
          "name": "popbio",
          "operatingSystem": [
            "Windows",
            "OS X Mavericks"
          ],
          "version": "1.3.4",
          "packageSystem": "http://cran.r-project.org"
        }
      ],
      "developmentStatus": "active",
      "embargoDate": "2014-08-06T10:00:01Z",
      "funding": "National Science Foundation grant #012345678",
      "issueTracker": "https://github.com/codemeta/codemeta/issues",
      "codemeta:maintainer": {
        "@id": "http://orcid.org/0000-0002-2192-403X",
        "@type": "Person",
        "email": "slaughter@nceas.ucsb.edu",
        "name": "Peter Slaughter"
      },
      "readme": "https://github.com/codemeta/codemeta/README.md",
      "relatedPublications": [
        "DOI:10.1177/0165551504045850",
        "DOI:10.1145/2815833.2816955"
      ],
      "codemeta:suggests": {
        "name": "tokenizertools",
        "operatingSystem": [
          "MacOS",
          "Linux"
        ],
        "version": "1.0",
        "packageSystem": "https://pypi.python.org"
      }
    } 

Note that certain terms in the `codemeta` namespace are explicitly being typed as such (e.g. `codemeta:maintainer` rather than plain `maintainer`) by the compaction algorithm, because these terms do not have matching types in their original codemeta v1 context vs codemeta v2 context.

Framing
-------

We can use a frame to extract particular elements in a particular format. This is most useful when there are highly nested complex types. Framing with the `@explicit` tag is also a good way to filter out fields that we are not interested in, though these are usually less problematic for developers to work around.

``` r
frame <- 
'{
  "@context":"https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta-v2.jsonld",
  "@type": "SoftwareSourceCode",
  "@explicit": "true",
  "readme": {},
  "description": {},
  "maintainer": {}
}'

jsonld_frame(v2_json, frame)
```

    {
      "@context": "https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta-v2.jsonld",
      "@graph": [
        {
          "@id": "_:b0",
          "@type": "SoftwareSourceCode",
          "description": "Codemeta is a metadata content standard for software.  It includes schemas in JSON-LD and XML Schema for providing semantics and validation.",
          "codemeta:maintainer": {
            "@id": "http://orcid.org/0000-0002-2192-403X",
            "@type": "Person",
            "affiliation": "NCEAS",
            "email": "slaughter@nceas.ucsb.edu",
            "name": "Peter Slaughter"
          },
          "readme": "https://github.com/codemeta/codemeta/README.md"
        }
      ]
    } 

Note that our frame can refer to `maintainer` even though the compaction has left the Property as `codemeta:maintainer`.
