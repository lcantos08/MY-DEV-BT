public with sharing class TwitterHttp implements IHttp{

    
    public string send(HttpRequest request){
        Http h= new Http();
        HttpResponse response = h.send(request);
        return response.getBody();
    }


}