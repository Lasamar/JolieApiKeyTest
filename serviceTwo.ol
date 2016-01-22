include "serviceTwoInterface.iol"
include "apiKeyInterface.iol"
include "config.iol"
include "console.iol"

execution { concurrent }

inputPort ServiceTwo{
  Location : Two_location
  Protocol : sodep
  Interfaces : ServiceTwoInterface
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
  generatedApiRequest.id = "ServiceTwo";
  generatedApiRequest.data = answer;
  generatedApiKey@ApiKeyService( generatedApiRequest )( ApiKeyResponse );
  fillApi2
}

main {
  hello( request )( response ){
    println@Console("Inizio gestiTwo richiesta...")();
    checkDataRequest.id = "ServiceTwo";
    fillApi;
    println@Console("Mi preparo a verificare la validita dei dati...")();
    checkData@ApiKeyService( checkDataRequest )( checkDataResponse );
    if(checkDataResponse.abilitated){
      if(checkDataResponse.check){
        println@Console("il dato risulta valido... Preparo risposta...")();
        answer = "Hello World from Service Two to " + request.data;
        CompleteProc
      } else {
        answer = "La richiesta al Service Two  e` corrotta.";
        CompleteProc
      }
    } else {
      answer = "Il Service Two non e` abilitato a rispondere.";
      CompleteProc
    }
  }
}
