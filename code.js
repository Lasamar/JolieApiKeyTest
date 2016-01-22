function hello(operation, servizio){
  if( $('#nome').val() != ""){
  var request = { service : servizio , name : $('#nome').val()};
  $.ajax({
    url:'/'+ operation,
    dataType:'json',
    data: JSON.stringify( request ),
    type: 'POST',
    contentType: 'application/json',
    success: function( data ){
      $('#msg').html(data.msg);
    },
    error: function(){
      console.log('errore sulla funzione ajax');
    }
  }) }
  else {
    $('#msg').html("Inserire un nome valido prego");
  }
}
