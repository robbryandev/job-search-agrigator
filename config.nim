import std/json

type Config* = object
  sources*, titles*, keywords*, exclude*: seq[string]

proc newConfig*(configJson: JsonNode): Config =
  result = Config(
    sources: configJson["sources"].to(seq[string]),
    titles: configJson["titles"].to(seq[string]),
    keywords: configJson["keywords"].to(seq[string]),
    exclude: configJson["exclude"].to(seq[string])
  )