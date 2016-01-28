include "serviceTwoInterface.iol"
include "apiKeyInterface.iol"
include "config.iol"
include "console.iol"
include "runtime.iol"

execution { concurrent }

init {
    getLocalLocation@Runtime()( SO.location )
}

type AddApiKey : string {
  .apiKey : ApiKey
}

interface extender ServiceTwoExtended1{
  RequestResponse:
  *(AddApiKey)(AddApiKey)
}

inputPort SO{
  Location: "local"
  Protocol: sodep
  Interfaces: ServiceTwoInterface
}

outputPort SO{
  Protocol: sodep
  Interfaces: ServiceTwoInterface
}

inputPort ServiceTwo{
  Location : Two_location
  Protocol : sodep
  Aggregates: SO with ServiceTwoExtended1
}

outputPort ApiKeyService {
  Interfaces : ApiKeyInterface
}

// Embedded Services

embedded {
	Jolie: "apiKey.ol" in ApiKeyService
}

define CompleteProc {
  generatedApiRequest.id = "ServiceTwo";
  generatedApiRequest.data = response;
  generatedApiKey@ApiKeyService( generatedApiRequest )( ApiKeyResponse );
  response.apiKey.idSender = ApiKeyResponse.idSender;
  response.apiKey.generatedTime = ApiKeyResponse.generatedTime;
  response.apiKey.data = ApiKeyResponse.data;
  response.apiKey.hash = ApiKeyResponse.hash
}

courier ServiceTwo{
  [interface ServiceTwoInterface( request )( response )]{
    checkData@ApiKeyService( request.apiKey )( check );
    if(check){
      forward( request )( response );
      CompleteProc
    } else {
      throw( error )
    }
  }
}

main {
  hello( request )( response ){
    answer = "Hello World from Service Two to " + request;
    response = answer
  }
}
