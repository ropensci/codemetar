context("test minimal jsonld with content negotiation")

#library(jsonld)
#options(jsonld_use_accept = TRUE)
#jsonld::jsonld_compact(
#  "https://raw.githubusercontent.com/codemeta/codemetar/master/codemeta.json",
#  "https://raw.githubusercontent.com/codemeta/codemeta/2.0/codemeta.jsonld")


library("jsonld")


# Example from https://github.com/digitalbazaar/jsonld.js#quick-examples
doc <- '{
"http://schema.org/name": "Manu Sporny",
"http://schema.org/url": {"@id": "http://manu.sporny.org/"},
"http://schema.org/image": {"@id": "http://manu.sporny.org/images/manu.png"}
}'
# Compact given a url to a context:
out <- jsonld_compact(doc, "http://purl.org/codemeta/2.0")

## Some systems / runs give:
#Error in context_eval(join(src), private$context) :
#  TypeError: Object #<Object> has no method 'match'
