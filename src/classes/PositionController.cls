public with sharing class PositionController
{

    public PositionController() {
         positions=[Select Id, Name, Status__c from Position__c];
    }

   
    public List<Position__c> positions{get;set;}
    public List<Job_Application__c> positionJobApplications{get;set;}
    public Position__c selectedPosition{get;set;}
    public Id selectedPositionId{get;set;}
   
    public PageReference getDetails()
    {
      PageReference page = ApexPages.CurrentPage();
      String id = page.getparameters().get('cid');
    //  selectedPosition= [Select Id, Name from Position__c where Id=:id];
      
      selectedPositionId= id;
      getJobApplicationByPositionId();
      return page;
    }
    
    public List<Job_Application__c> getJobApplicationByPositionId()
    {
    positionJobApplications=null;
    positionJobApplications=[Select Id, Name, Position__r.Name from Job_Application__c where position__r.Id=: selectedPositionId ];
    return positionJobApplications;
    }
    
   




}