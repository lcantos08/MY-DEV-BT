public class DailySummaryController{
    
    public DailySummaryController(){
        Date today = System.today();
        selectedMonth =today.month();
        selectedYear = today.year();
    }
    
    public class DailySummaryList{
        public List<DailySummary> summaryList { get; set; }
        public Integer count{ get{
                if(summaryList==null)
                    return 0;
                Integer c=0;
                for(DailySummary d : summaryList){
                    c+= d.serviceCount;
                }
                return c;
            }
        }
        public decimal totalNetService { get{
            if(summaryList != null){
                decimal v = 0;
                for(DailySummary d : summaryList){
                    v += d.netService;
                }
                return v;
            }
            return 0;
            }
        }
        public decimal totalGrossService { get{
            if(summaryList != null){
                decimal v = 0;
                for(DailySummary d : summaryList){
                    v += d.GrossService;
                }
                return v;
            }
            return 0;
            }
        }
        
        public decimal totalTherapistCommission  { get{
            if(summaryList != null){
                decimal v = 0;
                for(DailySummary d : summaryList){
                    v += d.TherapistCommission ;
                }
                return v;
            }
            return 0;
            }
        }
        
        public decimal totalGrossMega   { get{
            if(summaryList != null){
                decimal v = 0;
                for(DailySummary d : summaryList){
                    v += d.Mega ;
                }
                return v;
            }
            return 0;
            }
        }
        
        public decimal totalNetMega   { get{
            if(summaryList != null){
                decimal v = 0;
                for(DailySummary d : summaryList){
                    v += d.netMega ;
                }
                return v;
            }
            return 0;
            }
        }
        
        public decimal totalMegaCommission    { get{
            if(summaryList != null){
                decimal v = 0;
                for(DailySummary d : summaryList){
                    v += d.MegaCommission ;
                }
                return v;
            }
            return 0;
            }
        }
        
        public decimal totalExpenses { get{
            if(summaryList != null){
                decimal v = 0;
                for(DailySummary d : summaryList){
                    v += d.Expenses;
                }
                return v;
            }
            return 0;
            }
        }
        
        public decimal totalSMC { get{
            if(summaryList != null){
                decimal v = 0;
                for(DailySummary d : summaryList){
                    v += d.SMC;
                }
                return v;
            }
            return 0;
            }
        }
        
        public decimal totalDiscount { get{
            if(summaryList != null){
                decimal v = 0;
                for(DailySummary d : summaryList){
                    v += d.discount;
                }
                return v;
            }
            return 0;
            }
        }
        
        public decimal totalNetSales { 
            get{
                return totalNetService + totalNetMega - totalExpenses - totalSMC; 
            }
        }
    }    
    
    public class DailySummary{
        public date SaleDate { get; set; }
        public decimal GrossService { get; set; }
        public decimal TherapistCommission { get; set; }
        public decimal NetService { 
            get{
                return GrossService - Discount - TherapistCommission;
            } 
        }
        public decimal Mega { get; set; }
        public decimal MegaCommission { get; set; }
        public decimal netMega { 
            get{
                return Mega - MegaCommission;
            } 
        }
        public decimal Expenses { get; set; }
        public decimal SMC { 
            get{
                if (managerPresent!=null)
                    if (managerPresent)
                        return .1 * TherapistCommission;
                return 0;
            }
        }
        
        public decimal NetSales { 
            get{
                return NetService + NetMega - Expenses - SMC; 
            }
        }
        public decimal discount { get; set; }
        public integer day { get; set; }
        public boolean managerPresent { get; set; }
        public Integer servicecount { get; set; }
    }
    
    public integer selectedmonth { get; set; }
    public integer selectedyear { get; set; }
    
    public List<SelectOption> getMonthOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0', '--Select--'));
        options.add(new SelectOption('1', 'Jan'));
        options.add(new SelectOption('2', 'Feb'));
        options.add(new SelectOption('3', 'Mar'));
        options.add(new SelectOption('4', 'Apr'));
        options.add(new SelectOption('5', 'May'));
        options.add(new SelectOption('6', 'Jun'));
        options.add(new SelectOption('7', 'Jul'));
        options.add(new SelectOption('8', 'Aug'));
        options.add(new SelectOption('9', 'Sep'));
        options.add(new SelectOption('10', 'Oct'));
        options.add(new SelectOption('11', 'Nov'));
        options.add(new SelectOption('12', 'Dec'));
        return options;
    }
    
    public List<SelectOption> getYearOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('2017', '--Select--'));
        options.add(new SelectOption('2017', '2017'));
        options.add(new SelectOption('2016', '2016'));
        options.add(new SelectOption('2015', '2015'));
        return options;
    }
    
    public integer getMonthDays(){
        if (selectedmonth == 9 || selectedmonth==4 || selectedmonth == 6 || selectedmonth == 11)
            return 30;
        else if (selectedmonth==1 || selectedmonth==3 || selectedmonth == 5 || selectedmonth == 7 ||  selectedmonth == 8 || selectedmonth == 10 || selectedmonth == 12)
            return 31;
        return 29;      
    }
    
    
    public DailySummaryList getMonthlySummary(){
        DailySummaryList o = new DailySummaryList ();
        List<DailySummary> data = new List<DailySummary>();
        List<Client_Service__c> services = [Select Id, Date_Time__c, Client__r.First_Name__c, Client__r.Last_Name__c, service__r.service_type__c,
                        Service__r.Name__c, Service__r.Price__c, Service__r.Commission__c, Discount__c, Confirmed_By__c,
                        (Select Id, Client_Service__c, Amount__c, Product_Sale__c, Staff__r.Alias__c, Date__c from Staff_Commissions__r)
                         from Client_Service__c
                        where CALENDAR_MONTH(Date_Time__c) =: selectedmonth and CALENDAR_Year(Date_Time__c) =: selectedYear];
        
        Set<String> serviceIds = new Set<String>();
        Map<Date, List<ClientServiceController.ClientService>> dailySales = new Map<Date, List<ClientServiceController.ClientService>>();
        
        for (Client_Service__c s : services){
            serviceIds.add(s.Id);
        }
        
      
        List<Staff_Commission__c> pcommissions = [Select Id, Client_Service__c, Amount__c, 
                Product_Sale__c, Staff__r.Alias__c, Date__c from Staff_Commission__c 
                where Product_Sale__c!=null and  CALENDAR_MONTH(Date__c) =: selectedmonth and CALENDAR_Year(Date__c) =: selectedYear]; 
        
        for (Client_Service__c s : services){
            String th = '';
            decimal comm =0;
            for(Staff_Commission__c com : s.Staff_Commissions__r){
                th+= com.Staff__r.Alias__c+',';
                comm+= com.Amount__c==null? 0: com.Amount__c;
            }
            ClientServiceController.ClientService cs = BodyTechUtil.toClientService(s,  comm, th);
            if (dailySales.ContainsKey(s.Date_Time__c)){
                List<ClientServiceController.ClientService> sales = dailySales.get(s.Date_Time__c);
                sales.add(cs);
                dailySales.put(s.Date_Time__c, sales);
            }else{
                dailySales.put(s.Date_Time__c, new List<ClientServiceController.ClientService> { cs });
            }
            
            
        }  
        
        
        List<Product_Sale__c> Sales = [Select Id, 
                                              Final_Amount__c, 
                                              Discount__c, 
                                              Amount__c, 
                                              Staff__r.Id, 
                                              Staff__r.Name__c, 
                                              Product__r.Id, 
                                              Date__c,
                                              Product__r.Name__c 
                                                  from Product_Sale__c 
                                                  where CALENDAR_MONTH(Date__c) =: selectedmonth and CALENDAR_Year(Date__c) =: selectedYear
                                                  and Type__c='Sale'];      
        Map<Date, List<Product_Sale__c>> dailyMega = new Map<Date, List<Product_Sale__c>>();
        
        for(Product_Sale__c s : sales){
            if (dailyMega.ContainsKey(s.Date__c)){
                List<Product_Sale__c> mega = dailyMega.get(s.date__c);
                mega.add(s);
                dailyMega.put(s.date__c, mega);
            }else{
                dailyMega.put(s.Date__c, new List<Product_Sale__c> { s } );
            }
        }
        
        Map<Date, List<Expense__c>> dailyExpenses = new Map<Date, List<Expense__c>>();
        for(Expense__c e : [Select Id, Date__c, Amount__c from Expense__c where CALENDAR_MONTH(Date__c) =: selectedmonth and CALENDAR_Year(Date__c) =: selectedYear]){
            if (dailyExpenses.ContainsKey(e.Date__c)){
                List<Expense__c> expenses = dailyExpenses.get(e.date__c);
                expenses.add(e);
                dailyExpenses.put(e.date__c, expenses);
            }else{
                dailyExpenses.put(e.Date__c, new List<Expense__c> { e } );
            }
        }
        
        
        
        for (Integer i=0; i< getMonthDays() ; i++){
            integer x = i+1;
            decimal grossService = 0;
            decimal thComm = 0;
            decimal mega = 0;
            decimal megaComm = 0;
            decimal netService = 0;
            decimal exp = 0;
            decimal smc = 0;
            decimal netSales = 0;
            decimal disc = 0;
                        
            DailySummary s = new DailySummary();
            s.SaleDate = date.newinstance(selectedYear, selectedmonth, x);
            s.day = x;
            Integer serviceCount =0;
            for (Date d : dailySales.KeySet()){
                if (d.day() == x){
                    for(ClientServiceController.ClientService sale : dailySales.get(d)){
                        grossService += sale.amount==null ? 0 : sale.amount;       
                        thComm += sale.Commission==null ? 0 : sale.Commission;                        
                        disc += sale.discount==null ? 0 : sale.discount;
                        serviceCount ++;
                    }
                }
            }
            
            for (Date d : dailyMega.KeySet()){
                if (d.day() == x){
                    for (Product_Sale__c p : dailyMega.get(d)){
                        if (p.Amount__c != null){
                            mega += p.Amount__c;                            
                        }
                    }                   
                }
            }
            
            for(Staff_Commission__c com : pcommissions){
                        if(com.Date__c.day()==x && com.Product_Sale__c!=null)
                        {
                            if(com.Amount__c!=null)
                            megaComm+= com.Amount__c;
                        }
                    }
            
            for (Date d : dailyExpenses.KeySet()){
                if (d.day() == x){
                    for (Expense__c e : dailyExpenses.get(d)){
                        if (e.Amount__c != null)
                            exp+= e.Amount__c;
                    }
                }
            }
            
            s.discount = disc;
            s.therapistcommission = thcomm;
            s.grossservice = grossservice;
            s.mega = mega;
            s.megacommission = megacomm;
            s.servicecount = serviceCount;
            //s.smc = smc;
            s.expenses = exp;
            data.add(s);
        }
        o.summaryList = data;
        return o;
    }
    
    
}