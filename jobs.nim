from std/json import JsonNode, parseFile, parseJson, pretty, toUgly, add, to, `[]`, `%*`
from std/httpclient import HttpClient, Response, newHttpClient
from std/os import paramStr
from std/strutils import parseInt
from "./modules/scraper.nim" import getJobData
import jester

let configJson: JsonNode = parseFile("./config.json")

router apiRouter:
  post "/api/jobs":
    try:
      let jsonRes = getJobData(request.body().parseJson())
      resp(jsonRes.pretty(), contentType="application/json")
    except:
      let error = getCurrentExceptionMsg()
      resp error

proc main() =
  let port = paramStr(1).parseInt().Port
  let settings = newSettings(port=port)
  var jester = initJester(apiRouter, settings=settings)
  jester.serve()

when isMainModule:
  main()