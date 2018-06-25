public class ReportController{

    public class MonthlyStaffCommission{
        public string staff { get; set; }
        public Integer month { get; set; }
        public string monthN { get; set; }
        public decimal amount{ get; set; }
    }
    
    public class MonthlyExpenseType{
        public string name { get; set; }
        public integer year { get; set; }
        public Integer month { get; set; }
        public string monthN { get; set; }
        public decimal amount{ get; set; }
    }
    
    public class MonthlySaleProfit{
        public integer year { get; set; }
        public Integer month { get; set; }
        public string monthN { get; set; }
        public decimal grossSales { get; set; }
        public decimal expenses { get; set; }
        public decimal profit{ get{
            return grossSales - expenses;
            }
        }
    }
    
    public class MonthlyServiceCategory{
        public integer year { get; set; }
        public Integer month { get; set; }
        public string monthN { get; set; }
        public string category { get; set; }
        public integer count { get; set; }
    }
    
    public class MonthlyServiceDay{
        public integer year { get; set; }
        public Integer month { get; set; }
        public string monthN { get; set; }
        public string day{ get; set; }
        public integer count { get; set; }
    }
    
    private Map<Integer,String> monthMap = new Map<Integer,String>();
    private Set<String> dayOfWeek = new Set<String>();
    
    
    public ReportController(){
        monthMap.put(1,'Jan');
        monthMap.put(2,'Feb');
        monthMap.put(3,'Mar');
        monthMap.put(4,'Apr');
        monthMap.put(5,'May');
        monthMap.put(6,'Jun');
        monthMap.put(7,'Jul');
        monthMap.put(8,'Aug');
        monthMap.put(9,'Sep');
        monthMap.put(10,'Oct');
        monthMap.put(11,'Nov');
        monthMap.put(12,'Dec');        
        dayOfWeek.add('Mon');
        dayOfWeek.add('Tue');
        dayOfWeek.add('Wed');
        dayOfWeek.add('Thu');
        dayOfWeek.add('Fri');
        dayOfWeek.add('Sat');
        dayOfWeek.add('Sun');
        
        selectedYear  = System.Now().Year()-1;
        getReports();
    }
    
    public void getReports(){
        getMonthlySalesProfit();
        getMonthlyServiceCategories();
        getMonthlyServiceDays();
        getMonthlyExpenseByCategory();
        getMonthlyExpenseByType();
        getMonthlyStaffCommission();
    }
    
    public void getProfitReport(){
        getMonthlySalesProfit();
    }
    
    public void getServiceReport(){
        getMonthlyServiceCategories();
        getMonthlyServiceDays();
    }
    
    public void getExpenseReport(){
        getMonthlyExpenseByCategory();
        getMonthlyExpenseByType();
    }
    
    public void getCommissionReport(){
        getMonthlyStaffCommission();
    }
    
    
    public string monthSalesProfitData { get; set; } //[ ['Year', 'Sales', 'Expenses', 'Profit'],  ['2014', 1000, 400, 200],  ['2015', 1170, 460, 250], ['2016', 660, 1120, 300],  ['2017', 1030, 540, 350]]
    public string monthServiceCategoryData { get; set; }
    public string monthServiceDayData { get; set; }
    public string dayServiceData { get; set; }
    public string monthExpenseCategoryData{ get; set; }
    public string monthExpenseTypeData{ get; set; }
    public string monthStaffCommissionData{ get; set; }
    public List<Staff__c> staffs { get; set; }
    public List<MonthlyStaffCommission> StaffCommissions { get; set; }
   // integer year = 2017;
    
    public integer selectedYear { get; set {selectedYear=value; getReports();} }
    public List<SelectOption> getYearOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('2017', '--Select--'));
        options.add(new SelectOption('2017', '2017'));
        options.add(new SelectOption('2016', '2016'));
        options.add(new SelectOption('2015', '2015'));
        return options;
    }
    
    public void getMonthlyStaffCommission(){
        StaffCommissions = new List<MonthlyStaffCommission>();
        monthStaffCommissionData = '[[\'Month\',';
        List<Staff_Commission__c> commissions = [Select Id, Amount__c, Date__c, Staff__r.Alias__c from Staff_Commission__c where Client_Service__c != null and Calendar_Year(Date__c)=:selectedYear];
        staffs = [Select Id, Alias__c from staff__c where Active__c=true];
        Set<String> names = new Set<String>();
        for(Staff__c s : staffs){
            names.add(s.Alias__c);
            monthStaffCommissionData +='\''+s.Alias__c+'\',';    
        }
        monthStaffCommissionData +='\'Average\'],';
        
        Map<Integer, Map<String, decimal>> montlyStaffCommMap = new Map<Integer, Map<String, decimal>>();
        
        for(Staff_Commission__c c : commissions){
            Integer month = c.date__c.month();
            
            if(montlyStaffCommMap.ContainsKey(month)){
                 Map<String, decimal> staffComms = montlyStaffCommMap.get(month); 
                 if(staffComms .ContainsKey(c.Staff__r.Alias__c)){
                     decimal com = staffComms.get(c.Staff__r.Alias__c);
                     com+= c.Amount__c==null ? 0 : c.Amount__c;
                     staffComms.put(c.Staff__r.Alias__c, com);
                 }else{
                     staffComms.put(c.Staff__r.Alias__c, c.Amount__c==null ? 0 : c.Amount__c);
                 }
                 montlyStaffCommMap.put(month, staffComms);
            
            }else{
               Map<String, decimal> m = new Map<String, decimal>();
               if(m.ContainsKey(c.Staff__r.Alias__c)){
                   decimal com = m.get(c.Staff__r.Alias__c);
                   com+= c.Amount__c==null ? 0 : c.Amount__c;
                   m.put(c.Staff__r.Alias__c, com);
               }else{
                   m.put(c.Staff__r.Alias__c, c.Amount__c==null ? 0 : c.Amount__c);
               }             
               
               montlyStaffCommMap.put(month, m);
            }
            
        }
        
        for(Integer m : montlyStaffCommMap.KeySet()){
            monthStaffCommissionData +='[\''+monthMap.get(m)+'\',';
            Map<String, decimal> staffComms = montlyStaffCommMap.get(m);
            decimal sum=0;
            Integer count = 0;
            for(String n : names){
                decimal com = 0;
                MonthlyStaffCommission msc = new MonthlyStaffCommission();
                msc.month = m;
                msc.monthN = monthMap.get(m);
                msc.staff = n;
                msc.Amount=0;
                for(String n1 : staffComms.KeySet()){
                    if(n==n1){
                        count++;
                        com = staffComms.get(n);                        
                        sum+=com;   
                        msc.Amount = com;
                        
                        break;
                    }
                }
                StaffCommissions.add(msc);
                monthStaffCommissionData += ''+ com +',';
            }
            decimal ave = sum / count;
            monthStaffCommissionData += '' + ave + '],';
            
            
            
        }
        monthStaffCommissionData +=']';
    }
    
    public string lui { get; set; }
    public void getMonthlyServiceDays(){
        lui='';
        Map<String, List<Client_Service__c>> dayServicesMap = new Map<String, List<Client_Service__c>>();
        
        Map<Integer, Map<String,List<Client_Service__c >>> allDataMap = new Map<Integer, Map<String,List<Client_Service__c >>>();
        dayServiceData = '[[\'Day\',\'Service Count\'],';
        List<String> daysOrdered = new List<String> {'Mon','Tue','Wed','Thu','Fri','Sat', 'Sun'};        
        dayServicesMap.put('Mon',new List<Client_Service__c>());
        dayServicesMap.put('Tue',new List<Client_Service__c>());
        dayServicesMap.put('Wed',new List<Client_Service__c>());
        dayServicesMap.put('Thu',new List<Client_Service__c>());
        dayServicesMap.put('Fri',new List<Client_Service__c>());
        dayServicesMap.put('Sat',new List<Client_Service__c>());
        dayServicesMap.put('Sun',new List<Client_Service__c>());
        
        Map<String, object> xxx = new Map<string,object>();
        
        for(Client_Service__c cs : [Select Id, Date_Time__c, Service__r.Name, Service__r.Service_Type__r.Id, 
                        Service__r.Service_Type__r.Name__c from Client_Service__c where Calendar_Year(Date_Time__c)=:selectedYear]){
            
            Integer month = cs.Date_Time__c.month();
            DateTime dt = DateTime.newInstance(cs.Date_Time__c.Year(),cs.Date_Time__c.month(),cs.Date_Time__c.day(),0,0,0);
            string dayOfWeek = dt.format('EEE');
            
            if(dayServicesMap.ContainsKey(dayOfWeek)){
                List<Client_Service__c> o = dayServicesMap.get(dayOfWeek);
                o.add(cs);
                dayServicesMap.put(dayOfWeek,o);
            }else{
                dayServicesMap.put(dayOfWeek, new List<Client_Service__c> { cs });
            }                   
            
                                   
            if(allDataMap.ContainsKey(month)){
                Map<String,List<Client_Service__c >> dayServices = allDataMap.get(month);
                if(dayServices.ContainsKey(dayOfWeek)){
                    List<Client_Service__c > services = dayServices.get(dayOfWeek);
                    services.add(cs);
                    dayServices.put(dayOfWeek, services);
                }else{
                    dayServices.put(dayOfWeek, new List<Client_Service__c > { cs});
                }
                allDataMap.put(month, dayServices);
                
            }else{
                Map<String,List<Client_Service__c >> m = new Map<String,List<Client_Service__c >>();
                m.put(dayOfWeek, new List<Client_Service__c > { cs });
                allDataMap.put(month, m);
            }
            
        }
        Integer dc= 0;
        for(String day : dayServicesMap.KeySet()){
            dc++;
            Integer c = dayServicesMap.get(day).size();
            if (dc<7)
                dayServiceData += '[\''+day+'\','+c+'],';
            else
                dayServiceData += '[\''+day+'\','+c+']';
        }
        dayServiceData+=']';
        
        Integer monthCount = allDataMap.KeySet().size();
        Integer counter=0; 
        
        monthServiceDayData = '[[\'Month\',\'Mon\',\'Tue\',\'Wed\',\'Thu\',\'Fri\',\'Sat\',\'Sun\'],';
        
        
        List<object> cls = new List<Object>();
       
        
        for(Integer m : allDataMap.KeySet()){
            Map<string, object> kv = new Map<string, object>();
            counter++;
            monthServiceDayData +='[\''+monthMap.get(m)+'\',';
            
            Map<String,List<Client_Service__c >> dayServices = allDataMap.get(m);
            Integer dayCounter =0;
            List<Integer> z= new List<Integer>();
            for(String d : dayOfWeek){
                dayCounter ++;
                List<Client_Service__c> services = null;
                for(String dow : dayServices.KeySet()){
                    if(d==dow){
                        services = dayServices.get(dow);
                        
                        break;
                    }
                }
                Integer count = services==null ? 0 : services.size();
                z.add(count);
                monthServiceDayData += dayCounter ==7 ? ''+count : count+',';
                
                
            }
            kv.put('month',m);
            kv.put('count_array', z);
            cls.add(kv);
            monthServiceDayData += monthCount!= counter ? '],' : ']';
            
        }
        monthServiceDayData +=']';
        xxx.put('data', cls);
          lui= JSON.serialize(xxx);
   
  
    }
    
   
    
    public void getMonthlyServiceCategories(){
        
        monthServiceCategoryData = '[[\'Month\',';
        
        List<Service_Type__c> types = [Select Id, Name from Service_Type__c];
        Map<string, List<Client_Service__c>> typeServiceMap = new Map<string, List<Client_Service__c>>();
        Map<String, string> categoryIdNameMap = new Map<String, string>();
        List<MonthlyServiceCategory> alldata = new List<MonthlyServiceCategory>();
        List<String> typeNames = new List<String>();
        Set<Integer> months = new Set<Integer>();
        for(Client_Service__c cs : [Select Id, Date_Time__c, Service__r.Name, Service__r.Service_Type__r.Id, Service__r.Service_Type__r.Name__c from Client_Service__c where Calendar_Year(Date_Time__c)=:selectedyear]){
            if (typeServiceMap.ContainsKey(cs.Service__r.Service_type__r.Id)){
               List<Client_Service__c> clientServices = typeServiceMap.get(cs.Service__r.Service_type__r.Id);
               clientServices .add(cs);
               typeServiceMap.put(cs.Service__r.Service_type__r.Id, clientServices);
            }else{
                typeServiceMap.put(cs.Service__r.Service_type__r.Id, new List<Client_Service__c> { cs });
            }
            categoryIdNameMap.put(cs.Service__r.Service_type__r.Id, cs.Service__r.Service_type__r.Name__c);
            months.add(cs.Date_Time__c.month());
        }
        
        Integer typeCount = typeServiceMap.keySet().size();
        Integer counter = 0; 
        for(String catId : typeServiceMap.keySet()){
            counter++;
            string name = categoryIdNameMap.get(catId);
            typeNames.add(name);
            if(counter!=typeCount)
                monthServiceCategoryData +='\''+name+'\',';
            else
                monthServiceCategoryData +='\''+name+'\'],';
            
            List<Client_Service__c> clientServices = typeServiceMap.get(catId);
            for(Integer i : months){
                MonthlyServiceCategory c = new MonthlyServiceCategory();
                c.year = selectedYear;
                c.month = i;
                c.monthN= monthMap.get(i);
                c.category = name;
                List<Client_Service__c> monthly = new List<Client_Service__c>();
                
                for(Client_Service__c cs : clientServices){
                    if(i==cs.Date_Time__c.month()){
                        monthly.add(cs);
                        
                    }
                }
                c.count = monthly.size();
                allData.add(c);
            }
        }
        
        Map<Integer, List<MonthlyServiceCategory >> byMonthMap = new  Map<Integer, List<MonthlyServiceCategory >>(); 
        for (MonthlyServiceCategory c : allData){
            if(byMonthMap.ContainsKey(c.month)){
               List<MonthlyServiceCategory > l = byMonthMap.get(c.month);
               l.add(c);
               byMonthMap.put(c.month,l);
            }else
                byMonthMap.put(c.month, new List<MonthlyServiceCategory >{ c } );
        }
        counter=0;
        Integer monthCount = 0;
        for(Integer m : byMonthMap.keySet()){
            monthCount ++;
            List<MonthlyServiceCategory > categories = byMonthMap.get(m);
            monthServiceCategoryData +='[\''+monthMap.get(m)+'\',';
            counter=0;
            for(String t : typeNames){
                for(MonthlyServiceCategory  c : categories){
                    if(c.category==t){
                        counter++;
                        
                        if(counter!=typeCount)
                            monthServiceCategoryData += c.count+',';
                        else
                            monthServiceCategoryData += c.count;
                        
                        break;
                    }
                }
            }
            monthServiceCategoryData += monthCount==months.size() ?  ']' : '],';
        }
        monthServiceCategoryData +=']';
        
    }
    
    public List<MonthlySaleProfit> groupedData { get; set; }
    
    public void getMonthlySalesProfit(){
        monthSalesProfitData  = '[[\'Month\',\'Sales\',\'Expenses\',\'Profit\'],';
       
        List<MonthlySaleProfit> allData = new List<MonthlySaleProfit>();
        
        for(Client_Service__c cs : [Select Date_Time__c, Service__r.Price__c, Discount__c from Client_Service__c where Calendar_Year(Date_Time__c)=:selectedyear]){
            if(cs.Service__r!=null){
            MonthlySaleProfit o = new MonthlySaleProfit();
            o.year = selectedyear;
            o.month = cs.date_time__c.month();
            
            o.grossSales = cs.Service__r.Price__c - (cs.Discount__c==null?0: cs.Discount__c);
            allData.add(o);
            }
        }
        
        for(Product_Sale__c ps : [Select Amount__c, date__c from Product_Sale__c where Type__c='Sale' and Calendar_Year(Date__c)=:selectedyear]){
            MonthlySaleProfit o = new MonthlySaleProfit();
            o.year = selectedyear;
            o.month = ps.date__c.month();
            o.grossSales = ps.Amount__c;
            allData.add(o);
        }
        
        for(Expense__c e : [Select Amount__c, date__c from Expense__c where Calendar_Year(Date__c)=:selectedyear]){
            MonthlySaleProfit o = new MonthlySaleProfit();
            o.year = selectedyear;
            o.month = e.date__c.month();
            o.expenses = e.Amount__c;
            allData.add(o);
        }
        
        for(Staff_Commission__c c : [Select Date__c, Amount__c from Staff_Commission__c where Calendar_Year(Date__c)=:selectedyear]){
            MonthlySaleProfit o = new MonthlySaleProfit();
            o.year = selectedyear;
            o.month = c.date__c.month();
            o.expenses = c.Amount__c;
            allData.add(o);
        }
        
        Map<Integer, List<MonthlySaleProfit>> monthlyMap = new Map<Integer, List<MonthlySaleProfit>>();
        
        for(MonthlySaleProfit o : allData){
            if(monthlyMap.containsKey(o.month)){
                List<MonthlySaleProfit> l = monthlyMap.get(o.month);
                l.add(o);
                monthlyMap.put(o.month, l);
            }else{
                 monthlyMap.put(o.month, new List<MonthlySaleProfit> { o });
            }
        }
        
        groupedData = new List<MonthlySaleProfit>();
        integer count = monthlyMap.keySet().size();
        integer counter =0;
        for(Integer i : monthlyMap.keySet()){
            counter++;
            MonthlySaleProfit o = new MonthlySaleProfit();
            o.year = selectedyear;
            o.month = i; 
            decimal gross = 0;
            decimal expenses =0;
            for(MonthlySaleProfit a : monthlyMap.get(i)){
                gross+= a.grossSales==null? 0 : a.grossSales;
                expenses+= a.expenses==null?0 : a.expenses;
            }
            
            o.grossSales = gross;
            o.expenses = expenses;
            o.monthN= MonthMap.get(i);
            groupedData.add(o);
            if(counter!=count)
            monthSalesProfitData  += '[\''+monthMap.get(i)+'\','+o.grossSales+','+o.expenses+','+o.profit+'],';
            else 
                 monthSalesProfitData  += '[\''+monthMap.get(i)+'\','+o.grossSales+','+o.expenses+','+o.profit+']';
        }
        monthSalesProfitData  +=']';
        
    }
    
    public void getMonthlyExpenseByCategory(){
        getmonthlyExpense('category');       
        
    }
    
    public void getMonthlyExpenseByType(){
        getmonthlyExpense('type');       
        
    }
    
    private void getmonthlyExpense(string cat){
        
        string output= '[[\'Month\',';
        
        Map<string, List<Expense__c>> categoryExpenseMap = new Map<string, List<Expense__c>>();
        
        List<MonthlyExpenseType > alldata = new List<MonthlyExpenseType >();
        Set<String> categoryNames = new Set<String>();
        Set<Integer> months = new Set<Integer>();
        
        for(Expense__c e : [Select Id, Amount__c, Type__c, SubType__c, Date__c from Expense__c where Calendar_Year(Date__c)=:selectedyear]){
            
            String n = cat=='category' ? e.Type__c : e.subType__c;
            
            if (categoryExpenseMap.ContainsKey(n)){
               List<Expense__c> expenses= categoryExpenseMap.get(n);
               expenses.add(e);
               categoryExpenseMap.put(n, expenses);
            }else{
                categoryExpenseMap.put(n, new List<Expense__c> { e});
            }
            
            months.add(e.Date__c.month());
        }
        
        Integer typeCount = categoryExpenseMap.keySet().size();
        Integer counter = 0; 
        
        for(String type : categoryExpenseMap.keySet()){
            counter++;
            
            categoryNames.add(type);
            if(counter!=typeCount)
                output+='\''+type+'\',';
            else
                output+='\''+type+'\'],';
            
            List<Expense__c> expenses= categoryExpenseMap.get(type);
            for(Integer i : months){
                MonthlyExpenseType c = new MonthlyExpenseType();
                c.year = selectedyear;
                c.month = i;
                c.monthN= monthMap.get(i);
                c.name= type;
                decimal amount=0;
                
                for(Expense__c e: expenses){
                    if(i==e.Date__c.month()){
                        amount+= e.Amount__c ==null ? 0 : e.Amount__c;                        
                    }
                }
                c.amount = amount;
                allData.add(c);
            }
        }
        
        Map<Integer, List<MonthlyExpenseType>> byMonthMap = new  Map<Integer, List<MonthlyExpenseType>>(); 
        for (MonthlyExpenseType  c : allData){
            if(byMonthMap.ContainsKey(c.month)){
               List<MonthlyExpenseType> l = byMonthMap.get(c.month);
               l.add(c);
               byMonthMap.put(c.month,l);
            }else
                byMonthMap.put(c.month, new List<MonthlyExpenseType>{ c } );
        }
        counter=0;
        Integer monthCount = 0;
        for(Integer m : byMonthMap.keySet()){
            monthCount ++;
            List<MonthlyExpenseType> expenses= byMonthMap.get(m);
            output+='[\''+monthMap.get(m)+'\',';
            counter=0;
            for(String t : categoryNames){
                decimal amt = 0;
                for(MonthlyExpenseType c : expenses){
                    if(c.name==t){
                        amt+= c.amount;
                        counter++;                        
                        if(counter!=typeCount)
                            output+= amt+',';
                        else
                            output+= amt;
                        
                        //break;
                    }
                }
            }
            output+= monthCount==months.size() ?  ']' : '],';
        }
        output+=']';
        
        if(cat=='category')
        monthExpenseCategoryData = output;
        else
        monthExpenseTypeData= output;
    }
    
    
    
}