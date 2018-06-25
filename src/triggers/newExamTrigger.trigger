/*
Name: newExamTrigger 
Created by: katanacio
Date Created: 08/24/09
Description: This trigger will be used to create email objects
             upon creation of new Examination
*/


trigger newExamTrigger on Examination__c (After Insert) 
{
    String examName;
    
    //Get new exam name
    for(Examination__c newExam: Trigger.new)
    {
        examName = newExam.Name__c;
    }

    //Query all user profiles subscribed to new exam update
    List<UserProfile__c> userProfileList = [SELECT FirstName__c, LastName__c, Email__c FROM UserProfile__c WHERE EmailNewExam__c = true];
    
    for(UserProfile__c userProfile: userProfileList)
    {
        Email__c email = new Email__c
        (
            Exam_Name__c = examName,
            Link__c = 'http://athena-developer-edition.ap1.force.com/',
            Recipient__c = userProfile.Email__c,
            Recipient_Name__c = userProfile.FirstName__c + ' ' + userProfile.LastName__c,
            Sender__c = 'psodchallenge@gmail.com',
            Sender_Name__c = 'TEAM ATHENA',
            Template__c = 'NEW_EXAM'
        );
            
        INSERT email;
    }
}