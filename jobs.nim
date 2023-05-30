from std/json import JsonNode, parseFile, parseJson, pretty, add, `[]`, `%*`
from std/httpclient import HttpClient, newHttpClient
from std/os import absolutePath, getCurrentDir
from "./modules/config.nim" import Config, newConfig
from "./modules/links.nim" import getSearchParams, toSearchLink
from "./modules/scraper.nim" import JobLink, getSearchPage, getLinksFromPage

let configJson: JsonNode = parseFile("./config.json")
let jobConfig: Config = configJson.newConfig()
var client: HttpClient = newHttpClient()

let searchLink: string = jobConfig.getSearchParams().toSearchLink()
let searchPage: string = client.getSearchPage(searchLink)
let jobLinks = searchPage.getLinksFromPage()

var linkJson: JsonNode = parseJson("{\"jobs\":[]}")
for linkGroup in jobLinks:
  linkJson["jobs"].add(%*linkGroup)

writeFile("output.json", linkJson.pretty())
echo "Search link: " & searchLink
echo "Jobs found: " & $jobLinks.len()
echo "Output file: " & absolutePath("./output.json", getCurrentDir())