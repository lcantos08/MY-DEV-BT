/*
Made by Joey: 
Controller for editing or viewing of the user's profile.
It includes the viewing of the badges and the facility to resume exams.
It also activates the user account if incase it hasn't been activated yet
*/

public class ProfileController {
    public ID  userID{get; set;} 
    private String token;
    private String oldEmail;
    public Boolean editMode{get; set;}
    public UserProfile__c userProfile {get; set;}  
    
    public PageReference checkParameters()
    {
        if (userID== null)       
            return Page.Exception;        
        else
        {
            if (editMode)
                activateUserProfile();
            return null;        
        }    
    }    
    public ProfileController()
    {
        userID = ApexPages.currentPage().getParameters().get('id');
        token = ApexPages.currentPage().getParameters().get('token');
        editMode = false;
        /** Validate token*/
        if (token != null )
        {
            Integer temp = [SELECT count() FROM UserProfile__c WHERE ID = :userID AND Token__c = :token];
            if ( temp > 0)
                editMode = true;
            else
                editMode = false;                
        }
        if (userID != null)
        {
            userProfile = [Select Date_Activated__c, Email__c, EmailNewExam__c, EmailResults__c, FirstName__c, Id, LastName__c, Location__c from UserProfile__c 
                                WHERE ID=:userID] ;    
        }        
        else
            userProfile = new UserProfile__c();
    }
    public void activateUserProfile()
    {
        if (userProfile.Date_Activated__c == null)
        {
            userProfile.Date_Activated__c = DateTime.Now();
            update(userProfile); 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Account activated successfully. You may now take exams in the Test Center.');
            ApexPages.addMessage(myMsg);               
            
        }        
    }
    public User_Examination__c[] getBadges()
    {   
        //Condition for a badge. The user should be able to reach the achievement rate first time around.
        User_Examination__c[] completedExams = [Select u.Date_Completed__c, u.Earned_Badge__c, u.Examination_ID__c,u.Examination_ID__r.Badge__c, u.Examination_ID__r.Name__c, u.Score__c, u.Status__c, u.User_ID__c, u.User_ID__r.Id from User_Examination__c u WHERE u.User_ID__r.Id = :userID And u.Status__c = 'Completed' ORDER BY u.Date_Created__c ASC];
        
        Map<string, User_Examination__c> userExamMap = new Map<String, User_Examination__c>();
        
        for(User_Examination__c userExam : completedExams ){
           if (!userExamMap.containsKey(userExam.Examination_ID__c))
               userExamMap.put(userExam.Examination_ID__c, userExam);
        }
        User_Examination__c[] firstExams = userExamMap.values();

        List<User_Examination__c> theExams =  new List<User_Examination__c>();
        for(User_Examination__c userExam : firstExams ){     
           if (userExam.Earned_Badge__c == 'True' )
                theExams.add(userExam);                   
        }

         
        return theExams;
    }
    public User_Examination__c[] getIncompleteExams()
    {        
        return  [Select u.Token__c, u.Examination_ID__c,u.ID, u.Examination_ID__r.Name__c, u.Status__c, u.User_ID__c, u.User_ID__r.Id from User_Examination__c u WHERE u.User_ID__r.Id = :userID And u.Status__c = 'Ongoing'];
    }
    public PageReference save() {
        try 
        {
            upsert(userProfile);            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Profile updated successfully.');
            ApexPages.addMessage(myMsg);                   
        } 
        catch(System.DMLException e) 
        {
            ApexPages.addMessages(e);
            return null;
        }
        return null;       
    }
    
    static testMethod void profileControllerTest() {
        /* Instantiate the current page*/
        PageReference profilePage = Page.Profile;
        Test.setCurrentPage(profilePage);       
        
        ProfileController profileController = new ProfileController();      
        profileController.checkParameters().getUrl();
        Test.setCurrentPage(profilePage);
        
        UserProfile__c testProfile = [Select Id, Token__c From UserProfile__c Limit 1];
        
        ApexPages.currentPage().getParameters().put('id', testProfile.Id);
        profileController = new ProfileController();
        
        ApexPages.currentPage().getParameters().put('token', testProfile.Token__c);     
        
        /* Editable Profile*/
        profileController = new ProfileController();
        profileController.editMode = true;
        profileController.activateUserProfile();
        profileController.checkParameters();
        profileController.getBadges();
        profileController.getIncompleteExams();             
        profileController.save();
        
        /* Viewing profile */
        profileController = new ProfileController();
        profileController.editMode = false;     
        profileController.getBadges();
        profileController.getIncompleteExams();             
        profileController.save();
    }
    
}