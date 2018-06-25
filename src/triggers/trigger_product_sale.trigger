trigger trigger_product_sale on Product_Sale__c (after insert, before delete) {
    
    Set<String> ids = new Set<String>();
    
    
    if (trigger.isinsert){
        for (Product_Sale__c s : trigger.new){
            if(s.Type__c=='Sale')
            ids.add(s.Id);
        }
        List<Product_Sale__c> sales = [Select Id, Product__r.Commission__c, Staff__c from Product_Sale__c where Id in :ids];
        
        List<Staff_Commission__c> coms = new List<Staff_Commission__c>();
        for (Product_Sale__c s : sales){
            Staff_Commission__c com = new Staff_Commission__c();
            com.Product_Sale__c = s.Id;
            com.Amount__c = s.Product__r.Commission__c == null? 0 : s.Product__r.Commission__c;
            com.Staff__c = s.Staff__c;
            coms.add(com);
            
        }
        if (coms.size()>0)
            insert coms;
    }else if (trigger.isdelete){
        for (Product_Sale__c s : trigger.old){
            ids.add(s.Id);
        }
        List<Staff_Commission__c> coms = [Select Id from Staff_Commission__c where Product_Sale__c in :ids];
        if (coms.size()>0)
            delete coms;
    }    
}