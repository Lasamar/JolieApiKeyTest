include "file.iol"
include "console.iol"
include "config.iol"
include "apiKeyInterface.iol"
include "serviceTwointerface.iol"
include "serviceOneInterface.iol"
include "clientInterface.iol"

execution { concurrent }

// Output Ports

outputPort ServiceOne{
  Location : One_location
  Protocol : sodep
  Interfaces : ServiceOneInterface
}

outputPort ServiceTwo{
  Location : Two_location
  Protocol : sodep
  Interfaces : ServiceOneInterface
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
  if( check ){
    response.msg = return.apiKey.data
  } else {
    response.msg = "Error"
  }
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
        sOR.apiKey = ApiKeyResponse;
        hello@ServiceOne( sOR )( return );
        CompleteProc
      } else if ( request.service == "two" ) {
        sTR.apiKey = ApiKeyResponse;
        hello@ServiceTwo( sTR )( return );
        CompleteProc
      } else {
        response.msg = " Non risulta nessun servizio con questo id."
      }

  }] { nullProcess }
  }
