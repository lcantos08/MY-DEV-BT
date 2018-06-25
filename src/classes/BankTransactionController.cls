public class BankTransactionController{
    
    public List<Bank_Transaction__c> transactions { get; set; }
    String tranId =  null;
    public Bank_Transaction__c tran { get; set; }
    public string code { get; set; }
    public boolean valid { get; set; }
    public BankTransactionController(){
        getTransactions();
        valid=false;
    }
    
    public void getTransactions(){
        transactions = [Select Id, date__c, Amount__c, Type__c, Confirmed_By__c from Bank_Transaction__c order by Date__c desc];
    }
    
    public void save(){
        if(tran!=null)
            upsert tran;
        getTransactions();
    }
    
    public void confirm(){
        setSelectedTran();
        if(tran!=null){            
            String cby ='';
            code= Apexpages.currentPage().getParameters().get('code');
            if(code=='skyrah'){
                cby = 'Thess';
                valid=true;
            }else if(code=='lui'){
                cby='Lui';
                valid=true;
            }else if(code=='lui_anna17'){
                cby='Anna';
                valid=true;
            }            
            tran.confirmed_By__c=cby;
            update tran;           
            
        }
        getTransactions();
    }
    
    public void deleteTran(){
        tranId = Apexpages.currentPage().getParameters().get('tranId');
        if(tranId!=null){
            delete [Select Id, date__c, Amount__c, Type__c, Confirmed_By__c from Bank_Transaction__c where Id=:tranId];
            getTransactions();
        }
    }
    
    public void createNewTran(){
        tran = new Bank_Transaction__c();
        tranId=null;
    }
    public void setSelectedTran(){
        tranId = Apexpages.currentPage().getParameters().get('tranId');
        if(tranId!=null){
            List<Bank_Transaction__c > data = [Select Id, date__c, Amount__c, Type__c, Confirmed_By__c from Bank_Transaction__c where Id=:tranId];
            if(data.size()>0){
                tran = data[0];
            }
        }
    }
}