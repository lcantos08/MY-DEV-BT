public class AttendanceController{
    
    public date SelectedDate { get; set; }
    public void setSelectedDate(){
        Integer m= Integer.valueOf( Apexpages.currentPage().getParameters().get('m'));
        Integer d= Integer.valueOf( Apexpages.currentPage().getParameters().get('d'));
        Integer y= Integer.valueOf( Apexpages.currentPage().getParameters().get('y'));
        Selecteddate = DateTime.NewInstance(y,m,d,0,0,0).Date();
    }
    
    public class DTO_Attendance{
        public Integer day { get{
            return attendance.Date__c.day();
        }}
        public Attendance__c attendance { get; set; }
    }
    
    public Integer monthDays {
        get{
            if (selectedYear==2016 && selectedMonth==2)
               return 29;
           return BodyTechUtil.getMonthDays(selectedMonth);
        }
    }
    
    public List<Staff__c> getStaffs(){
        return [Select Id, Full_Name__c, Name__c, Alias__c, Active__c from Staff__c where Active__c=true];
    }
    
    public Integer selectedYear { get; set; }
    public Integer selectedMonth { get; set; }
    public List<DTO_Attendance> attendanceList { get; set; }
    public Attendance__c att { get; set; }
    public AttendanceController(){
        Date today = System.Today();
        selectedMonth = today.month();
        selectedYear = today.year();
        getAttendance(selectedYear, selectedMonth);
    }
    public void getAttendance(Integer y, Integer m){
        List<Attendance__c> l= [Select Id, Name, Date__c, Note__c, Staff__r.Id, Staff__r.Alias__c, Staff__r.Name__c, 
                    Type__c, Confirmed_By__c from Attendance__c where Calendar_Month(Date__c)=:m and Calendar_Year(Date__c)=:y];
        List<DTO_Attendance> dto = new List<DTO_Attendance>();
        for(Attendance__c a : l){
            DTO_Attendance x = new DTO_Attendance();
            x.attendance = a;
            dto.add(x);
        }
        selectedMonth = m;
        selectedYear = y;
        attendanceList  = dto;
        
    }
    public void saveAttendance(){
        upsert att;
    }
    
    public void upsertAttendance(){
        Integer day = Integer.valueOf( Apexpages.currentPage().getParameters().get('day'));
        
        string status=  Apexpages.currentPage().getParameters().get('status');
        string staffId=  Apexpages.currentPage().getParameters().get('staffId');
    
        Date d = dateTime.newInstance(selectedyear, selectedmonth, day,0,0,0).date();
        List<Attendance__c> att = [Select Id, Type__c, Date__c, Staff__c, Confirmed_By__c  from Attendance__c where Staff__c=:staffId and Date__c=:d];
        Attendance__c a = null;
        if(att.size()>0){
            a= att[0];   
            
        }else
            a= new Attendance__c();
        a.Type__c = status;
        a.Staff__c = staffId;
        a.Date__c = d;
        String cutOffId = '';
        for(cutOff__c c : [Select Id, Start__c, End__c from CutOff__c]){
            if(c.Start__c<=d && d<=c.End__c){
                cutOffId=c.Id;
                break;
            }
        }
        
        if(cutOffId!='' && a.Id==null){
            a.cutOff__c = cutOffId;   
        }
        upsert a;
    }
    
     public void getMonthlyAttendance(){
        Integer y = Integer.valueOf( Apexpages.currentPage().getParameters().get('y'));
        Integer m= Integer.valueOf( Apexpages.currentPage().getParameters().get('m'));
        Date today = System.Today();
        getAttendance(y,m);
        
     }

}