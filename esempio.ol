interface extender ClientExtender{
  RequestResponse:
    *(apiKey)
}

inputPort ClientService{
  Location: "local"
  Protocol: sodep
  Interfaces: ClientInterface
}

outputPort ClientService{
  Location: "local"
  Protocol: sodep
  Interfaces: ClientInterface
}

inputPort ClientPort{
  Location: "socket://localhost:3000"
  Protocol: http { .format -> format; .default = "default" }
  Aggregates: ClientService with ClientExtender
}

outputPort ApiKeyService {
	Interfaces: ApiKey
}

embedded {
	Jolie: "ApiKey\apiKey.ol" in TwiceService
}

courier ClientService{
  [interface ClientInterface( request )( response )]{
    checkData@ApiKeyService( request.apiKey )( check );
    if(check){
      forward( request.data )
    } else {
      throw( error )
    }
  }
}
