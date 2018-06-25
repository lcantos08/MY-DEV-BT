public with sharing class POCController
{
    public List<string> searchKeywords{get;set;}
    private List<Examination__c> exams;
    private string str;
   
    private void Search()
    {    
       str = searchKeywords[0];
       exams = [Select Id, name, Description2__c from Examination__c where Description2__c  like '%+str+%'];
    }
    
    
}