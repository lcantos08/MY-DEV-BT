@isTest
private class TestExamListController
{   
    static testMethod void myUnitTest() 
    {
        test.startTest();  
        
        Examination__c examination = new Examination__c 
        (
            Name__c='Adobe Flex',
            Date_Added__c=Datetime.now(),
            Description1__c='This is a sample exam',
            Passing_Rate__c=70
        );
        insert examination;
        
        examListController con = new examListController();
        
        con.viewAllExamsAction();
        con.getSearchExams();
        
        con.examName = '';
        con.searchExamsAction();        
        
        Examination__c examinationObj = [SELECT Name__c FROM Examination__c WHERE Name__c='Adobe Flex' LIMIT 1];
        con.examName = examinationObj.Name__c;
        con.searchExamsAction();
        
        UserProfile__c userProfile = new UserProfile__c
        (
            FirstName__c='Kringle',
            LastName__c='Atanacio',
            Location__c='Philippines',
            Email__c='test@yahoo.com',
            Date_Activated__c=Datetime.now()
        );
        insert userProfile;
        
        UserProfile__c userProfileObj = [SELECT Email__c FROM UserProfile__c WHERE Email__c='test@yahoo.com' LIMIT 1];
        con.email = userProfileObj.Email__c;
        con.sendEmailAction();
        
        UserProfile__c userProfile2 = new UserProfile__c
        (
            FirstName__c='Katrina',
            LastName__c='Atanacio',
            Location__c='Afghanistan',
            Email__c='test2@yahoo.com'
        );
        insert userProfile2;
        
        UserProfile__c userProfileObj2 = [SELECT Email__c FROM UserProfile__c WHERE Email__c='test2@yahoo.com' LIMIT 1];
        con.email = userProfileObj2.Email__c;
        con.sendEmailAction();        
        
        test.stopTest();
    }
}