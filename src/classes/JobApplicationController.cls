public with sharing class JobApplicationController
{

    public List<Job_Application__c> jobApplications{get;set;}

    public JobApplicationController(ApexPages.StandardController controller) {
     
     jobApplications = [Select Id, Name from Job_Application__c];
    }


}