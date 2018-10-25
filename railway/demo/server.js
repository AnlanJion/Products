var http = require('http');
var fs=require("fs");
 var server=http.createServer(function(request,response){
     fs.readFile("list.html",function(err,data){
      if(err){
          console.log(err)
      }
      response.write(data.toString())
  })
});
     server.listen(3000,'172.16.6.86',function(){
         console.log('启动')
     });

