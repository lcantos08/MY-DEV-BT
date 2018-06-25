public class ExpenseController{
    
    public string selectedYear { get; set; }
    public string selectedMonth { get; set; }
    public date selecteddate { get; set; }
    public boolean dayIsConfirmed { get; set; }
    public Expense__c Expense { get; set; }
    public List<Expense__c> expenses { get; set; }
    public decimal total{
        get{
            decimal x =0;
            for(Expense__c e : expenses)
                x+=e.Amount__c;
            return x;
        }
    }
    
    public ExpenseController(){
       // getTodayExpenses();
        dayIsConfirmed = true;
    }
    
    public void createNewExpense(){
        expense = new Expense__c();
        expense.amount__c = 0.0;
    }
    
    public void deleteExpense(){
        string id = Apexpages.currentPage().getParameters().get('expenseid');
        if (id!=null){
            delete [Select Id from Expense__c where Id =: id];
            getTodayExpenses();
        }
    }
    
    public void setSelectedExpense(){
        string id = Apexpages.currentPage().getParameters().get('expenseid');
        if (id!=null){
            List<Expense__c> expenses = [Select Id, Type__c, SubType__c, description__c, amount__c, date__c, Confirmed_By__c  from Expense__c where Id =: id];
            if (expenses.size()>0){
                expense = expenses[0];
            }
            
        }
    }
    
    
    public void getExpenses(integer y, integer m, integer d){
        date mdate = dateTime.newInstance(y,m,d,0,0,0).date();
        if(d==-1){
            expenses = [Select Id, Type__c, SubType__c, description__c, amount__c, date__c, Confirmed_By__c  from Expense__c where Calendar_Year(date__c)=:y and calendar_Month(date__c)=:m order by date__c desc];
        }else{
            
            expenses = [Select Id, Type__c, SubType__c, description__c, amount__c, date__c, Confirmed_By__c  from Expense__c where date__c=:mdate];
        }
        
        if(expenses.size()>0){
            dayIsConfirmed  = expenses[0].Confirmed_By__c==null || expenses[0].Confirmed_By__c =='Not Confirmed' ? false : true;
        }
        selecteddate = d==-1 ? null : mdate;
    }
    
    public void getTodayExpenses(){
        selecteddate = System.today();
        expenses = [Select Id, Type__c, SubType__c, description__c, amount__c, date__c, Confirmed_By__c from Expense__c order by date__c desc];
    }
    
    public void saveExpense(){
        upsert expense;
        getTodayExpenses();
    }
    
     public void getExpensesByMonth(){
        Integer y = Integer.valueOf( Apexpages.currentPage().getParameters().get('y'));
        Integer m= Integer.valueOf( Apexpages.currentPage().getParameters().get('m'));
        
        Date today = System.Today();
        selectedYear = ''+y;
        selectedMonth = ''+m; 
        getExpenses(y,m,-1);
     }
     
     public void getExensesByday(){
        Integer y = Integer.valueOf( Apexpages.currentPage().getParameters().get('y'));
        Integer m= Integer.valueOf( Apexpages.currentPage().getParameters().get('m'));
        Integer d= Integer.valueOf( Apexpages.currentPage().getParameters().get('d'));
        Date today = System.Today();
        selectedYear = ''+y;
        selectedMonth = ''+m; 
        getExpenses(y,m,d);
        
     }

}