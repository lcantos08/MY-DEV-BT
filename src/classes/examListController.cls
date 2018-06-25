public class examListController 
{
    private static final String ATHENA_URL = ' http://athena-developer-edition.ap1.force.com/';
    public List<Examination__c> SearchExams = new List<Examination__c>();
    public String examName {get; set;}
    public String email {get; set;}
    public Boolean isSearchResult {get; set;}
    public String TabInFocus {get; set;}

    public examListController()
    {
        SearchExams = [SELECT e.Name__c, e.Date_Added__c, e.Description1__c from Examination__c e ORDER BY e.Name__c];
        isSearchResult = false;
    }
   
    public PageReference searchExamsAction()
    { 
        examName = examName.trim();
        if(examName == '')
        {
            SearchExams = [SELECT e.Name__c, e.Date_Added__c, e.Description1__c from Examination__c e ORDER BY e.Name__c];
        }
        else
        {
            SearchExams = [SELECT e.Name__c, e.Date_Added__c, e.Description1__c from Examination__c e WHERE (e.Name__c LIKE :'%' + examName + 
                '%' OR e.Description1__c LIKE :'%' + examName + '%' OR e.Description2__c LIKE :'%' + examName + '%') ORDER BY e.Name__c];
               
            if(SearchExams.isEmpty() || SearchExams == null)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Sorry, no records were found for ' + examName + '.');
                ApexPages.addMessage(myMsg);
            }
            
        }
        isSearchResult = true;
        return null;   
    }  
    
    public PageReference viewAllExamsAction()
    {   
        examName = '';
        SearchExams = [SELECT e.Name__c, e.Date_Added__c, e.Description1__c from Examination__c e ORDER BY e.Name__c];

        isSearchResult = false;
        return null;    
    }      
   
    public List<Examination__c> getSearchExams()
    {
        return SearchExams;
    }
   
    public Boolean isExistingEmail(String email)
    {
        Integer count = [SELECT count() from UserProfile__c WHERE Email__c = :email];
        if (count == 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }
    
    public PageReference sendEmailAction()
    {
        Pattern MyPattern = Pattern.compile('^\\w+[\\w-\\.]*\\@\\w+((-\\w+)|(\\w*))\\.[a-z]{2,3}$');
        Matcher MyMatcher = MyPattern.matcher(email); 
        Boolean hasMatch = MyMatcher.matches();
        
        if(hasMatch)
        {
            if(isExistingEmail(email))
            {
                UserProfile__c userProfile = [SELECT Id, FirstName__c, Date_Activated__c FROM UserProfile__c WHERE Email__c = :email];
                
                if (userProfile.Date_Activated__c == null)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An activation link has been sent to your email. Please activate your account first before taking an exam.');
                    ApexPages.addMessage(myMsg);              
                }
                else
                {            
                    User_Examination__c userExamToInsert = new User_Examination__c();
                    userExamToInsert.User_ID__c = userProfile.Id;
                    userExamToInsert.Status__c = 'New';
                    INSERT userExamToInsert;
                    
                    User_Examination__c userExam = [SELECT Id, Token__c FROM User_Examination__c WHERE User_ID__c = :userProfile.Id AND Status__c = 'New' AND Examination_ID__c = null LIMIT 1];
                    String theURL = ATHENA_URL +'TakeChallenge?userExamID='+ userExam.ID + '&token='+userExam.Token__c; 
                    
                    Email__c theEmail = new Email__c();
                    theEmail.Template__c = 'CHALLENGE';
                    theEmail.Sender__c = 'psodchallenge@gmail.com';
                    theEmail.Sender_Name__c = 'Team ATHENA';
                    theEmail.Recipient__c = email;
                    theEmail.Recipient_Name__c = userProfile.FirstName__c;
                    theEmail.Link__c = theURL;
                    INSERT theEmail;
                    
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please check your email for the Challenge link.');
                    ApexPages.addMessage(myMsg); 
                }
            }  
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Email not found in the system. Please create a new profile in the Profile page.');
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
    
 
}