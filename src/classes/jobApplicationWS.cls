global class jobApplicationWS{


    webservice static Id createJobApplication(Candidate__c cadidate, position__c position){
        Job_Application__c ja= new Job_Application__c();
        ja.Candidate__c = cadidate.Id;
        ja.Position__c= position.Id;
        ja.Status__c = 'New';
        insert ja;
        return ja.Id;
    }

}