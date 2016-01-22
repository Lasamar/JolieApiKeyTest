type helloRequest : void {
  .service : string
  .name : string 
}

type MsgJson : void {
  .msg : string
}

interface ClientInterface {
  RequestResponse:
    helloClient( helloRequest )( MsgJson ),
    default( undefined )( undefined )
}
