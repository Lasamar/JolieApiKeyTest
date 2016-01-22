include "apiKeyInterface.iol"
include "console.iol"
include "time.iol"
include "configAK.iol"
include "message_digest.iol"

execution { concurrent }

inputPort ApiKeyService {
  Location : ApiKey_Location
  Protocol : sodep
  Interfaces : ApiKey
}

outputPort ApiKeyService {
  Location : ApiKey_Location
  Protocol : sodep
  Interfaces : ApiKey
}

main {
  [ isAbilitated( request )( response ){
    println@Console("verifica abilitazione...")();
    abilitated[0] = "ClientPort";
    abilitated[1] = "ServiceOne";
    abilitated[2] = "ServiceTwo";
    for( i = 0, i < #abilitated && response != true, i++ ){
     if(abilitated[i] == request ){
       response = true
     }
    }
  }] { nullProcess }

  [ generatedHash( request )( response ){
    println@Console("genera l'hash")();
    md5@MessageDigest(request.data + request.gt + SecretWord + request.id )( hash );
    println@Console("hash generato: " + hash)();
    response = hash
  }] { nullProcess }

  [ generatedApiKey( request )( response ){
    println@Console( "generatedApiKey inizio processo..." )();
    isAbilitated@ApiKeyService( request.id )( check );
    response.abilitated = check;
    if( response.abilitated == true ){
      println@Console("risulta abilitato inizio preparazione ritorno...")();
      getCurrentTimeMillis@Time()( gt );
      println@Console("genera la data: " + gt)();
      response.apiKey.generatedTime = gt;
      response.apiKey.data = request.data;
      response.apiKey.idSender = request.id;
      hashDemand.id = request.id;
      hashDemand.gt = gt;
      hashDemand.data = request.data;
      generatedHash@ApiKeyService( hashDemand )( hash );
      println@Console("completa la risposta...")();
      response.apiKey.hash = hash;
      println@Console("risposta completata ")()
    }
  }] { nullProcess }

  [ checkData( request )( response ){
    println@Console("Inizio verifica validita risposta...")();
    isAbilitated@ApiKeyService( request.id )( check );
    response.abilitated = check;
    if( response.abilitated == true ){
      println@Console("mi preparo a generare l'hash di controllo...")();
      hashDemand.id = request.apiKey.idSender;
      hashDemand.gt = request.apiKey.generatedTime;
      hashDemand.data = request.apiKey.data;
      println@Console("richiesta pronta...")();
      generatedHash@ApiKeyService( hashDemand )( hash );
      println@Console("hash di confronto pronto...")();
      if( request.apiKey.hash == hash ){
        println@Console("confronto hash positivo...")();
        response.check = true
      } else {
        response.check = false
      }
    }
  }] { nullProcess }
}
