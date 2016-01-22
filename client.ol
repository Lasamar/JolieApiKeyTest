include "file.iol"
include "console.iol"
include "config.iol"
include "apiKeyInterface.iol"
include "serviceTwointerface.iol"
include "serviceOneInterface.iol"
include "clientInterface.iol"

execution { concurrent }

inputPort ClientPort{
  Location: "socket://localhost:3000"
  Protocol: http { .format -> format; .default = "default" }
  Interfaces: ClientInterface
}

outputPort ApiKeyService {
  Location : ApiKey_Location
  Protocol : sodep
  Interfaces : ApiKeyInterface
}

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

define fillApi {
  checkDataRequest.apiKey.idSender = sApiKey.idSender;
  checkDataRequest.apiKey.generatedTime = sApiKey.generatedTime;
  checkDataRequest.apiKey.data = sApiKey.data;
  checkDataRequest.apiKey.hash = sApiKey.hash
}

define helloHandlerResponse {
    if( sApiKey instanceof void ){
      response.msg = " La risposta non e` valida"
    } else {
      checkDataRequest.id = "ClientPort";
      fillApi;
      println@Console("arrivata risposta dal Servizio...")();
      checkData@ApiKeyService( checkDataRequest )( checkDataResponse );
      println@Console("I dati arrivati sono stati controllati...")();
      if(checkDataResponse.abilitated){
        if(checkDataResponse.check){
          println@Console("Passo i dati alla response del client..")();
          response.msg = sApiKey.data
        } else {
          response.msg = "La risposta e` corrotta"
        }
        } else {
          response.msg = "La risposta non puo` essere letta."
        }
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
    if( ApiKeyResponse.abilitated == true ){
      if( request.service == "one" ){
        hello@ServiceOne( ApiKeyResponse.apiKey )( sApiKey );
        helloHandlerResponse
      } else if ( request.service == "two" ) {
        hello@ServiceTwo( ApiKeyResponse.apiKey )( sApiKey );
        helloHandlerResponse
      } else {
        response.msg = " Non risulta nessun servizio con questo id."
      }
    } else {
      response.msg = "Il client non e` abilitato all'utilizzo delle ApiKey."
    }
  }] { nullProcess }
  }
