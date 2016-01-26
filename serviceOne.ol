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
    println@Console("Entro nella courier")();
    checkData@ApiKeyService( request.apiKey )( check );
    if(check){
      println@Console("qui la cosa si fa grama")();
      request = request.apiKey.data;
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
  response.apiKey = ApiKeyResponse;
  println@Console("Se siamo arrivati fino a qui...")()
}

main {
  hello( request )( response ){
    answer = "Hello World from Service One to " + request.data;
    response = answer;
    CompleteProc
  }
}
