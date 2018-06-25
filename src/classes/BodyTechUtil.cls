public class BodyTechUtil{
    
    public static ClientServiceController.ClientService toClientService(Client_Service__c s, decimal com, string therapist){
        ClientServiceController.ClientService o = new ClientServiceController.ClientService();
        if (s.Client__r!=null)
            o.Client = s.Client__r.First_Name__c + ' '+ s.Client__r.Last_Name__c;
            o.Service = s.Service__r.Name__c;
            o.Commission = com;
            o.Therapist = therapist;
            o.Discount = s.Discount__c == null? 0 : s.Discount__c;
            o.Amount = s.Service__r.Price__c;
            o.Date_Time= s.Date_Time__c;
            o.Confirmed_By= s.Confirmed_By__c;
            o.Id = s.Id;
        
        return o;
    
    }
    
     public static integer getMonthDays(integer selectedmonth){
        if (selectedmonth == 9 || selectedmonth==4 || selectedmonth == 6 || selectedmonth == 11)
            return 30;
        else if (selectedmonth==1 || selectedmonth==3 || selectedmonth == 5 || selectedmonth == 7 ||  selectedmonth == 8 || selectedmonth == 10 || selectedmonth == 12)
            return 31;
        return 28;      
    }
    
    public static boolean IsManagerPresent(Date d){
        List<Attendance__c> a = [Select Id from Attendance__c where Date__c = : d and Staff__r.Role__c = 'Store Manager'];
        if (a.size()>0)
            return true;
        return false;    
    }
}