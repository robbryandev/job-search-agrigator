from std/json import JsonNode, `[]`, to

type Config* = object
  sources*, titles*, keywords*, match*, exclude*: seq[string]

proc newConfig*(configJson: JsonNode): Config =
  try:
    result = Config(
      sources: configJson["sources"].to(seq[string]),
      titles: configJson["titles"].to(seq[string]),
      keywords: configJson["keywords"].to(seq[string]),
      match: configJson["match"].to(seq[string]),
      exclude: configJson["exclude"].to(seq[string])
    )
  except:
    raise newException(Exception, "Failed to parse config")