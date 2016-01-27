include "file.iol"
include "console.iol"
include "config.iol"
include "apiKeyInterface.iol"
include "serviceTwointerface.iol"
include "serviceOneSurface.iol"
include "clientInterface.iol"

execution { concurrent }

// Output Ports



outputPort ServiceTwo{
  Location : Two_location
  Protocol : sodep
  Interfaces : ServiceTwoInterface
}

outputPort ApiKeyService {
  Location: "local"
  Protocol: sodep
  Interfaces: ApiKeyInterface
}

// Input Ports
inputPort ClientPort{
  Location: "socket://localhost:3000"
  Protocol: http { .format -> format; .default = "default" }
  Interfaces: ClientInterface
}

// Embedded Services

embedded {
	Jolie: "apiKey.ol" in ApiKeyService
}

define CompleteProc{
  checkData@ApiKeyService( return.apiKey )( check );
  if( check == true ){
    response.msg = return.apiKey.data
  } else {
    response.msg = "Error"
  }
}

define fillRequest {
  sR.apiKey.idSender = ApiKeyResponse.idSender;
  sR.apiKey.generatedTime = ApiKeyResponse.generatedTime;
  sR.apiKey.data = ApiKeyResponse.data;
  sR.apiKey.hash = ApiKeyResponse.hash;
  sR = ApiKeyResponse.data
}

main {
  [ default( request )( response ){
    format = "html";
    file.filename = request.operation;
    readFile@File( file )( response)
  }] { nullProcess }

  [ helloClient( request )( response ){
    format = "json";
    generatedApiRequest.id = "ClientPort";
    generatedApiRequest.data = request.name;
    generatedApiKey@ApiKeyService( generatedApiRequest )( ApiKeyResponse );
      if( request.service == "one" ){
        fillRequest;
        hello@ServiceOne( sR )( return );
        CompleteProc
      } else if ( request.service == "two" ) {
        fillRequest;
        hello@ServiceTwo( sR )( return );
        CompleteProc
      } else {
        response.msg = " Non risulta nessun servizio con questo id."
      }

  }] { nullProcess }
  }
