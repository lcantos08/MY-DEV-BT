public class ProductController{
    
    public List<Product__c> products { get; set; }
    public string code { get; set; }
    
    public ProductController(){
        
        code = 'lui_anna17';
        //getProductInventory();
    }
    public Integer remaining { get; set; }
    public Integer sold{ get; set; }
    public Integer clinic_use{ get; set; }
    public Integer all{ get; set; }
    public void getProductInventory(){
        remaining =0; sold=0; clinic_use=0; all=0;
        products = [Select Id, Retail_Price__c, Name, Name__c, Sold__c, Stocks__c, Inventory__c, Clinic_Use__c from Product__c order by Is_Set__c desc];
        for(Product__c p : products){
            all+= integer.valueOf(p.Stocks__c);
            sold+= integer.valueOf(p.sold__c);
            clinic_use+= integer.valueOf(p.clinic_use__c);
            remaining += integer.valueOf(p.stocks__c-p.sold__c - p.clinic_use__c); 
        }
        
    }
}