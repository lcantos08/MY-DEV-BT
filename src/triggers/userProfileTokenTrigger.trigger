trigger userProfileTokenTrigger on UserProfile__c (before insert, before update) {
        for (UserProfile__c userProfile: Trigger.new) {
        DateTime now = System.now();        
        String formattednow = now.formatGmt('yyyy-MM-dd')+'T'+ now.formatGmt('HH:mm:ss')+'.'+now.formatGMT('SSS')+'Z';        
        Blob bsig = Crypto.generateDigest('MD5', Blob.valueOf(formattednow));        
        String token =  EncodingUtil.base64Encode(bsig);                
        if(token.length() > 255) { token =  token.substring(0,254); }                      
        userProfile.Token__c = Encodingutil.urlEncode(token, 'UTF-8').replaceAll('%','_');
        // Iterate over each sObject
        }
}