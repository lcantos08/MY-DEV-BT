trigger userExamTokenTrigger on User_Examination__c (before insert, before update) {
        for (User_Examination__c exam : Trigger.new) {
        DateTime now = System.now();        
        String formattednow = now.formatGmt('yyyy-MM-dd')+'T'+ now.formatGmt('HH:mm:ss')+'.'+now.formatGMT('SSS')+'Z';        
        Blob bsig = Crypto.generateDigest('MD5', Blob.valueOf(formattednow));        
        String token =  EncodingUtil.base64Encode(bsig);                
        if(token.length() > 255) { token =  token.substring(0,254); }                      
        exam.Token__c = Encodingutil.urlEncode(token, 'UTF-8').replaceAll('%','_');
        // Iterate over each sObject
        }
}