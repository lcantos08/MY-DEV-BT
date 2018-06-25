public with sharing class Twitter{

    public string updateTweet(String tweet){
        String url = 'https://api.twitter.com/1/statuses/update.json';
        String method = 'POST';
        String result='';
        
        TwitterCalloutUtil util = new TwitterCalloutUtil();
        HttpRequest req = util.buildRequest(url, method);
        
        util.HttpInstance = new TwitterHttp();
        result = util.doCallout(req);
        return result;
    }

}