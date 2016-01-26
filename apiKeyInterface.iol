type generatedHashRequest : void {
  .gt : long
  .id : string
  .data : string
}

type ApiKey : void {
  .idSender : string
  .generatedTime : long
  .data : string
  .hash : string
}

type generatedApiKeyRequest : void {
  .id : string
  .data : string
}

type checkDataResponse : void {
  .check : bool
}

interface ApiKeyInterface {
  RequestResponse:
    generatedHash( generatedHashRequest )( string ),
    generatedApiKey( generatedApiKeyRequest )( ApiKey ),
    checkData( ApiKey )( checkDataResponse )
}
