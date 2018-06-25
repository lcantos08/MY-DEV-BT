public class CashFlowController{
    
    public class CashFlow implements Comparable{
        
        public Integer compareTo(Object compareTo) 
    {
        CashFlow  cf= (CashFlow ) compareTo;
        if (mDate == cf.mDate) return 0;
        if (mDate> cf.mDate) return -1;
        return 1;        
    }
    
        public Date mdate { get; set; }
        public List<Client_Service__c> services{ get; set; }
        public List<Expense__c> expenses{ get; set; }
        public List<Product_Sale__c> productSales{ get; set; }
        public List<Staff_Commission__c> staffCommissions{ get; set; }
        public decimal misc { 
            get{
                decimal val =0;
                if(expenses !=null){
                    for(Expense__c c : expenses){
                        if(c.SubType__c=='Miscellaneous')
                        val+=c.Amount__c;
                    }
                }
                return val;
            }    
        }
        public decimal mallRent { 
            get{
                decimal val =0;
                if(expenses !=null){
                    for(Expense__c c : expenses){
                        if(c.SubType__c=='Mall Rent')
                        val+=c.Amount__c;
                    }
                }
                return val;            
        } }
        public decimal salary { 
            get{
                decimal val =0;
                if(expenses !=null){
                    for(Expense__c c : expenses){
                        if(c.SubType__c=='Salary')
                        val+=c.Amount__c;
                    }
                }
                return val;
            
            }
        }
        
        public decimal productOrder{ 
            get{
                decimal val =0;
                if(expenses !=null){
                    for(Expense__c c : expenses){
                        if(c.SubType__c=='Product Order')
                        val+=c.Amount__c;
                    }
                }
                return val;
            
            }
        }
        
       public decimal royaltyFee{ 
            get{
                decimal val =0;
                if(expenses !=null){
                    for(Expense__c c : expenses){
                        if(c.SubType__c=='Royalty Fee')
                        val+=c.Amount__c;
                    }
                }
                return val;
            
            }
        }
        
        public decimal permits{ 
            get{
                decimal val =0;
                if(expenses !=null){
                    for(Expense__c c : expenses){
                        if(c.SubType__c=='Permits/Forms')
                        val+=c.Amount__c;
                    }
                }
                return val;
            
            }
        }
        
        public decimal grossService{
            get{
                decimal val =0;
                if(services!=null){
                    for(Client_Service__c c : services){
                        val+=c.Service__r.Price__c;
                    }
                }
                return val;
            }
        }
        
        public decimal grossProductSales{
            get{
                decimal val =0;
                if(productSales!=null){
                    for(Product_sale__c c : productSales){
                        val+=c.Amount__c;
                    }
                }
                return val;
            }
        }
        
        
        public decimal discount{
            get{
                decimal val =0;
                if(services!=null){
                    for(Client_Service__c c : services){
                        val+=c.Discount__c==null?0:c.Discount__c;
                    }
                }
                return val;
            }
        }
        
        
        public decimal commisions{
            get{
                decimal val =0;
                if(staffCommissions!=null){
                    for(Staff_Commission__c c : staffCommissions){
                        if(c.client_service__c!=null)
                        val+=c.Amount__c;
                    }
                }
                return val;
            }
        }
        
        public decimal megacommissions{
            get{
                decimal val =0;
                if(staffCommissions!=null){
                    for(Staff_Commission__c c : staffCommissions){
                        if(c.product_sale__c!=null && c.product_sale__r.type__c=='Sale')
                            val+=c.Amount__c;
                    }
                }
                return val;
            }
        }
        
        public decimal expenseAmount{
            get{
                decimal val =0;
                if(expenses !=null){
                    for(Expense__c c : expenses){
                        if(c.SubType__c!='Mall Rent' && c.SubType__c!='Salary' && c.SubType__c!='Royalty Fee' && c.SubType__c!='Product Order' 
                        && c.SubType__c!='Permits/Forms' && c.SubType__c!='Miscellaneous')
                        val+=c.Amount__c;
                    }
                }
                return val;
            }
        }
               
        
        public decimal netSales{
            get{
                return grossService + grossProductSales - expenseAmount - commisions - discount - megacommissions;
            }
        }
        
        public List<Bank_Transaction__c> transactions { get; set; }
        
        
        public decimal amountWithdrawn { 
            get{
                decimal val =0;
                if(transactions!=null){
                    for(Bank_Transaction__c t : transactions){
                        if(t.Type__c=='Withdrawal')
                            val+=t.Amount__c;
                    }
                }
                return val;
            }
        }
        public decimal amountDeposited { 
            get{
                decimal val =0;
                if(transactions!=null){
                    for(Bank_Transaction__c t : transactions){
                        if(t.Type__c=='Deposit')
                            val+=t.Amount__c;
                    }
                }
                return val;
            }
        }
        
        public decimal bankInterest{ 
            get{
                decimal val =0;
                if(transactions!=null){
                    for(Bank_Transaction__c t : transactions){
                        if(t.Type__c=='Interest Earned/Withheld')
                            val+=t.Amount__c;
                    }
                }
                return val;
            }
        }
        
        public decimal runningTotal { 
            get{
                return startingBalance + amountDeposited  - amountWithdrawn + bankInterest;
            }
        }
        
        public decimal cashOnHandStarting { get; set; }
        public decimal cashOnHand { get {
            return cashOnHandStarting + netSales - amountDeposited - mallRent - salary + amountWithdrawn - misc - royaltyFee - productOrder - permits;
        } }
        public decimal startingBalance { get; set; }
        
    }
    
    public CashFlowController(){
        startingBalance  = 72752.62 - 20000 - 45000 - 5000 + 13000; //13K--jenina, 20K-jenina, 45K--withdraw , 5K-wedding gift
        code='lui_anna17';
        //getCashFlow();
        
    }
    public string code { get; set; }
    public string codeToValidate { get; set; }
    public boolean valid { get; set; }
    public void validate(){
        valid= code==codeToValidate;
       
    }
    
    public decimal startingBalance { get; set; }
    public transient List<cashFlow> cashFlows { get; set; } 
    public void getCashFlow(){
        cashFlows = new List<CashFlow>();
        Datetime startDate = datetime.newInstance(2016,1,1,0,0,0);
        Datetime today = System.now();
        integer Days = Integer.valueOf((today.getTime() - startDate.getTime())/(1000*60*60*24));
        
        Map<date, List<Client_Service__c>> dayServices = new Map<date, List<Client_Service__c>>();
        for(Client_Service__c s : [Select Id, Service__r.Price__c, Date_Time__c, Discount__c  from Client_Service__c]){
            if(dayServices.ContainsKey(s.Date_time__c)){
                List<Client_Service__c> services = dayServices.get(s.Date_time__c);
                services.add(s);
                dayServices.put(s.Date_time__c,services);
            }else{
                dayServices.put(s.Date_time__c, new List<Client_Service__c> { s } );
            }
        }
        
        Map<date, List<Product_Sale__c>> dayMega= new Map<date, List<Product_Sale__c>>();
        for(Product_Sale__c s : [Select Id,Staff__c, date__c, Amount__c, Product__c from Product_Sale__c where Type__c='Sale']){
            if(dayMega.ContainsKey(s.Date__c)){
                List<Product_Sale__c > mega= dayMega.get(s.Date__c);
                mega.add(s);
                dayMega.put(s.Date__c,mega);
            }else{
                dayMega.put(s.Date__c, new List<Product_Sale__c> { s } );
            }
        }
        
        
        Map<date, List<Staff_Commission__c>> dayCommissions= new Map<date, List<Staff_Commission__c>>();
        Map<date, List<Staff_Commission__c>> dayMegaCommissions= new Map<date, List<Staff_Commission__c>>();
        
        for(Staff_Commission__c s : [Select Id, Client_Service__c, Client_Service__r.Date_time__c,  Product_Sale__c, Product_Sale__r.Date__c, product_sale__r.Type__c,  Amount__c from Staff_Commission__c]){
            if (s.client_service__c!=null){
                if(dayCommissions.ContainsKey(s.Client_Service__r.Date_time__c)){
                    List<Staff_Commission__c> coms= dayCommissions.get(s.Client_Service__r.Date_time__c);
                    coms.add(s);
                    dayCommissions.put(s.Client_Service__r.Date_time__c,coms);
                }else{
                    dayCommissions.put(s.Client_Service__r.Date_time__c, new List<Staff_Commission__c> { s } );
                }
            }else if(s.product_sale__c!=null){
                if(dayMegaCommissions.ContainsKey(s.Product_Sale__r.Date__c)){
                    List<Staff_Commission__c> coms= dayMegaCommissions.get(s.Product_Sale__r.Date__c);
                    coms.add(s);
                    dayMegaCommissions.put(s.Product_Sale__r.Date__c,coms);
                }else{
                    dayMegaCommissions.put(s.Product_Sale__r.Date__c, new List<Staff_Commission__c> { s } );
                }
            }
        }
               
        
        Map<date, List<Expense__c>> dayExpenses= new Map<date, List<Expense__c>>();
        for(Expense__c s : [Select Id,Date__c, Amount__c, Description__c, Type__c, SubType__c  from Expense__c]){
            if(dayExpenses.ContainsKey(s.Date__c)){
                List<Expense__c> exp= dayExpenses.get(s.Date__c);
                exp.add(s);
                dayExpenses.put(s.Date__c,exp);
            }else{
                dayExpenses.put(s.Date__c, new List<Expense__c> { s } );
            }
        }
        
        Map<date, List<Bank_Transaction__c>> dayTransactions= new Map<date, List<Bank_Transaction__c>>();
        for(Bank_Transaction__c s : [Select Id,Date__c, Amount__c, Type__c from Bank_Transaction__c]){
            if(dayTransactions.ContainsKey(s.Date__c)){
                List<Bank_Transaction__c> tran= dayTransactions.get(s.Date__c);
                tran.add(s);
                dayTransactions.put(s.Date__c,tran);
            }else{
                dayTransactions.put(s.Date__c, new List<Bank_Transaction__c> { s } );
            }
        }
        
        
        
        for(Integer i=0; i<= days ; i++){
            Date t = datetime.newInstance(2016,1,1,0,0,0).date();
            t = t.addDays(i);
            CashFlow f = new CashFlow();
            if(i==0){
            f.startingBalance =startingBalance;
            f.cashOnHandStarting =0;
            }
            else{
                f.startingBalance =cashFlows[i-1].runningTotal;
                f.cashOnHandStarting  = cashFlows[i-1].cashOnHand;
            }
            f.mDate = t;
           // if(i==14)
           //     f.misc = 1000; 
           // else
           //     f.misc = 0;    
            f.services = dayServices.get(t);
            List<Staff_Commission__c> allcom = new List<Staff_Commission__c> ();
            if(dayCommissions.get(t)!=null)
            allcom.addAll(dayCommissions.get(t));
            if(dayMegaCommissions.get(t)!=null)
            allcom.addAll(dayMegaCommissions.get(t));
            f.staffCommissions = allcom;
            f.expenses = dayExpenses.get(t);
            f.transactions = dayTransactions.get(t);
            f.productSales = dayMega.get(t);
            cashFlows.add(f);
        }
        cashFlows.sort();
        //getPse1();
    }
    
    public string pse { get; set; }
    public void getPse1(){
        pse='retrieving pse';
        HttpRequest req = new HTTPRequest();
        string url = 'http://pse.com.ph/stockMarket/companyInfoHistoricalData.html?method=getRecentSecurityQuoteData&ajax=true';
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody('security='+EncodingUtil.urlEncode('237', 'UTF-8'));
        
        Http http = new HTTP();
        HttpREsponse res = http.send(req);
        pse = res.getBody();
        
    }

}