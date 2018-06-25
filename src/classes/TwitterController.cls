public with sharing class TwitterController {

    public string Result{get;set;}
    public string messageTweet{get;set;}
    
    public void tweet(){
        Twitter t = new twitter();
        result = t.updateTweet(messageTweet);
    }

}