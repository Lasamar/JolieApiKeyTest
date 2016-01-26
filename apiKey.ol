include "apiKeyInterface.iol"
include "console.iol"
include "time.iol"
include "configAK.iol"
include "message_digest.iol"

execution { concurrent }

inputPort ApiKeyService {
  Location : ApiKey_Location
  Protocol : sodep
  Interfaces : ApiKeyInterface
}

outputPort ApiKeyService {
  Location : ApiKey_Location
  Protocol : sodep
  Interfaces : ApiKeyInterface
}

main {
// Function to generate hash code based on Request Data, Request Generated Time, Request ID, SecretWord

  [ generatedHash( request )( response ){
    md5@MessageDigest(request.data + request.gt + SecretWord + request.id )( hash );
    response = hash
  }] { nullProcess }
  
  // Function to generate an ApiKey

  [ generatedApiKey( request )( response ){
      getCurrentTimeMillis@Time()( gt );
      response.generatedTime = gt;
      response.data = request.data;
      response.idSender = request.id;
      hashDemand.id = request.id;
      hashDemand.gt = gt;
      hashDemand.data = request.data;
      generatedHash@ApiKeyService( hashDemand )( hash );
      response.hash = hash
  }] { nullProcess }

// Function to validate the consistency of the data

  [ checkData( request )( response ){
      hashDemand.id = request.idSender;
      hashDemand.gt = request.generatedTime;
      hashDemand.data = request.data;
      generatedHash@ApiKeyService( hashDemand )( hash );
      if( request.apiKey.hash == hash ){
        response.check = true
      } else {
        response.check = false
      }
    }] { nullProcess }
}
