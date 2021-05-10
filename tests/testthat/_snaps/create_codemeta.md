# we can create a codemeta document given a package name

    Code
      create_codemeta("utils", path = path, verbose = FALSE)
    Output
      $`@context`
      [1] "https://doi.org/10.5063/schema/codemeta-2.0"
      [2] "http://schema.org"                          
      
      $`@type`
      [1] "SoftwareSourceCode"
      
      $identifier
      Package 
      "utils" 
      
      $description
                 Description 
      "R utility functions." 
      
      $name
      [1] "utils: The R Utils Package"
      
      $license
      [1] "Part of R 4.0.2"
      
      $version
      [1] "4.0.2"
      
      $programmingLanguage
      $programmingLanguage$`@type`
      [1] "ComputerLanguage"
      
      $programmingLanguage$name
      [1] "R"
      
      $programmingLanguage$url
      [1] "https://r-project.org"
      
      
      $runtimePlatform
      [1] "R version 4.0.2 (2020-06-22)"
      
      $author
      $author[[1]]
      $author[[1]]$`@type`
      [1] "Person"
      
      $author[[1]]$givenName
      [1] "R"    "Core"
      
      $author[[1]]$familyName
      [1] "Team"
      
      
      $author[[2]]
      $author[[2]]$`@type`
      [1] "Person"
      
      $author[[2]]$givenName
      [1] "contributors"
      
      $author[[2]]$familyName
      [1] "worldwide"
      
      
      
      $contributor
      NULL
      
      $copyrightHolder
      NULL
      
      $funder
      NULL
      
      $maintainer
      $maintainer[[1]]
      $maintainer[[1]]$`@type`
      [1] "Person"
      
      $maintainer[[1]]$givenName
      [1] "R"    "Core"
      
      $maintainer[[1]]$familyName
      [1] "Team"
      
      $maintainer[[1]]$email
      [1] "R-core@r-project.org"
      
      
      
      $softwareSuggestions
      $softwareSuggestions[[1]]
      $softwareSuggestions[[1]]$`@type`
      [1] "SoftwareApplication"
      
      $softwareSuggestions[[1]]$identifier
      [1] "methods"
      
      $softwareSuggestions[[1]]$name
      [1] "methods"
      
      
      $softwareSuggestions[[2]]
      $softwareSuggestions[[2]]$`@type`
      [1] "SoftwareApplication"
      
      $softwareSuggestions[[2]]$identifier
      [1] "xml2"
      
      $softwareSuggestions[[2]]$name
      [1] "xml2"
      
      $softwareSuggestions[[2]]$provider
      $softwareSuggestions[[2]]$provider$`@id`
      [1] "https://cran.r-project.org"
      
      $softwareSuggestions[[2]]$provider$`@type`
      [1] "Organization"
      
      $softwareSuggestions[[2]]$provider$name
      [1] "Comprehensive R Archive Network (CRAN)"
      
      $softwareSuggestions[[2]]$provider$url
      [1] "https://cran.r-project.org"
      
      
      $softwareSuggestions[[2]]$sameAs
      [1] "https://CRAN.R-project.org/package=xml2"
      
      
      $softwareSuggestions[[3]]
      $softwareSuggestions[[3]]$`@type`
      [1] "SoftwareApplication"
      
      $softwareSuggestions[[3]]$identifier
      [1] "commonmark"
      
      $softwareSuggestions[[3]]$name
      [1] "commonmark"
      
      $softwareSuggestions[[3]]$provider
      $softwareSuggestions[[3]]$provider$`@id`
      [1] "https://cran.r-project.org"
      
      $softwareSuggestions[[3]]$provider$`@type`
      [1] "Organization"
      
      $softwareSuggestions[[3]]$provider$name
      [1] "Comprehensive R Archive Network (CRAN)"
      
      $softwareSuggestions[[3]]$provider$url
      [1] "https://cran.r-project.org"
      
      
      $softwareSuggestions[[3]]$sameAs
      [1] "https://CRAN.R-project.org/package=commonmark"
      
      
      
      $softwareRequirements
      list()
      
      $citation
      $citation[[1]]
      $citation[[1]]$`@type`
      [1] "SoftwareSourceCode"
      
      $citation[[1]]$datePublished
      [1] "2020"
      
      $citation[[1]]$author
      $citation[[1]]$author[[1]]
      $citation[[1]]$author[[1]]$`@type`
      [1] "Organization"
      
      $citation[[1]]$author[[1]]$name
      [1] "R Core Team"
      
      
      
      $citation[[1]]$name
      [1] "R: A Language and Environment for Statistical Computing"
      
      $citation[[1]]$url
      [1] "https://www.R-project.org/"
      
      
      

