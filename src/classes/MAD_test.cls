public class MAD_test {
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
           ave = ((Uexam.Score__c /Uexam.Perfect_Score__c)*100);
           
           if (Uexam.User_ID__r.Email_Result_after_Exam__c = true)
           {
                   System.debug('Email results? ' + Uexam.User_ID__r.Email_Result_after_Exam__c);
                   Email__c inform = new Email__c();
                   inform.Link__c = ATHENA;
                   inform.Result__c = score;
                   if(Uexam.Examination_ID__r.Name__c == null || Uexam.Examination_ID__r.Name__c == '')
                   {
                       inform.Exam_Name__c = 'Challenge';
                   }
                   else
                   {
                       inform.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
                   }
                   inform.Recipient__c = Uexam.User_ID__r.Email__c;
                   inform.Recipient_Name__c = Uexam.User_ID__r.FirstName__c;
                    System.debug('Uexam.User_ID__r.Email__c: ' + Uexam.User_ID__r.Email__c);
                    System.debug('Recipient__c: ' + inform.Recipient__c);
                   inform.Sender_Name__c = 'Team ATHENA';
                       if (ave > Uexam.Examination_ID__r.Passing_Rate__c)
                       {
                           inform.Template__c = 'SEND_PASSED';
                       }else{
                           inform.Template__c = 'SEND_FAILED';
                       }
                   INSERT inform;
                   System.debug('inform: ' + inform);
            }   
    }


    /*    User_Examination = [Select u.User_ID__c, u.User_ID__r.FirstName__c from User_Examination__c u];
          Send = [Select u.EmailResults__c from UserProfile__c u];
    */
    public void send() 
    {
        send1();
        send2();
        send3();
        displayInvite = false;
    }
    
    public void send1()
    {
        try{
        if((friendName1 != null && Email.Recipient__c != null))
        {
            Email__c dataToInsert = new Email__c();
            dataToInsert.Recipient_Name__c = friendName1;
            //dataToInsert.Recipient__c = emailAddress1;
            dataToInsert.Link__c = ATHENA;
            dataToInsert.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
            dataToInsert.Sender_Name__c = Uexam.User_ID__r.FirstName__c;
            dataToInsert.Template__c = 'INVITE';
            INSERT dataToInsert;
            friendName1 = '';
            emailAddress1 = '';
        } 
        }catch(Exception ex)
        {
            ApexPages.addMessages(ex);
        }
    } 
    
    public void send2()
    {
        if((friendName2 != null && Email.Recipient__c != null))
        {
            Email__c dataToInsert = new Email__c();
            dataToInsert.Recipient_Name__c = friendName2;
            //dataToInsert.Recipient__c = emailAddress2;
            dataToInsert.Link__c = ATHENA;
            dataToInsert.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
            dataToInsert.Sender_Name__c = Uexam.User_ID__r.FirstName__c;
            dataToInsert.Template__c = 'INVITE';
            INSERT dataToInsert;
            friendName2 = '';
            emailAddress2 = ''; 
        }
    } 
    
    public void send3()
    {
        if((friendName3 != null && Email.Recipient__c != null))
        {
            Email__c dataToInsert = new Email__c();
            dataToInsert.Recipient_Name__c = friendName3;
            //dataToInsert.Recipient__c = emailAddress3;
            dataToInsert.Link__c = ATHENA;
            dataToInsert.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
            dataToInsert.Sender_Name__c = Uexam.User_ID__r.FirstName__c;
            dataToInsert.Template__c = 'INVITE';
            INSERT dataToInsert;
            friendName3 = '';
            emailAddress3 = ''; 
        }else{
        
        }
    } 
/*    
    public void send4()
    {
        if((friendName1 != null && emailAddress1 != null) || (friendName1 != '' && emailAddress1 !='' ))
        {
            Email__c dataToInsert = new Email__c();
            dataToInsert.Recipient_Name__c = friendName4;
            //dataToInsert.Recipient__c = emailAddress4;
            dataToInsert.Link__c = ATHENA;
            dataToInsert.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
            dataToInsert.Sender_Name__c = Uexam.User_ID__r.FirstName__c;
            dataToInsert.Template__c = 'INVITE';
            INSERT dataToInsert;
            friendName4 = '';
            emailAddress4 = ''; 
        }
    } 
    
    public void send5()
    {
        if((friendName1 != null && emailAddress1 != null) || (friendName1 != '' && emailAddress1 !='' ))
        {
            Email__c dataToInsert = new Email__c();
            dataToInsert.Recipient_Name__c = friendName5;
            //dataToInsert.Recipient__c = emailAddress5;
            dataToInsert.Link__c = ATHENA;
            dataToInsert.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
            dataToInsert.Sender_Name__c = Uexam.User_ID__r.FirstName__c;
            dataToInsert.Template__c = 'INVITE';
            INSERT dataToInsert;
            friendName5 = '';
            emailAddress5 = ''; 
        }
    } 
*/
/*        
        if((friendName1 != null && emailAddress1 != null) || (friendName1 != '' && emailAddress1 !='' ))
        {
            Email__c dataToInsert = new Email__c();
            dataToInsert.Recipient_Name__c = friendName1;
            dataToInsert.Recipient__c = emailAddress1;
            dataToInsert.Link__c = ATHENA;
            dataToInsert.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
            dataToInsert.Sender_Name__c = Uexam.User_ID__r.FirstName__c;
            dataToInsert.Template__c = 'INVITE';
            INSERT dataToInsert;
            friendName1 = '';
            emailAddress1 = '';   
        }

        if(friendName2 != null && emailAddress2 != null)
        {
            Email__c dataToInsert2 = new Email__c();
            dataToInsert2.Recipient_Name__c = friendName2;
            //dataToInsert2.Recipient__c = emailAddress2;
            dataToInsert2.Link__c = ATHENA;
            dataToInsert2.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
            dataToInsert2.Sender_Name__c = Uexam.User_ID__r.FirstName__c;
            dataToInsert2.Template__c = 'INVITE';
            //INSERT dataToInsert2;
            friendName2 = '';
            emailAddress2 = '';
        }

        if(friendName3 != null && emailAddress3 != null)
        {
            Email__c dataToInsert3 = new Email__c();
            dataToInsert3.Recipient_Name__c = friendName3;
            //dataToInsert3.Recipient__c = emailAddress3;
            dataToInsert3.Link__c = ATHENA;
            dataToInsert3.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
            dataToInsert3.Sender_Name__c = Uexam.User_ID__r.FirstName__c;
            dataToInsert3.Template__c = 'INVITE';
            //INSERT dataToInsert3;
            friendName3 = '';
            emailAddress3 = '';
        }    

        if(friendName4 != null && emailAddress4 != null)
        {
            Email__c dataToInsert4 = new Email__c();
            dataToInsert4.Recipient_Name__c = friendName4;
            dataToInsert4.Recipient__c = emailAddress4;
            dataToInsert4.Link__c = ATHENA;
            dataToInsert4.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
            dataToInsert4.Sender_Name__c = Uexam.User_ID__r.FirstName__c;
            dataToInsert4.Template__c = 'INVITE';
           // INSERT dataToInsert4;
            friendName4 = '';
            emailAddress4 = '';
        }    

        if((friendName5 != null & emailAddress5 != null) | (friendName5 != '' & emailAddress5 != ''))
        {
        try{
            Email__c dataToInsert5 = new Email__c();
            dataToInsert5.Recipient_Name__c = friendName5;
            dataToInsert5.Recipient__c = emailAddress5;
            dataToInsert5.Link__c = ATHENA;
            dataToInsert5.Exam_Name__c = Uexam.Examination_ID__r.Name__c;
            dataToInsert5.Sender_Name__c = Uexam.User_ID__r.FirstName__c;
            dataToInsert5.Template__c = 'INVITE';
            INSERT dataToInsert5;
            friendName5 = '';
            emailAddress5 = '';
            }Catch(DMLException ex){        
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'yoh');
            ApexPages.addMessage(myMsg);}

        }                  
    }*/
    
    public void invite() {
        displayInvite = true;
    }
    
    public void cancel(){
        friendName1 = ''; friendName2 = ''; friendName3 = ''; friendName4 = ''; friendName5 = '';
        emailAddress1 = ''; emailAddress2 = ''; emailAddress3 = ''; emailAddress4 = ''; emailAddress5 = '';
        displayInvite = false;
    }    
}