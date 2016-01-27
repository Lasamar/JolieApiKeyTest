include "serviceOneInterface.iol"
include "apiKeyInterface.iol"
include "config.iol"
include "console.iol"

execution { concurrent }

type AddApiKey : void {
  .apiKey : ApiKey
}

interface extender ServiceOneExtended1{
  RequestResponse:
  *(AddApiKey)(AddApiKey)
}

inputPort SO{
  Location: "local"
  Protocol: sodep
  Interfaces: ServiceOneInterface
}

outputPort SO{
  Location: "local"
  Protocol: sodep
  Interfaces: ServiceOneInterface
}

inputPort ServiceOne{
  Location : One_location
  Protocol : sodep
  Aggregates: SO with ServiceOneExtended1
}

outputPort ApiKeyService {
  Interfaces : ApiKeyInterface
}

// Embedded Services

embedded {
	Jolie: "apiKey.ol" in ApiKeyService
}

courier ServiceOne{
  [interface ServiceOneInterface( request )( response )]{
    checkData@ApiKeyService( request.apiKey )( check );
    if(check){
      println@Console(request)();
      forward( request )( response )
    } else {
      throw( error )
    }
  }
}

define CompleteProc {
  generatedApiRequest.id = "ServiceOne";
  generatedApiRequest.data = response;
  generatedApiKey@ApiKeyService( generatedApiRequest )( ApiKeyResponse );
  response.apiKey.idSender = ApiKeyResponse.idSender;
  response.apiKey.generatedTime = ApiKeyResponse.generatedTime;
  response.apiKey.data = ApiKeyResponse.data;
  response.apiKey.hash = ApiKeyResponse.hash
}

main {
  hello( request )( response ){
    answer = "Hello World from Service One to " + request.data;
    println@Console(answer)();
    response = answer;
    CompleteProc
  }
}
