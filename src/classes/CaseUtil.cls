global with sharing class CaseUtil{
    
    static List<Date> holidays = null;
   
    private static List<Date> getHolidays(){
        if (holidays == null){
         holidays = new List<Date>();
         for (Holiday h : [Select Id, ActivityDate from Holiday]){
             holidays.add(h.ActivityDate);
         }
         return holidays;
        }  
        return null;
    }
    
    public static decimal computeAgeInMinutes(datetime f, datetime t){
        
         if (f == null || t== null)
             return 0;
         decimal ageInMinutes=0;
         
         Datetime fromGMT = f;//DateTime.newInstanceGMT(f.year(), f.month(), f.day(), f.hour(), f.minute(), f.second());
         Datetime toGMT = t; //DateTime.newInstanceGMT(t.year(), t.month(), t.day(), t.hour(), t.minute(), t.second());
       
         
         Integer diff_days = fromGMT.date().daysbetween(toGmt.date());
         Set<DateTime> dates = new Set<DateTime>();
         for (integer i=0; i<=diff_days; i++){
             Datetime dt = fromGmt.addDays(i);
             boolean isHoliday = false;
             List<Date> hdays = getHolidays();
             if (hdays!=null && hdays.size()>0)
             for (Date d : hdays){
                 if (d==dt.date()){
                     isHoliday = true;
                     break;
                 }
                 
             }
             if (!isHoliday)
                 dates.add(dt);
             
         }
         for (DateTime d : dates){
             decimal dayMinutes = 0;
             String dayOfWeek = d.format('E');
             DateTime baseD = datetime.newInstanceGMT(d.date().year(), d.date().month(), d.date().day(), 0,0,0);
             DateTime baseD1 = datetime.newInstanceGMT(d.date().year(), d.date().month(), d.date().day(), 24,0,0);
             DateTime mondayD= datetime.newInstanceGMT(d.date().year(), d.date().month(), d.date().day(), 8,0,0);
             DateTime FridayD= datetime.newInstanceGMT(d.date().year(), d.date().month(), d.date().day(), 17,0,0);
             System.debug('FridayD: '+FridayD);
             System.debug('Now: '+System.now());
             System.debug('ToGMT: '+togmt);
             System.debug('FromGMT: '+fromgmt);
             System.debug('FridayD.gettime()- toGMT.getTime()>0'+ (FridayD.gettime()- toGMT.getTime()>0));
             if (dates.size()==1){
                 if (dayOfWeek != 'Fri'){
                          dayMinutes = ((toGMT.getTime()-fromGmt.gettime())/(1000*60));
                     } else{
                         if (FridayD.gettime()- toGMT.getTime()>0) 
                          dayMinutes = ((toGMT.getTime()-fromGmt.gettime())/(1000*60)); 
                         else dayMinutes = ((FridayD.getTime()-fromGmt.gettime())/(1000*60));     
                     }
             }
             else{
                 if (d.date()==fromGmt.date()){
                     if (dayOfWeek != 'Fri'){
                          dayMinutes = ((baseD1.gettime()-fromGmt.gettime())/(1000*60));
                     } else{
                          dayMinutes = ((FridayD.gettime()-fromGmt.gettime())/(1000*60));    
                     }
                 }else if (d.date()==toGmt.date()){
                     if (dayOfWeek=='Mon')
                         dayMinutes = ((toGmt.gettime()-mondayD.gettime())/(1000*60));
                     else{
                         if (dayOfWeek != 'Sat' && dayOfWeek != 'Sun')
                             dayMinutes = ((toGmt.gettime()-baseD.gettime())/(1000*60));
                      }   
                 }else{
                     if (dayOfWeek != 'Sat' && dayOfWeek != 'Sun'){
                         if (dayOfWeek == 'Fri'){
                             dayMinutes =17*60;
                         }
                         else if (dayOfWeek == 'Mon'){
                             dayMinutes =16*60;
                         }
                         else{
                             dayMinutes =24*60;
                         }
                     }
                 }
             }
             dayMinutes =dayMinutes<0 ? 0: dayminutes;
             ageInMinutes += dayMinutes;
             xx+='; '+dayofWeek+': '+dayMinutes;
         }
         return ageInMinutes;
    }
    
    
    public static string xx;
    public static Map<Date, integer> dayHoursMap;
    public static long compute(datetime f, datetime t){
        dayHoursMap = new Map<Date, integer>();
         xx='';
         long x=0;
         Integer diff_days = f.date().daysbetween(t.date());
         Set<DateTime> dates = new Set<DateTime>();
         for (integer i=0; i<=diff_days; i++){
             Datetime dt = f.addDays(i);
             dates.add(dt);
             dayHoursMap.put(dt.date(), null);
         }
         for (DateTime d : dates){
             long dayHours = 0;
             String dayOfWeek = ((Datetime)d).format('E');
             DateTime baseD = datetime.newInstance(d.date().year(), d.date().month(), d.date().day(), 0,0,0);
             DateTime baseD1 = datetime.newInstance(d.date().year(), d.date().month(), d.date().day(), 24,0,0);
             DateTime mondayD= datetime.newInstance(d.date().year(), d.date().month(), d.date().day(), 8,0,0);
             DateTime FridayD= datetime.newInstance(d.date().year(), d.date().month(), d.date().day(), 17,0,0);
             if (d.date()==f.date()){
                 if (dayOfWeek != 'Fri'){
                      dayHours = ((baseD1.gettime()-f.gettime())/(1000*60));
                 } else{
                      dayHours  = ((FridayD.gettime()-f.gettime())/(1000*60));    
                 }
             }else if (d.date()==t.date()){
                 dayHours = ((t.gettime()-baseD.gettime())/(1000*60));
             }else{
                 if (dayOfWeek != 'Sat' && dayOfWeek != 'Sun'){
                     if (dayOfWeek == 'Fri'){
                         dayHours =17*60;
                     }
                     else if (dayOfWeek == 'Mon'){
                         dayHours =16*60;
                     }
                     else{
                         dayHours =24*60;
                     }
                 }
             }
             x+=dayHours;
             xx+='; '+dayofWeek+': '+dayHours;
         }
         return x;
    }
    
    public static long updateCase(List<Case> cases){
        
        Datetime now = System.now();
        Date today = now.Date();
        decimal diff_min = 0;
        Integer diff_days = 0;
        Set<Date> dates = new Set<Date>();
        long totalMins = 0;
        Integer endMin = now.hour()*60 + now.minute();
        integer multiplier = 0;
        for (Case c : cases){
            Datetime createdGMT = datetime.newInstance(c.date_created__c.year(), c.date_created__c.month(),c.date_created__c.day(),
            c.date_created__c.hour(),c.date_created__c.minute(),c.date_created__c.second());
            
            Integer startMin = createdGMT.hour()*60+createdGMT.minute();
            
            diff_days = createdGMT.date().daysbetween(today);
            for (integer i=1; i< diff_days; i++){
                dates.add(createdGMT.addDays(i).date());
            }
            
            for (Date d : dates){
                String dayOfWeek = ((Datetime)d).format('E');
                if (dayOfWeek != 'Sat' && dayOfWeek != 'Sun')
                    multiplier++;
            }
            if (startMin<=endMin)
                multiplier++;
            long x = createdGMT.getTime()-now.getTime();
            if (x<0)
                x = now.getTime()-createdGMT.getTime();
            totalMins = (x)/(1000*60); //multiplier*24*60 + (endMin-startMin); 
            
            totalMins = totalMins - (multiplier*24*60);
            
            //diff_min = (now.gettime() - c.createdDate.gettime())/(1000.0*60.0);
        }
        return totalMins ;
    }
}