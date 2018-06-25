trigger trigger_attendance on Attendance__c (before insert, after insert, after update) {
    
    if(trigger.isBefore){
        List<cutoff__c> cutOffs = [Select Id, start__c, end__c from cutoff__c];
        List<Attendance__c> att = trigger.new;
        Map<String, Attendance__c> attendanceMap = new Map<String, Attendance__c>();       
        for(Attendance__c a : att){
            attendanceMap.put(a.UniqueId__c, a);
            for(CutOff__c c : cutoffs){
                if(a.date__c >= c.start__c && a.date__c<=c.end__c){
                    a.cutoff__c = c.Id;
                    break;
                }
            }
        }
        
        List<Attendance__c> attendance = [Select Id, UniqueId__c from Attendance__c];                
        for(Attendance__c a : attendance ){
            Attendance__c d = attendanceMap.get(a.UniqueId__c);
            if(d!=null){
                d.addError('Already exist');
            }
        }
    }
    

}