import std/[json, strutils, strformat]
import "./config.nim"

let configJson: JsonNode = parseFile("./config.json")
let jobConfig: Config = configJson.newConfig()

# get search parameters to send to the linkBuilder
proc getSearchParams(config: Config): string =
  # Build a list of strings that will be joined together to form the search query.
  var linkParts: seq[string] = @[]

  # Add the sources to the query.
  linkParts.add(config.sources.join(" | "))

  # Add the titles to the query.
  let titles: string = config.titles.join(" | ")
  linkParts.add(fmt"({titles})")

  # Add the keywords to the query.
  let keywords: string = config.keywords.join(" | ")
  linkParts.add(fmt"({keywords})")

  # Add exact match keywords to the query.
  var match: seq[string] = @[]
  for m in config.match:
    match.add("\"" & m & "\"")
  linkParts.add(match.join(" "))

  # Add the excluded keywords to the query.
  var exclude: seq[string] = @[]
  for ex in config.exclude:
    exclude.add(fmt"-{ex}")
  linkParts.add(exclude.join(" "))

  # Join the list of strings together to form the search query.
  return linkParts.join(" ")

echo getSearchParams(jobConfig)