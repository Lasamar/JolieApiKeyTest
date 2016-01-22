include "serviceOneInterface.iol"
include "apiKeyInterface.iol"
include "config.iol"
include "console.iol"

execution { concurrent }

inputPort ServiceOne{
  Location : One_location
  Protocol : sodep
  Interfaces : ServiceOneInterface
}

outputPort ApiKeyService {
  Location : ApiKey_Location
  Protocol : sodep
  Interfaces : ApiKeyInterface
}


define fillApi2 {
  response.idSender = ApiKeyResponse.apiKey.idSender;
  response.generatedTime = ApiKeyResponse.apiKey.generatedTime;
  response.data = ApiKeyResponse.apiKey.data;
  response.hash = ApiKeyResponse.apiKey.hash
}

define fillApi {
  checkDataRequest.apiKey.idSender = request.idSender;
  checkDataRequest.apiKey.generatedTime = request.generatedTime;
  checkDataRequest.apiKey.data = request.data;
  checkDataRequest.apiKey.hash = request.hash
}

define CompleteProc {
  println@Console("avvio procedura risposta...")();
  generatedApiRequest.id = "ServiceOne";
  generatedApiRequest.data = answer;
  generatedApiKey@ApiKeyService( generatedApiRequest )( ApiKeyResponse );
  fillApi2
}

main {
  hello( request )( response ){
    println@Console("Inizio gestione richiesta...")();
    checkDataRequest.id = "ServiceOne";
    fillApi;
    println@Console("Mi preparo a verificare la validita dei dati...")();
    checkData@ApiKeyService( checkDataRequest )( checkDataResponse );
    if(checkDataResponse.abilitated){
      if(checkDataResponse.check){
        println@Console("il dato risulta valido... Preparo risposta...")();
        answer = "Hello World from Service One to " + request.data;
        CompleteProc
      } else {
        answer = "La richiesta al Service One  e` corrotta.";
        CompleteProc
      }
    } else {
      answer = "Il Service One non e` abilitato a rispondere.";
      CompleteProc
    }
  }
}
