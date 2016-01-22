type ApiKey : void {
  .idSender : string
  .generatedTime : long
  .data : string
  .hash : string
}

interface ServiceOneInterface {
  RequestResponse:
    hello( ApiKey )(ApiKey)
}
