include "config.iol"
include "apiKeyInterface.iol"

type ServiceTwo_string : string {
  .apiKey : ApiKey
}

interface ServiceTwoSurface {
  RequestResponse:
   hello( ServiceTwo_string )( ServiceTwo_string )
}

outputPort ServiceTwo{
  Location : Two_location
  Protocol : sodep
  Interfaces : ServiceTwoSurface
}
