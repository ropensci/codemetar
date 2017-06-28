library(httr)

## Specific to registered app, but not actually secret
myapp <- oauth_app("orcid",
                   key = "APP-QUL072GJD1BVYS6X",
                   secret = "9544bbe2-5538-4fc5-bfc7-15426a356af1")
endpoint <-
  oauth_endpoint(NULL, "authorize", "token", base_url = "https://orcid.org/oauth/")

## Not sure why this fails with 401 error
token <- oauth2.0_token(endpoint, myapp, scope = "/authenticate")

# 4. Use API
orcid_token <- config(token = token)
req <-
  GET("https://pub.sandbox.orcid.org/v2.0/search/?q=family-name:Sanchez",
      orcid_token)
stop_for_status(req)
content(req)

# OR:
req <-
  with_config(
    orcid_token,
    GET(
      "https://pub.sandbox.orcid.org/v2.0/search/?q=family-name:Sanchez"
    )
  )
stop_for_status(req)
content(req)
