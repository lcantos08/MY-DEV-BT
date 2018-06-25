global class MyWebService {
    
    private static string secret = '6Lef3MQSAAAAAF1lg4yPatT0bbn7P9rR87vx4A7A';
    private string publicKey { get { return '6Lef3MQSAAAAAHGK8ikIa-VEhEMQe8JNSpohVwBK' ; }}
    private static string baseUrl = 'http://api-verify.recaptcha.net/verify';
   
    public static Boolean correctResponse { get; private set; } { correctResponse = false; }

    webService static boolean verify(string cha, string resp) {
      system.debug( 'verify called ');

      
      HttpResponse r = makeRequest(  baseUrl ,

           'privatekey='+ secret +

           '&remoteip=' + remoteHost +

           '&challenge=' + cha +

               '&response=' + resp +

               '&error=incorrect-captcha-sol'

      );
         
          if ( r != null ) {  // is null when test methods run

            return correctResponse = ( r.getBody().contains('true') );

          }
         // if (!correctresponse)reset();

          return false; 

    }
    private static HttpResponse makeRequest(string url, string body)  {

          HttpRequest req = new HttpRequest();  

          HttpResponse respons = null;

          req.setEndpoint( url );

          req.setMethod('POST');

          req.setBody ( body);

          try {

            Http http = new Http();

            respons = http.send(req);

            System.debug('response: '+ respons );

            System.debug('body: '+ respons .getBody());

            

          } catch( System.Exception e) {

             System.debug('ERROR: '+ e);

          }

          return respons ;

        }  
    private static string remoteHost { get { string ret = '127.0.0.1';
        map<string , string> hdrs = ApexPages.currentPage().getHeaders();

        if ( hdrs.get('x-original-remote-addr') != null)

            ret =  hdrs.get('x-original-remote-addr');

        else if ( hdrs.get('X-Salesforce-SIP') != null)

            ret =  hdrs.get('X-Salesforce-SIP');

        return ret;

    } }
}