public class ModifyExamControl 
{

    public List <Examination__c> exam = new List<Examination__c>();
    public List <Question__c> questions = new List<Question__c>();
    public Integer ex {get; set;}
    public Integer quest {get; set;}
    public Integer curQuest {get; set;}
    public Boolean tr {get; set;}
    public List <String> q = new List<String>();
    public Integer mes {get; set;}

 
    public List<SelectOption> getopt()
    {
       exam =  [Select e.Achievement_Rate__c, e.Badge__c, e.Description2__c, e.Id, e.Name__c, e.Passing_Rate__c, e.Promotion_Text__c, e.Question_ID__c from Examination__c e];
       List<selectOption> opt = new list<selectOption>();
       for(integer x=0; x<exam.size(); x++)
       {

       opt.add(new SelectOption (x.format(), exam[x].name__c));
       }
       
          return opt;
    }
    
    public List<SelectOption> getquestpool()
    {
       questions =  [Select q.Question__c, q.ID, q.Name from Question__c q ORDER BY q.Name];
       List<selectOption> opt = new list<selectOption>();
       for(integer x=0; x<questions.size(); x++)
       {
           opt.add(new SelectOption(x.format(), questions[x].Name + '  :  ' + questions[x].question__c));
       }
       
          return opt;
    }
    
   
    
    public pagereference LoadQuestions()
    {
        System.debug('LOAD QUESTIONS');
        mes = 0;
        tr=true;
        q =new List<String>();
        if (exam[ex].Question_ID__c!=null)
            q = exam[ex].Question_ID__c.split(',',-1);
        return null;
    }
    
     public List<SelectOption> getcurrentQuest()
    {
       List<selectOption> opt = new list<selectOption>();
       
       
//       if (q!=null)
//       for(integer x=0; x<q.size(); x++)
//       {
//           opt.add(new SelectOption(x.format(),q[x]));
//       }

       if(q!= null)
       {
           for(integer x=0; x<q.size(); x++)
           {
               List <Question__c> tempList = new List<Question__c>();
               tempList = [Select q.Question__c, q.Name from Question__c q WHERE q.ID = :q[x]];
               System.debug('question ID: ' + q[x]);     
               System.debug('tempList : ' + tempList);                
               opt.add(new SelectOption(x.format(), tempList[0].Name + '  :  ' + tempList[0].Question__c));                         
           } 
           
                     
       }
       
       return opt;
    }
    
    public PageReference add()
    {
        mes = 0;
        for (integer x=0; x<q.size(); x++)
            if(q[x] == questions[quest].ID)
            {
                mes = 1;
                return null;
            }
        q.add(questions[quest].ID);
        return null;
    }
    
    public PageReference remove()
    {
        mes = 0;
        q.remove(curquest);
        return null;
    }
    
    public pagereference save ()
    {
        exam[ex].Question_ID__c = null;
        for(integer x=0; x<q.size(); x++)
        {
            if (x+1 == q.size())
                exam[ex].Question_ID__c+=q[x];
            else
                exam[ex].Question_ID__c+=q[x]+',';
        }
        if (exam[ex].Question_ID__c!=null)
            exam[ex].Question_ID__c=exam[ex].Question_ID__c.replace('null','');
        update exam[ex];
        mes = 2;
        return null;
    }

}