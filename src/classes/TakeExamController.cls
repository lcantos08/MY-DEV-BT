/*
    Take Exam page made by Joey.     
        
    This page will show the details of the Examination and will also handle the splash page for starting and resuming exams
*/
public class TakeExamController {
    
    public ID examID {get; set;}
    public String userEmail{get; set;}
    public Examination__c exam {get; set;}    
    public Boolean startExam {get; set;} // Boolean for enabling or disabling the start exam button
    public Boolean resumeExam{get; set;}
    
    private UserProfile__c userProfile;
    private User_Examination__c userExam;
    private ID userExamID; /** */
    
    private static final String ATHENA_URL = ' http://athena-developer-edition.ap1.force.com/';
    

    public TakeExamController()
    {
        examID = ApexPages.currentPage().getParameters().get('id'); //Examination
        userExamID = ApexPages.currentPage().getParameters().get('userExamID'); //User Examination
        String token = ApexPages.currentPage().getParameters().get('token');
        
        /** Validate token*/
        if (token != null & userExamID != null )
        {
            try{
            userExam =  [SELECT CreatedDate, Status__c FROM User_Examination__c WHERE ID = :userExamID AND Token__c = :token];            
            }
            catch( System.QueryException e )
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Examination link already expired. Please generate a new one.');
                ApexPages.addMessage(myMsg);    
                startExam = false;   
                return;
            }
            Integer count = [SELECT count() FROM User_Examination__c WHERE ID = :userExamID AND Token__c = :token];
            
            if ( count > 0 )
            {
                startExam = true;                                    
                if (ApexPages.currentPage().getParameters().get('resumeExam') == 'true')
                    resumeExam = true; 
                else
                    resumeExam = false;                                    
            }
            else
                startExam = false;                
   
            /*
            if (userExam.CreatedDate + 1 < System.now() & userExam.Status__c == 'New') //Specifies a 1 day expiry
            {
                startExam = false;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Examination link already expired. Please generate a new one.');
                ApexPages.addMessage(myMsg);       
            }
            */
            
            
        }
        
        if (examID != null)
            exam = [SELECT ID, Name, Name__c, Description1__c, Description2__c FROM Examination__c WHERE ID=:examID] ;
        else
            exam = new Examination__c();    
        
    }
    
    public PageReference checkParameters()
    {
        if (examID == null)       
            return Page.Exception;        
        else
            return null;        
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
    
    
    /** sendExamLink action button*/
    public PageReference sendExamLink()
    {
        Pattern MyPattern = Pattern.compile('^\\w+[\\w-\\.]*\\@\\w+((-\\w+)|(\\w*))\\.[a-z]{2,3}$'); /*Validate email using regex*/
        Matcher MyMatcher = MyPattern.matcher(userEmail); 
        
        Boolean hasMatch = MyMatcher.matches();
        if (hasMatch)
        {
            if (emailExists(userEmail)) //Check if a valid email
            {            
                userProfile = [SELECT ID, Name, Date_Activated__c FROM UserProfile__c WHERE Email__c = :userEmail ];
                
                //Get incomplete exams
                Integer incExams =[Select count() from User_Examination__c u WHERE u.Status__c = 'Ongoing' AND u.Examination_ID__r.Id = :exam.ID AND u.User_ID__r.Name = :userProfile.Name];
                if (incExams == 0)/** No pending exams*/
                {
                    if (userProfile.Date_Activated__c != null)
                    {
                        userExam = new User_Examination__c();
                        userExam.User_ID__c = userProfile.ID;
                        userExam.Examination_ID__c = exam.ID;
                        userExam.Status__c = 'Ongoing';     
                        INSERT userExam;
                        emailExamLink(userEmail);
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please check your email for the examination link');
                        ApexPages.addMessage(myMsg);
                    }
                    else /** Account not yet activated*/
                    {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An activation link has been sent to your email. Please activate your account first before taking an exam.');
                        ApexPages.addMessage(myMsg); 
                    }
                           
                }
                else /** Has pending exams*/
                { 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You still have a pending examination. An email has been sent to your profile for you to view your pending exams.');
                    ApexPages.addMessage(myMsg); 
                    emailProfileLink(userEmail );
                          
                //Send a link to the profile where the person could resume exams.
                }            
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Email not found in the system. Please create a new profile in the Profile page. ');
                ApexPages.addMessage(myMsg);
                //return Page.NewProfile;
            }        
        }
        else
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please input a valid email address.');
            ApexPages.addMessage(myMsg);            
        }
        
        return null;
    }
    /** Command button that starts the exam.
        Redirects to Beejay's Page
    */
    public PageReference startExam() 
    {   
        userExam = [SELECT ID, Token__c FROM User_Examination__c WHERE ID = :userExamID];
        /** This page redirects to Beejay's Exam Page*/
        return new PageReference('/apex/examPage?userExamID='+ userExam.ID + '&token='+userExam.Token__c);             
    }
    
    /**Sends an email that will give the examination link to the user*/
    private void emailExamLink(String email)
    {
    
        userExam = [SELECT ID, Examination_ID__r.Name__c,  User_ID__r.FirstName__c, Token__c FROM User_Examination__c WHERE ID = :userExam.ID];
        
        String theURL = ATHENA_URL +'TakeExam?userExamID='+ userExam.ID + '&id='+exam.id+ '&token='+userExam.Token__c;        
        
        Email__c theEmail = new Email__c();
        theEmail.Template__c = 'SEND_EXAM_LINK';
        theEmail.Sender__c = 'psodchallenge@gmail.com';
        theEmail.Sender_Name__c = 'Athena';
        theEmail.Recipient__c = email;
        //theEmail.Recipient__c = 'psodchallenge@gmail.com';  //TODO - CHange to email
        theEmail.Recipient_Name__c = userExam.User_ID__r.FirstName__c;
        theEmail.Exam_Name__c = userExam.Examination_ID__r.Name__c;
        theEmail.Link__c = theURL;
        
        insert theEmail;        
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
    static testMethod void takeExamControllerTest() {
        
        PageReference takeExamPage = Page.TakeExam;
        Test.setCurrentPage(takeExamPage);    
        
        User_Examination__c theExam = [Select Id, Token__c, User_ID__r.Email__c, Examination_ID__c From User_Examination__c Where Examination_ID__c != null   Limit 1];
        TakeExamController takeExamController = new TakeExamController();
        takeExamController.checkParameters();
        ApexPages.currentPage().getParameters().put('id', theExam.Examination_ID__c);
        takeExamController = new TakeExamController();
        takeExamController.checkParameters();
        takeExamController.userEmail = '';
        takeExamController.sendExamLink();
        takeExamController.userEmail = theExam.User_ID__r.Email__c;
        takeExamController.sendExamLink();
        takeExamController.emailExists('asdf');
        
        ApexPages.currentPage().getParameters().put('userExamID', theExam.Id);
        ApexPages.currentPage().getParameters().put('token', 'asdf'); 
        takeExamController = new TakeExamController();
        ApexPages.currentPage().getParameters().put('token', theExam.Token__c);     
        takeExamController = new TakeExamController();
        
        
        
        theExam = [Select Id, Token__c, User_ID__r.Email__c, Examination_ID__c From User_Examination__c Where Examination_ID__c != null And Status__c = 'OnGoing'  Limit 1];            
        takeExamController = new TakeExamController();
        takeExamController.checkParameters();
        ApexPages.currentPage().getParameters().put('id', theExam.Examination_ID__c);
        takeExamController = new TakeExamController();
        takeExamController.checkParameters();
        takeExamController.userEmail = '';
        takeExamController.sendExamLink();
        takeExamController.userEmail = theExam.User_ID__r.Email__c;
        takeExamController.sendExamLink();
        takeExamController.emailExists('asdf');
        
        ApexPages.currentPage().getParameters().put('userExamID', theExam.Id);
        ApexPages.currentPage().getParameters().put('token', 'asdf'); 
        takeExamController = new TakeExamController();
        ApexPages.currentPage().getParameters().put('token', theExam.Token__c);     
        takeExamController = new TakeExamController();
    }
}