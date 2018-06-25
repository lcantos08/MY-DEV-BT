@isTest

/*
	Test Methods created by Joey and Kringle

*/
private class TriggerTests
{   
    static testMethod void newExamTriggerTest() 
    {
        test.startTest();  
        
        // Create and insert new Examination
        Examination__c examination = new Examination__c 
        (
            Name__c='Adobe Flex',
            Passing_Rate__c=70
        );
            
        insert examination;
        
        test.stopTest();
    }
    static testMethod void userExamTokenTriggerTest() 
    {
        test.startTest();  
        
        UserProfile__c uProf = [Select Id from UserProfile__c Limit 1];
        User_Examination__c uExam = new User_Examination__c();
        uExam.User_ID__c = uProf.Id;        
        uExam.Date_Created__c = System.now();
        uExam.Status__c = 'New';                    
        insert uExam;
        
        test.stopTest();
    }
    static testMethod void userProfileTokenTriggerTest() 
    {
        test.startTest();  
        
        UserProfile__c uProf = new UserProfile__c();
        uProf.FirstName__c = 'John';
        uProf.LastName__c = 'Doe';
        uProf.Email__c = 'Email@me.com';
        uProf.Location__c = 'Philippines';
        
        insert uProf;
        
        test.stopTest();
    }          
}