public class ResultController {
    public boolean displayInvite {get;set;}
    public UserProfile__c Send{get;set;}
    public Email__c Email{get;set;}
    public User_Examination__c User{get;set;}
    private static final String ATHENA = ' http://athena-developer-edition.ap1.force.com/';  
//    public String[] emails = new String[]{};
//    public String[] names = new String[]{};
    public String emailAddress1 {get; set;}
    public String friendName1 {get; set;}
    public String emailAddress2 {get; set;}
    public String friendName2 {get; set;}
    public String emailAddress3 {get; set;}
    public String friendName3 {get; set;}
    public String emailAddress4 {get; set;}
    public String friendName4 {get; set;}
    public String emailAddress5 {get; set;}
    public String friendName5 {get; set;}
    public String status {get;set;}                
    public User_Examination__c Uexam {get; set;} 
    

    public void onInit()
    {
        Uexam = [Select u.Score__c, 
                 u.User_ID__c, 
                 u.User_ID__r.FirstName__c,
                 u.User_ID__r.LastName__c,
                 u.User_ID__r.Email__c,
                 u.User_ID__r.Email_Result_after_Exam__c,
                 u.Perfect_Score__c,
                 u.Examination_ID__r.Promotion_Text__c,
                 u.Examination_ID__r.Passing_Rate__c,
                 u.Examination_ID__r.Name__c 
                 from User_Examination__c u 
                 where u.ID= :ApexPages.currentPage().getParameters().get('userExamID')];
                 
           string score = '' + Uexam.Score__c;
           double ave;
           string eval = '';
           if(Uexam.Examination_ID__r.Name__c == null || Uexam.Examination_ID__r.Name__c == '')
           {
               ave=0;
           }
           else
           {
               ave = ((Uexam.Score__c /Uexam.Perfect_Score__c)*100);
           }
           if (Uexam.User_ID__r.Email_Result_after_Exam__c = true)
           {
                   System.debug('Email results? ' + Uexam.User_ID__r.Email_Result_after_Exam__c);
                   Email__c inform = new Email__c();
                   inform.Link__c = ATHENA;
                   inform.Result__c = score;
                       if (ave >= Uexam.Examination_ID__r.Passing_Rate__c)
                       {
                           inform.Template__c = 'PASSED';
                           eval = 'PASSED';
                       }else{
                           inform.Template__c = 'FAILED';
                           eval = 'FAILED';
                       }
                   if(Uexam.Examination_ID__r.Name__c == null || Uexam.Examination_ID__r.Name__c == '')
                   {
                       inform.Exam_Name__c = 'Challenge';
                       status = 'Is that all you\'ve got?.';
                   }
                   else
                   {
                       inform.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
                       status = 'You ' + eval + ' the exam.';
                   }
                   inform.Recipient__c = Uexam.User_ID__r.Email__c;
                   inform.Recipient_Name__c = Uexam.User_ID__r.FirstName__c;
                    System.debug('Uexam.User_ID__r.Email__c: ' + Uexam.User_ID__r.Email__c);
                    System.debug('Recipient__c: ' + inform.Recipient__c);
                   inform.Sender_Name__c = 'Team ATHENA';

                   INSERT inform;
                   System.debug('inform: ' + inform);
                   
            }
              
    }


    /*    User_Examination = [Select u.User_ID__c, u.User_ID__r.FirstName__c from User_Examination__c u];
          Send = [Select u.EmailResults__c from UserProfile__c u];
    */
    
    public void send()
    {

         
        String sent = 'Invitation has been sent';
        //displayInvite = false;

        try{
        if(friendName1 != '' && emailAddress1 == '')
        {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR,'Please type the email address of your friend ' + friendName1);
            ApexPages.addMessage(error);
        }else if(friendName1 == '' && emailAddress1 != ''){
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide friend\'s name on 1st invitation.');
            ApexPages.addMessage(error);
        }else if(friendName1 != null && emailAddress1 != '')
        {
            Email__c dataToInsert = new Email__c();
            dataToInsert.Recipient_Name__c = friendName1;
            dataToInsert.Recipient__c = emailAddress1;
            dataToInsert.Link__c = ATHENA;
            if(Uexam.Examination_ID__r.Name__c == null || Uexam.Examination_ID__r.Name__c == ''){
                dataToInsert.Exam_Name__c = 'Challenge';
            }else{
                dataToInsert.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
            }
            dataToInsert.Sender_Name__c = Uexam.User_ID__r.FirstName__c;
            dataToInsert.Template__c = 'INVITE';
            INSERT dataToInsert;
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR,'Invitation for '+ friendName1 + ' was successfully sent');
            ApexPages.addMessage(error);
            friendName1 = '';
            emailAddress1 = '';
        }

        if(friendName2 != '' && emailAddress2 == '')
        {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR,'Please type the email address of your friend '+ friendName2 );
            ApexPages.addMessage(error);
        }else if(friendName2 == '' && emailAddress2 != ''){
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide friend\'s name on 2nd invitation.');
            ApexPages.addMessage(error);            
        }else if(friendName2 != null && emailAddress2 != '')
        {
            Email__c dataToInsert = new Email__c();
            dataToInsert.Recipient_Name__c = friendName2;
            dataToInsert.Recipient__c = emailAddress2;
            dataToInsert.Link__c = ATHENA;
            if(Uexam.Examination_ID__r.Name__c == null || Uexam.Examination_ID__r.Name__c == ''){
                dataToInsert.Exam_Name__c = 'Challenge';
            }else{
                dataToInsert.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
            }
            dataToInsert.Sender_Name__c = Uexam.User_ID__r.FirstName__c;
            dataToInsert.Template__c = 'INVITE';
            INSERT dataToInsert;
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR,'Invitation for '+ friendName2 + ' was successfully sent');
            ApexPages.addMessage(error);
            friendName2 = '';
            emailAddress2 = '';
        }

        if(friendName3 != '' && emailAddress3 == '')
        {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR,'Please type the email address of your friend '+ friendName3);
            ApexPages.addMessage(error);
        }else if(friendName3 == '' && emailAddress3 != ''){
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide friend\'s name on 3rd invitation.');
            ApexPages.addMessage(error);
        }else if(friendName3 != null && emailAddress3 != '')
        {
            Email__c dataToInsert = new Email__c();
            dataToInsert.Recipient_Name__c = friendName3;
            dataToInsert.Recipient__c = emailAddress3;
            dataToInsert.Link__c = ATHENA;
            if(Uexam.Examination_ID__r.Name__c == null || Uexam.Examination_ID__r.Name__c == ''){
                dataToInsert.Exam_Name__c = 'Challenge';
            }else{
                dataToInsert.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
            }
            dataToInsert.Sender_Name__c = Uexam.User_ID__r.FirstName__c;
            dataToInsert.Template__c = 'INVITE';
            INSERT dataToInsert;
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR,'Invitation for '+ friendName3 + ' was successfully sent');
            ApexPages.addMessage(error);
            friendName3 = '';
            emailAddress3 = '';
        }    

        if(friendName4 != '' && emailAddress4 == '')
        {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR,'Please type the email address of your friend '+ friendName4);
            ApexPages.addMessage(error);
        }else if(friendName4 == '' && emailAddress4 != ''){
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide friend\'s name on 4th invitation.');
            ApexPages.addMessage(error);
        }else if(friendName4 != null && emailAddress4 != '')
        {
            Email__c dataToInsert = new Email__c();
            dataToInsert.Recipient_Name__c = friendName4;
            dataToInsert.Recipient__c = emailAddress4;
            dataToInsert.Link__c = ATHENA;
            if(Uexam.Examination_ID__r.Name__c == null || Uexam.Examination_ID__r.Name__c == ''){
                dataToInsert.Exam_Name__c = 'Challenge';
            }else{
                dataToInsert.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
            }
            dataToInsert.Sender_Name__c = Uexam.User_ID__r.FirstName__c;
            dataToInsert.Template__c = 'INVITE';
            INSERT dataToInsert;
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR,'Invitation for '+ friendName4 + ' was successfully sent');
            ApexPages.addMessage(error);
            friendName4 = '';
            emailAddress4 = '';
        }    

        if(friendName5 != '' && emailAddress5 == '')
        {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR,'Please type the email address of your friend ' + friendName5);
            ApexPages.addMessage(error);
        }else if(friendName5 == '' && emailAddress5 != ''){
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide friend\'s name on 5th invitation.');
            ApexPages.addMessage(error);
        }else if(friendName5 != null && emailAddress5 != '')
        {
            Email__c dataToInsert = new Email__c();
            dataToInsert.Recipient_Name__c = friendName5;
            dataToInsert.Recipient__c = emailAddress5;
            dataToInsert.Link__c = ATHENA;
            if(Uexam.Examination_ID__r.Name__c == null || Uexam.Examination_ID__r.Name__c == ''){
                dataToInsert.Exam_Name__c = 'Challenge';
            }else{
                dataToInsert.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
            }
            dataToInsert.Sender_Name__c = Uexam.User_ID__r.FirstName__c;
            dataToInsert.Template__c = 'INVITE';
            INSERT dataToInsert;
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR,'Invitation for '+ friendName5 + ' was successfully sent');
            ApexPages.addMessage(error);
            friendName5 = '';
            emailAddress5 = '';
        }
      }catch(Exception err)
      {
         ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR,'E-mail address is not valid.');
         ApexPages.addMessage(error);
      }
    }
    
    public void invite() {
        displayInvite = true;
    }
    
    public void cancel(){
        friendName1 = ''; friendName2 = ''; friendName3 = ''; friendName4 = ''; friendName5 = '';
        emailAddress1 = ''; emailAddress2 = ''; emailAddress3 = ''; emailAddress4 = ''; emailAddress5 = '';
        displayInvite = false;
    }    
}