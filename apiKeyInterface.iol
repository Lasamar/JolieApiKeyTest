type generatedHashRequest : void {
  .id : string
  .gt : long
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

type generatedApiKeyResponse : void {
  .abilitated : bool
  .apiKey : ApiKey
}

type checkDataRequest : void {
  .id : string
  .apiKey : ApiKey
}

type checkDataResponse : void {
  .abilitated : bool
  .check : bool
}

interface ApiKeyInterface {
  RequestResponse:
    isAbilitated( string )( bool ),
    generatedHash( generatedHashRequest )( string ),
    generatedApiKey( generatedApiKeyRequest )( generatedApiKeyResponse ),
    checkData( checkDataRequest )( checkDataResponse )
}
