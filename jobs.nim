from std/json import JsonNode, parseFile
from "./config.nim" import Config, newConfig
from "./links.nim" import getSearchParams, toSearchLink

let configJson: JsonNode = parseFile("./config.json")
let jobConfig: Config = configJson.newConfig()

let searchLink: string = jobConfig.getSearchParams().toSearchLink()
echo searchLink