type ApiKey : void {
  .idSender : string
  .generatedTime : long
  .data : string
  .hash : string
}

interface ServiceTwoInterface {
  RequestResponse:
    hello( ApiKey )(ApiKey)
}
