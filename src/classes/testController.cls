public with sharing class testController {
    public Datetime l { get{return system.now();}}
    public Datetime cDate { get; set; }
    public Datetime f{ get; set; }
    public Datetime t{ get; set; }
    public string xx {
        get{
        return caseutil.xx;
        }
    }
    
    public decimal min_total { get; private set; }
    public string xxx { get{
        if (min_total != null){
        integer hr = integer.valueof(min_total/60);
        integer min = integer.valueof(min_total - (hr*60));
        return ''+hr+' hours: '+min+' minutes: totalmins='+min_total;}
        return '';
    
    }}
    public void lui(){
        List<Case> cases = new List<Case>();
        cases.add(new Case(date_created__c=datetime.valueof(cDate)));
        
        min_total=CaseUtil.computeAgeInMinutes(f,t);
      //  min_total = CaseUtil.updateCase(cases);
    }

    public List<Job_Application__c> getApplications(){
    return [Select Id, Name from Job_Application__c];
    }
}