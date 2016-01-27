include "config.iol"
include "apiKeyInterface.iol"

type ServiceOne_string : string {
  .apiKey : ApiKey
}

interface ServiceOneSurface {
  RequestResponse:
   hello( ServiceOne_string )( ServiceOne_string )
}

outputPort ServiceOne{
  Location : One_location
  Protocol : sodep
  Interfaces : ServiceOneSurface
}
