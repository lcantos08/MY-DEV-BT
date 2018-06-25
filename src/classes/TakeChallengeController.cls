public class TakeChallengeController 
{
    private String userExamID;
    private String token;
    public Boolean isTokenValid{get; set;}
    
    private User_Examination__c userExam;

    public TakeChallengeController()
    {
        userExamID = ApexPages.currentPage().getParameters().get('userExamID');
        token = ApexPages.currentPage().getParameters().get('token');
        isTokenValid = true;
        
        try
        {
            userExam =  [SELECT CreatedDate, Status__c FROM User_Examination__c WHERE ID = :userExamID AND Token__c = :token];            
        }
        catch( System.QueryException e )
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Challenge link has already expired. Please generate a new one.');
            ApexPages.addMessage(myMsg); 
            isTokenValid = false;    
            return;
        }
    }
    
    public PageReference startChallenge() 
    {   
        userExam = [SELECT ID, Token__c FROM User_Examination__c WHERE ID = :userExamID];
        return new PageReference('/apex/examPage?userExamID='+ userExam.ID + '&token='+userExam.Token__c);            
    }
    
}