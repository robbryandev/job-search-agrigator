import std/[httpclient, htmlparser, xmltree, strtabs, strutils, json]
from "./config.nim" import Config, newConfig
from "./links.nim" import getSearchParams, toSearchLink

type JobLink* = object
  title, url: string

proc newJobLink*(title, url: string): JobLink =
  result.title = title
  result.url = url

proc getSearchPage*(client: HttpClient, searchLink: string): string =
  return client.getContent(searchLink)

# psoudo code logic for checking if link isn't an ad
# (link.tag.parent.parent.type == "div") && !child("span")
# make sure links 2nd nested parent is a div and does not contain a span element
proc getLinksFromPage*(page: string): seq[JobLink] =
  let xml = page.parseHtml()
  var linkCount: int = 0
  # let divs = xml.findAll("div>div>div>a>h3")
  for startDiv in xml.findAll("div"):
    for secondDiv in startDiv.findAll("div"):
      for thirdDiv in secondDiv.findAll("div"):
        for link in thirdDiv.findAll("a"):
          if link.findAll("h3").len() > 0:
            var url = "no url"
            var title = "no title"
            if link.attrs.hasKey "href":
              url = link.attrs["href"].split("url?q=", 2)[1]
              linkCount.inc()
            for header in link.findAll("h3"):
              for headerDiv in header.findAll("div"):
                title = headerDiv.innerText()
            result.add(newJobLink(title, url))

proc getJobData*(jsonConfig: JsonNode): JsonNode =
  let jobConfig: Config = jsonConfig.newConfig()
  var client: HttpClient = newHttpClient()

  let searchLink: string = jobConfig.getSearchParams().toSearchLink()
  let searchPage: string = client.getSearchPage(searchLink)
  let jobLinks: seq[JobLink] = searchPage.getLinksFromPage()

  var linkJson: JsonNode = parseJson("{\"jobs\":$data, \"count\": $num, \"link\": \"$link\"}".multiReplace(
    ("$data", pretty(%*jobLinks)),
    ("$num", $jobLinks.len()),
    ("$link", searchLink)
  ))

  return linkJson
