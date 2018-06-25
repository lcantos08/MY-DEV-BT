public with sharing class ProductSaleController{
    
    public Product_Sale__c Sale { get; set; }
    public List<Product_Sale__c> Sales { get; set; }
    private List<Product__c> products = [Select Id, Name__c, Retail_Price__c, Commission__c from Product__c order by Name__c];
    public string SelectedProductId { get; set; }
    public decimal gross { get; set; }
    public decimal net { get; set; }
    public decimal commission{ get; set; }
    public decimal discount{ get; set; }
    public List<Product_Sale__c> ProductSales{ get; set; }
    public List<Product_Sale__c> ClinicUse { get; set; }
    public string Title { get; set; }
    public string view { get { return view; } set { view=value; title = view=='ps' ? 'Product Sale' : 'Clinic Use';} }
    public Date SelectedDate { get; set; }
    public boolean dayisConfirmed { get; set; }
    
    public List<SelectOption> productOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','--Select--'));
            if(products !=null){
                for(Product__c p : products ){
                    options.add(new SelectOption(p.Id,p.Name__c + '   (Php '+p.Retail_Price__c+')'));
                }
            }
            return options;
        }
    }
    
    public ProductSaleController(){
        
        title = view=='ps' ? 'Product Sale' : 'Clinic Use';        
        //getAllSales();   
        dayisConfirmed  = true;   
        Selecteddate = system.today();
        
    }
    
    public void getdailyRecords(){
        Integer d = Integer.valueOf(Apexpages.currentPage().getParameters().get('d'));
        Integer m = Integer.valueOf(Apexpages.currentPage().getParameters().get('m'));
        Integer y = Integer.valueOf(Apexpages.currentPage().getParameters().get('y'));
        
        Date dt = datetime.NewInstance(y,m,d,0,0,0).date();
        SelectedDate = dt;
        Sales = [Select Id, Final_Amount__c, Discount__c, Amount__c, Staff__r.Id, Staff__r.Name__c, 
                    Product__r.Id, Date__c,  Product__r.Commission__c , Confirmed_By__c,
                    Product__r.Name__c, Type__c from Product_Sale__c where Date__c=:dt];
        getRecords();
    }
    
    public void getMonthlyRecords(){
        
        Integer m = Integer.valueOf(Apexpages.currentPage().getParameters().get('m'));
        Integer y = Integer.valueOf(Apexpages.currentPage().getParameters().get('y'));
        //SelectedDate = null;
        Sales = [Select Id, Final_Amount__c, Discount__c, Amount__c, Staff__r.Id, Staff__r.Name__c, 
                    Product__r.Id, Date__c,  Product__r.Commission__c , Confirmed_By__c,
                    Product__r.Name__c, Type__c from Product_Sale__c where Calendar_Year(Date__c)=:y and  Calendar_month(Date__c)=:m];
        getRecords();
    }
    
    private void getRecords(){
        gross =0;
        discount=0;
        net =0;
        commission=0;        
        productSales = new List<Product_Sale__c>();
        clinicUse = new List<Product_Sale__c>();
        
                
        for(Product_Sale__c  s : sales){
            if(s.Type__c=='Sale'){
                gross+=s.Amount__c==null ? 0 :s.Amount__c;
                net+=s.final_amount__c==null ? 0 : s.final_amount__c;
                discount+=s.discount__c==null? 0 : s.discount__c;
                commission+= s.Product__r.Commission__c==null ? 0 : s.Product__r.Commission__c;
                
                ProductSales.add(s);
            }else if(s.Type__c=='Clinic Use'){
                ClinicUse.Add(s);
            }
            
        }
        
        if(view=='ps' && ProductSales.size()>0)
            dayisConfirmed = ProductSales[0].Confirmed_By__c == 'Not Confirmed' || ProductSales[0].Confirmed_By__c == null ? false : true;
        else if(view=='cu' && ClinicUse.size()>0)
            dayisConfirmed = ClinicUse[0].Confirmed_By__c == 'Not Confirmed' || ClinicUse[0].Confirmed_By__c == null ? false : true;
    }
    
    public void getAllSales(){
        Sales = [Select Id, Final_Amount__c, Discount__c, Amount__c, Staff__r.Id, Staff__r.Name__c, 
                    Product__r.Id, Date__c,  Product__r.Commission__c , Confirmed_By__c,
                    Product__r.Name__c, Type__c from Product_Sale__c order by Date__c desc];
        getRecords();
    }
    
    public void createNewSale(){
        sale= new Product_Sale__c();
        sale.discount__c= 0.0;
        sale.date__c = system.today();
    }
    
    public void deleteSale(){
        string id = Apexpages.currentPage().getParameters().get('saleid');
        if (id!=null){
            delete [Select Id from Product_Sale__c where Id =: id];
            getallSales();
        }
    }
    
    public void saveSale(){
        if(SelectedProductId!=null){
            sale.Product__c = SelectedProductId;
            sale.Staff__c = 'a0c90000008tJ0c';
            sale.Type__c= view=='ps' ? 'Sale' : 'Clinic Use';
            upsert sale;
            getAllSales();
        }
    }
    
    public void setSelectedSale(){
        string id = Apexpages.currentPage().getParameters().get('saleid');
        if (id!=null){
            List<Product_Sale__c> s= [Select Id, Final_Amount__c, Discount__c, Amount__c, Staff__r.Id, Staff__r.Name__c, 
                    Product__r.Id, Date__c, Confirmed_By__c,
                    Product__r.Name__c from Product_Sale__c where Id =: id];
            if (s.size()>0){
                sale= s[0];
            }
            
        }
    }
}