public class ClientServiceController {

   // public String serviceOptions { get; set; }

   // public String serviceTypeOptions { get; set; }

    public decimal totalCommission{ get; set; }
    public decimal totalDiscount{ get; set; }
    public decimal totalGross{ get; set; }
    public date selectedDate { get; set; }
    public Boolean dayIsConfirmed { get; set; }
    
    public class ClientService {
        public String Id { get; set; }
        public String Client { get; set; }
        public decimal Amount { get; set; }
        public decimal Discount { get; set; }
        public decimal Commission { get; set; }
        public String Service { get; set; }
        public String Therapist { get; set; }
        public Date Date_Time { get; set; }
        public String Confirmed_By { get; set; }
        public DateTime CreatedDate { get; set; }
    }
    
    public List<Staff__c> getStaffs(){
        return [Select Id, Full_Name__c, Name__c, Alias__c, Active__c from Staff__c where Active__c=true];
    }
    
    public String SelectedServiceTypeId { get; set; }
    public List<Service_Type__c> getServiceTypes(){
        return [Select Id, Name, Name__c from Service_Type__c];
    }
    
    public List<SelectOption> getServiceTypeOptions(){
        List<SelectOption> options = new  List<SelectOption>();
        options.add(new SelectOption('','--Select--'));
        for (Service_Type__c s : [Select Id, Name, Name__c from Service_Type__c]){
            options.add(new SelectOption(s.Id, s.Name__c));
            
        }
        return options;
    }
    
    public string Amount { get; set; }
    public string Commission{ get; set; }
    public String SelectedServiceId { get; set; }
    public List<Service__c> servicesByType{ get; set; }
    public Pagereference getServices(){
        servicesByType=  [Select Id, Name, Name__c, Price__c, Commission__c, Percent_Commission__c, Service_Type__c
                    from Service__c where  Service_Type__c =: SelectedServiceTypeId];
        return null;            
    }
    
    public void deleteClientService(){
        string id = Apexpages.currentPage().getParameters().get('clientserviceid');
        if (id!=null){
            delete [Select Id from Client_Service__c where Id =: id];
            getServicesToday();
        }
        
    }    
    
    public void setSelectedClientService(){
        string id = Apexpages.currentPage().getParameters().get('clientserviceid');
        if (id!=null){
            for(Client_Service__c s : ser){
                if (s.Id==id){
                    CS = s;                    
                    break;
                }
            }
            if (CS!=null){
                SelectedServiceTypeId = cs.service__r.service_type__c;
                getServiceTypeOptions();
                SelectedServiceId = CS.Service__c;
            }
        }
    }
    
    public void getServicesByDay(){
        string month = Apexpages.currentPage().getParameters().get('month');
        string day = Apexpages.currentPage().getParameters().get('day');
        string yr = Apexpages.currentPage().getParameters().get('year');
        Services = new List<ClientService>();
        DateTime d = DateTime.newInstance(integer.valueof(yr),integer.valueof(month),integer.valueof(day),0,0,0); 
        
        if (day != '-1'){        
        ser= [Select Id, Date_Time__c,  Client__r.First_Name__c, Client__r.Last_Name__c, service__r.service_type__c,
                        Service__r.Name__c, Service__r.Price__c, Service__r.Commission__c, Service__r.Percent_Commission__c, Discount__c, Confirmed_By__c,
                        (Select Id, Client_Service__c, Amount__c, Staff__r.Alias__c from Staff_Commissions__r), CreatedDate
                        from Client_Service__c
                        where Date_Time__c=:d.date()];
        }else{
            ser= [Select Id, Date_Time__c,  Client__r.First_Name__c, Client__r.Last_Name__c, service__r.service_type__c,
                        Service__r.Name__c, Service__r.Price__c, Service__r.Commission__c, Service__r.Percent_Commission__c, Discount__c, Confirmed_By__c,
                        (Select Id, Client_Service__c, Amount__c, Staff__r.Alias__c from Staff_Commissions__r), CreatedDate
                        from Client_Service__c
                        where Calendar_Year(Date_Time__c)=:integer.valueof(yr) and Calendar_Month(Date_Time__c)=:integer.valueof(month) order by Date_Time__c desc];
        }                
        if(ser.size()>0){
            dayIsConfirmed =  ser[0].Confirmed_By__c==null || ser[0].Confirmed_By__c=='Not Confirmed' ? false : true;      
             
            Map<Id, List<Staff_Commission__c>> serviceCommissions= new Map<Id, List<Staff_Commission__c>>();
            
            totalGross = 0;
            totalDiscount = 0;
            totalCommission = 0;
                            
            for (Client_Service__c  s : ser){
                totalGross += s.Service__r.Price__c;
                totalDiscount += s.Discount__c==null ? 0 : s.Discount__c;
                decimal coms = 0;
                String th= '';
                
                for(Staff_Commission__c c : s.Staff_Commissions__r){
                    coms+= c.Amount__c == null ? 0 : c.Amount__c;
                    th += c.Staff__r.Alias__c+ ', ';
                }
                totalCommission += coms; 
                
                ClientService o = BodyTechUtil.toClientService(s, coms,th);
                o.therapist = th;
                o.commission = coms;
                o.CreatedDate = s.CreatedDate;
                Services.add(o);
                
            }
        }
        selectedDate = day!='-1' ? d.date() : null; 
               
    }
    
    public Pagereference setAmount(){
        if (SelectedServiceId!=null && SelectedServiceId!=''){
            
            for (Service__c s : servicesByType){
                if (s.Id==SelectedServiceId){
                    Amount = ''+s.Price__c;
                    Commission = s.Commission__c == null? ''+((s.Percent_Commission__c/100)*s.Price__c) : ''+s.Commission__c;
                    break;
                }
            }
        }else
            Amount='0.00';
        return null;
    }
       
    public List<SelectOption> getServiceOptions(){
        List<SelectOption> options = new  List<SelectOption>();
        options.add(new SelectOption('','--Select--'));
        if (servicesByType != null)
        for (Service__c s : servicesByType){
            options.add(new SelectOption(s.Id, s.Name__c));
        }
        
        return options;
    }
    
    public ClientServiceController (){
       // getServicesToday();
    }

    public Client_Service__c CS { get; set; }
    public List<ClientService> Services { get; set; }
    
    public void createNewService(){
        CS = new Client_Service__c();
        CS.Date_Time__c = System.Today();
        CS.Service__c = null;
        SelectedServiceTypeId = null;
        SelectedServiceId = null; 
        Amount='0.00';
        Commission ='0.00';
        
    }
    
    public List<Client_Service__c > ser { get; set; }
    public void getServicesToday(){
        Services = new List<ClientService>();
        ser= [Select Id,  Date_Time__c , Client__r.First_Name__c, Client__r.Last_Name__c, service__r.service_type__c,
                        Service__r.Name__c, Service__r.Price__c, Service__r.Commission__c, Service__r.Percent_Commission__c, Discount__c, Confirmed_By__c,
                        (Select Id, Client_Service__c, Amount__c, Staff__r.Alias__c from Staff_Commissions__r)
                         from Client_Service__c where Date_Time__c=Today
                      order by Date_Time__c desc  ];
        
        if(ser.size()>0){
            dayIsConfirmed =  ser[0].Confirmed_By__c==null || ser[0].Confirmed_By__c=='Not Confirmed' ? false : true;                 
            List<Staff_Commission__c> commissions = [Select Id, Client_Service__c, Amount__c, Staff__r.Alias__c from Staff_Commission__c where Client_Service__r.Date_Time__c=Today]  ;               
            
            Map<Id, List<Staff_Commission__c>> serviceCommissions= new Map<Id, List<Staff_Commission__c>>();
            for(Staff_Commission__c c : commissions){
                if(serviceCommissions.ContainsKey(c.Client_Service__c)){
                    List<Staff_Commission__c> coms = serviceCommissions.get(c.Client_Service__c);
                    coms.add(c);
                    serviceCommissions.put(c.Client_Service__c, coms);
                }else{
                    serviceCommissions.put(c.Client_Service__c, new List<Staff_Commission__c> { c });
    
                }
            }
            totalGross = 0;
            totalDiscount = 0;
            totalCommission = 0;
                            
            for (Client_Service__c  s : ser){
                totalGross += s.Service__r.Price__c;
                totalDiscount += s.Discount__c==null ? 0 : s.Discount__c;
                decimal coms = 0;
                String th = '';
                for(Staff_Commission__c com : s.Staff_Commissions__r){
                    th+= com.Staff__r.Alias__c+',';
                    coms+= com.Amount__c==null? 0: com.Amount__c;
                }
                totalCommission += coms; 
                Services.add(BodyTechUtil.toClientService(s, coms, th));
            }
        }
            
        selectedDate =System.Today();
                       
    }
    
    public void saveClientService(){
        if (CS!=null){
            string com = Apexpages.currentPage().getParameters().get('staffcommission');
            
            if (com!=null){
                CS.Service__c = SelectedServiceId;
                upsert CS;
                
                List<Staff_Commission__c > commissions = new List<Staff_Commission__c> ();
                for(string s : com.split(';')){
                    Staff_Commission__c c = new Staff_Commission__c();
                    c.Staff__c = s.split('-')[0];
                    c.Amount__c = decimal.valueOf(s.split('-')[1]);
                    c.Client_Service__c = CS.Id;
                    commissions.add(c);
                }
                insert commissions;
                
                getServicesToday(); 
            }  
        }
    }

}