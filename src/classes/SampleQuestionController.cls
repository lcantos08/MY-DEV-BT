public class SampleQuestionController
{


private static string secret = '6Lef3MQSAAAAAF1lg4yPatT0bbn7P9rR87vx4A7A';

    public string publicKey { get { return '6Lef3MQSAAAAAHGK8ikIa-VEhEMQe8JNSpohVwBK' ; }}

    private static string baseUrl = 'http://api-verify.recaptcha.net/verify';
    public string challenge {get; set;} { challenge = null; }

    public string response {get; set; }  { response = null; }

    public Boolean correctResponse { get; private set; } { correctResponse = false; }

    public PageReference verify() {
      system.debug( 'verify called ');

      if ( challenge == null || response == null ) {

            system.debug( 'verify called null ');

         //   return null;

          }
      HttpResponse r = makeRequest(  baseUrl ,

           'privatekey='+ secret +

           '&remoteip=' + remoteHost +

           '&challenge=' + challenge +

               '&response=' + response +

               '&error=incorrect-captcha-sol'

      );
         
          if ( r != null ) {  // is null when test methods run

            correctResponse = ( r.getBody().contains('true') );

          }
         // if (!correctresponse)reset();

          return null; 

    }

 
    public PageReference reset() {

        challenge = null;

        response = null;

        return null;

    }  
    public static HttpResponse makeRequest(string url, string body)  {

          HttpRequest req = new HttpRequest();  

          HttpResponse response = null;

          req.setEndpoint( url );

          req.setMethod('POST');

          req.setBody ( body);

          try {

            Http http = new Http();

            response = http.send(req);

            System.debug('response: '+ response);

            System.debug('body: '+ response.getBody());

            

          } catch( System.Exception e) {

             System.debug('ERROR: '+ e);

          }

          return response;

        }  
    public string remoteHost { get { string ret = '127.0.0.1';
        map<string , string> hdrs = ApexPages.currentPage().getHeaders();

        if ( hdrs.get('x-original-remote-addr') != null)

            ret =  hdrs.get('x-original-remote-addr');

        else if ( hdrs.get('X-Salesforce-SIP') != null)

            ret =  hdrs.get('X-Salesforce-SIP');

        return ret;

    } }

     





    public string ex{get;set;}
    public PageReference luis() {
    
        Http h = new Http();
                String remoteUrl = 'https://test.authorize.net/gateway/transact.dll';// csMap.get('AuthorizeNetURL'); 
                
                string SoapXMLBody = 'x_login=74A9wFpU&';// + csMap.get('AuthorizeNetLogin') + '&'; 
                SoapXMLBody += 'x_tran_key=95fqGLX93mvm9G77&';// + csMap.get('AuthorizeNetTransKey') + '&'; 
                SoapXMLBody += 'x_delim_data=' + 'TRUE' + '&';
                SoapXMLBody += 'x_delim_char=' + ';' + '&';
                SoapXMLBody += 'x_relay_response=' + 'FALSE' + '&';
                SoapXMLBody += 'x_type=' + 'CREDIT' + '&';                       
                SoapXMLBody += 'x_card_num=0027';// + paymentTransaction.Credit_card_last_4_digits__c + '&';//last four digit only and This is a mandatory field                       
                
                // Forcebrain.com 1/21/2011
                // @auth ihild: Casey says we are refunding the wrong amount.
                //SoapXMLBody += 'x_amount=' + totalAmount + '&';
                SoapXMLBody += 'x_amount=100&';
                
                SoapXMLBody += 'x_description=' + 'Payment Refund - Galileo Learning Registration' + '&';
                SoapXMLBody += 'x_trans_id=XXXXX&';// + Transaction_No__c;  //+ '&';//This is a mandatory field                        
                            
                Integer ContentLength = 0;
                ContentLength = SoapXMLBody.length();
                
                // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
                HttpRequest req = new HttpRequest();
                req.setEndpoint(remoteUrl);
                req.setMethod('POST');
                
                req.setHeader('Content-type','application/x-www-form-urlencoded');
                req.setHeader('Content-Length',ContentLength.format());
                            
                req.setBody(SoapXMLBody);
                            
                System.Debug(req.getBody());            
                String output = '';                        
                HttpResponse res;
                
              //  try {
                    res = h.send(req);
                    output = res.getBody(); 
                    ex= output;
                 //   lui=output;               
                 //   out = output.split(';',0);
        return null;
    }


  

    public PageReference go() {
        String cid=ApexPages.currentPage().getParameters().get('cid');
        getChoices();
        PageReference p= new PageReference('https://c.ap1.visual.force.com/apex/SampleQuestion?cid'+'='+cid);  
        return null;            
    }

public ID selectedQuestion{get;set;}
  public List<Choice__c> Choices
  {get;set;
  }
  public void getChoices()
  {
  Choices=  [Select Id, Name, Choice__c, Answer__c from Choice__c where Question_ID__r.Id=:selectedQuestion order by Answer__c desc ];
  }

 
 private List<Question__c> questions;
 
 public List<Question__c> getQuestions()
 {
 if (questions==null)
 {
 questions = [Select Name,Id, Difficulty__c, Question__c, Active__c from Question__c limit 10];
 }
 return questions;
 }
 
}