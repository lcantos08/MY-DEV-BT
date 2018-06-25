trigger trigger_client_service on Client_Service__c (before delete) {
    Set<String> ids = new Set<String>();
    if (trigger.isdelete){
        for(Client_Service__c s : trigger.old){
            ids.add(s.Id);
        }
        
        List<Staff_Commission__c> coms = [Select Id from Staff_Commission__c where Client_Service__c in :ids];
        if (coms.size()>0)
            delete coms;
    }
}