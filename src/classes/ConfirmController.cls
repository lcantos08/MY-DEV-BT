public class ConfirmController{
    
    public string type { get; set; }
    public string objectType { get; set; }
    public Date dateStr { get; set; }
    public string confirmed_by{ get; set; }
    public string recordId  { get; set; }
    
    public void confirm(){
        if(type!=null){
            if (type=='day'){                
                if(objectType=='client_service'){
                    List<Client_Service__c> services = [Select Id, Confirmed_By__c from Client_Service__c where date_Time__c =: dateStr ];
                    for(Client_Service__c cs : services){
                        cs.Confirmed_By__c = confirmed_by;
                    }
                    update services;
                }
                else if(objectType=='expense'){
                    List<Expense__c> expenses= [Select Id, Confirmed_By__c from Expense__c where date__c =: dateStr ];
                    for(Expense__c e : expenses){
                        e.Confirmed_By__c = confirmed_by;
                    }
                    update expenses;
                }
                else if(objectType=='product_sale'){
                    List<Product_sale__c> sales= [Select Id, Confirmed_By__c from Product_sale__c where date__c =: dateStr and Type__c='Sale' ];
                    for(Product_sale__c e : sales){
                        e.Confirmed_By__c = confirmed_by;
                    }
                    update sales;
                }
                else if(objectType=='clinic_use'){
                    List<Product_sale__c> sales= [Select Id, Confirmed_By__c from Product_sale__c where date__c =: dateStr and Type__c='Clinic Use' ];
                    for(Product_sale__c e : sales){
                        e.Confirmed_By__c = confirmed_by;
                    }
                    update sales;
                }
                else if(objectType=='attendance'){
                    List<Attendance__c > data= [Select Id, Confirmed_By__c from Attendance__c where date__c =: dateStr];
                    for(Attendance__c e : data){
                        e.Confirmed_By__c = confirmed_by;
                    }
                    update data;
                }
            }else if(type=='record'){
                if(objectType=='cutoff'){
                    List<CutOff__c> cs = [Select Id, Confirmed_By__c from CutOff__c where Id =: recordId  ];
                    if(cs.size()>0){
                        cs[0].Confirmed_By__c = confirmed_by;
                        update cs[0];
                    }
                }
            }
        }
    }
}