public with sharing class TwitterCalloutUtil {
    
    public IHttp HttpInstance{get;set;}
    
    public HttpRequest buildRequest(String url, String method){
         HttpRequest req = new HttpRequest();
     req.setEndpoint(url);
     req.setMethod(method);
     
     // Specify the required user name and password to access the endpoint
     // As well as the header and header information

     String username = 'LuiCantos';
     String password = 'hang0ver0305';
     String accessTokenUrl ='https://api.twitter.com/oauth/access_token';
     String consumeryKey ='0XlEebLBWWJ2PotyE4Xeyg';
     String consumerSecret ='FiX39Cvlk20UVzjNDBB23S9nTAwCSMCvbdTLWqRLGPs';
  
     Blob headerValue = Blob.valueOf(username + ':' + password);
     String authorizationHeader = 'BASIC ' +
     EncodingUtil.base64Encode(headerValue);
     req.setHeader('Authorization', authorizationHeader);
     
     
     
     
     
     return req;
    }
    
    
    public String doCallout(HttpRequest request){
        String result='';
        result = HttpInstance.send(request);
        return result;
    }


}