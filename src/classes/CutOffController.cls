public class CutOffController{

    public class CutOffSummary { 
        public List<StaffCutOffSummary> staffSummaryList { get; set; }
        public CutOff__c cutOff { get; set; }
        public string Confirmed_By { get; set; }
    }
    
    public String SelectCutOffId { get; set; }
    public void setSelectedCutOff(){
    }
    
    public class StaffCutOffSummary{
        public Staff__c Staff { get; set; }
        public CutOff__c CutOff { get; set; }
        public decimal grossSalary { get; set; }
        public decimal pastBalance { get; set; }
        public List<Cash_Advance__c> advances { get; set; }
        public List<Attendance__c> attendance { get; set; }
        
    }

    public CutOffSummary summary{ get; set; }
    public List<Staff__c> staffs { get; set; }
    public CutOffController(){
        //
        //getAllCutOffSummaries();
    }
    
    public void getStaffs(){
        staffs=  [Select Id, Alias__c, Name__c from Staff__c where Active__c=true];
    }
    
    public List<CutOffSummary> AllCutOffSummaries { get; set; }
    
    public Pagereference getAllCutOffSummaries(){
        getStaffs();
        AllCutOffSummaries = new List<CutOffSummary>();
        
        List<CutOff__c> cutOffs = [Select Id, Start__c, End__c, Confirmed_By__c from CutOff__c order by End__c desc];
        
        
        List<StaffCutOffSummary> staffSummaryList = new List<StaffCutOffSummary>();
        
        
        Map<Id, List<Attendance__c>> cutOffAttendance = new Map<Id, List<Attendance__c>>();
        
        for(Attendance__c a : [Select Id, Staff__c, Staff__r.Alias__c, Type__c, Date__c, CutOff__c, CutOff__r.Confirmed_By__c  from Attendance__c]){
            if(cutOffAttendance.ContainsKey(a.CutOff__c)){
                List<Attendance__c> att = cutoffAttendance.get(a.cutOff__c);
                att.add(a);
                cutOffAttendance.put(a.cutOff__c, att);
            }else{
                cutOffAttendance.put(a.cutOff__c, new List<Attendance__c>{ a} );
            }
        }
        
        
        List<Date> plus50= new List<Date>();
        List<Date> doublePay = new List<Date>();
        doublePay.add(dateTime.newInstance(2015,12,25,0,0,0).date());
        doublePay.add(dateTime.newInstance(2015,12,31,0,0,0).date());
        doublePay.add(dateTime.newInstance(2016,1,1,0,0,0).date());
        
        for(Integer i=20; i<=31;i++){
            plus50.add(dateTime.newInstance(2015,12,i,0,0,0).date());
        }
        plus50.add(dateTime.newInstance(2016,1,1,0,0,0).date());
        
        
        
        for(CutOff__c c : cutOffs){
            CutOffSummary mSummary= new CutOffSummary();  
            mSummary.cutOff=c; 
            mSummary.Confirmed_By = c.Confirmed_By__c;         
            for(Staff__c a : staffs){
                decimal baseSalary=100;
                decimal grossSalary = 0;
                List<Attendance__c> att = new List<Attendance__c>();
                StaffCutOffSummary s = new StaffCutOffSummary();
                s.cutoff= c;
                s.staff= a;
                
                List<Attendance__c> attList = cutOffAttendance.get(c.Id);
                if(attList!=null){
                    for(Attendance__c at : attList){
                    boolean mdoublePay=false;
                    boolean mplus50=false;
                    if(at.Staff__c == a.Id){
                        att.add(at);
                        for(Date dt : doublePay){
                            if(dt==at.Date__c){
                                mdoublePay=true;
                                break;
                            }                                
                        }
                        for(Date dt : plus50){
                            if(dt==at.Date__c){
                                mplus50=true;
                                break;
                            }                                
                        }
                        
                        if(mdoublePay){
                            if(mplus50){
                                baseSalary = 300;
                            }else{
                                baseSalary = 200;
                            }
                        }else{
                            if(mplus50)
                                baseSalary=150;
                            else
                                baseSalary=100;
                        }
                        
                        if(a.Id=='a0c90000008tJ0c'){
                            date d1 = dateTime.newInstance(2016,1,5).date();
                            date d2 = dateTime.newInstance(2016,1,10).date();
                            date d3 = dateTime.newInstance(2016,1,11).date();
                            if(at.date__c<=d2 && at.date__c>=d1)
                                baseSalary = 200;
                            else if (at.date__c>=d3)
                                baseSalary=250;
                            
                        }
                        
                        if(at.Type__c=='In')
                            grossSalary+=baseSalary;
                        if(at.Type__c=='Half-Day')
                            grossSalary+=(baseSalary/2);
                        //break;                      
                    }
                }                
                }
                s.grossSalary= grossSalary;
                s.attendance = att;                
                staffSummaryList.add(s);
            }
            
            
            mSummary.staffSummaryList=staffSummaryList;
            
            AllCutOffSummaries.add(mSummary);
        }
        
        System.debug('cutOffSummaries :'+AllCutOffSummaries);
        return null;
        //return cutOffSummaries;
    }
    
    
}