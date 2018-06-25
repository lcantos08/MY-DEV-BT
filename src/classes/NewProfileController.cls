public class NewProfileController {
    private static final String ATHENA_URL = ' http://athena-developer-edition.ap1.force.com/';
    public UserProfile__c userProfile{get; set;}  
    
    public String userEmail{get; set;}
    public Boolean activationLink{get; set;}
      
    public NewProfileController () {
          userProfile = new UserProfile__c();
    }
    
    /** Checks if the email already exists */
    private Boolean emailExists(String email)
    {
        Integer count = [SELECT count() from UserProfile__c WHERE Email__c = :email];
        if (count == 0)
            return false;
        else
            return true;    
    }
    /* Sends the Profile link to the email */
    public PageReference sendProfile()
    {
        UserProfile__c a = new UserProfile__c(Email__c = userEmail);
   
        Pattern MyPattern = Pattern.compile('^\\w+[\\w-\\.]*\\@\\w+((-\\w+)|(\\w*))\\.[a-z]{2,3}$'); /*Validate email using regex*/
        Matcher MyMatcher = MyPattern.matcher(userEmail); 
        
        Boolean hasMatch = MyMatcher.matches();
        if (hasMatch)
        {
            if (emailExists(userEmail))
            {
                emailProfileLink(userEmail);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please check your email for the profile link.');
                ApexPages.addMessage(myMsg);
                userProfile.clear();
                return null;          
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Email does not exist in the database. Please register first.');
                ApexPages.addMessage(myMsg);            
            }
        }
        else
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please input a valid email address.');
            ApexPages.addMessage(myMsg);            
        }
        return null;
    
    }
    public void emailProfileLink(String email)
    {
        UserProfile__c theProfile = [SELECT ID,FirstName__c,   Token__c FROM UserProfile__c WHERE Email__c = :email];
        
        String theURL = ATHENA_URL + 'Profile?id=' + theProfile.ID + '&Token=' + theProfile.Token__c;
        Email__c theEmail = new Email__c();
        theEmail.Template__c = 'SEND_PROFILE_LINK';
        theEmail.Sender__c = 'psodchallenge@gmail.com';
        theEmail.Sender_Name__c = 'Athena';
        theEmail.Recipient__c = email;
        //theEmail.Recipient__c = 'psodchallenge@gmail.com';  //TODO - CHange to email
        theEmail.Recipient_Name__c = theProfile.FirstName__c;
        theEmail.Link__c = theURL;
        
        insert theEmail;

    }
    public PageReference emailActivationLink() {
        emailProfileLink(userProfile.Email__c);  
        activationLink = false;
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Activation link sent.');
        ApexPages.addMessage(myMsg); 
        return null;
        
    }
    public PageReference register() {
        if (userProfile.Location__c == 'Select Location'  | userProfile.Location__c == null)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a location');
            ApexPages.addMessage(myMsg);
            return null;
        
        }
        //Checks if the email already exists in the database
        if (!emailExists(userProfile.Email__c))
        {        
            insert userProfile;        
            emailProfileLink(userProfile.Email__c);
            userProfile = new UserProfile__c();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Thank you for registering. Please check your email for the profile link.');
            ApexPages.addMessage(myMsg);
            userEmail = ''; /* Clear the userEmail */        
            return null;
        }
        else 
        {
            UserProfile__c uProfile = [SELECT ID, Date_Activated__c from UserProfile__c WHERE Email__c = :userProfile.Email__c];
            if (uProfile.Date_Activated__c == null)
            {
                activationLink = true; 
                return null;                                   
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Email already exists. Please register using a different email.');
                ApexPages.addMessage(myMsg);
            }
        }
        //Todo Email user that he/she can now view his/her profile through his/her email
        return null;
    }
    static testMethod void newProfileControllerTest() {
        PageReference newProfilePage = Page.NewProfile;
        Test.setCurrentPage(newProfilePage);  
        
        UserProfile__c existingProfile = [Select Email__c from UserProfile__c Limit 1];
        NewProfileController newProfileController = new NewProfileController();
        newProfileController.userEmail = 'no@email.com';
        newProfileController.sendProfile();
        newProfileController.userEmail = '';
        newProfileController.sendProfile();
        newProfileController.userEmail = existingProfile.Email__c;
        newProfileController.sendProfile();
            
        newProfileController.userProfile.Location__c  = 'Select Location';      
        newProfileController.register();
        
        newProfileController.userProfile.FirstName__c = 'Joey';
        newProfileController.userProfile.LastName__c  = 'Chan';
        newProfileController.userProfile.Email__c     = existingProfile.Email__c;
        newProfileController.userProfile.Location__c  = 'Philippines';
        
        newProfileController.register();
        
        newProfileController.userProfile.FirstName__c = 'Joey';
        newProfileController.userProfile.LastName__c  = 'Chan';
        newProfileController.userProfile.Email__c     = 'test@myemail.com';
        newProfileController.userProfile.Location__c  = 'Philippines';
        newProfileController.register();
        
    }
}