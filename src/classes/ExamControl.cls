//_beejay made this thing
// note to self: Clean this up!!!


public class ExamControl 
{
    static Final String DEFAULT_PAGE = '/apex/Home';
    static Final String RESULT_PAGE = '/apex/Result';

    public double perfectScore {get;set;}
    public Question q {get;set;}
    public Integer qRemain {get;set;}
    public String answer {get;set;}
    public string cAnswer {get;set;}
    public User_Examination__c UScore {get;set;}

    public Boolean challenge {get;set;}
    public String token {get;set;}
    public String examID {get;set;}
    private String query {get;set;}
    private User_Examination__c UExam = new User_Examination__c();
    private List<String> questionIDPool = new List<String>();
    private List<Question> questionPool = new List<Question>();
    private Set<String> qStore = new Set<String>();

    public pagereference goMain()
    {
        PageReference next = new PageReference(DEFAULT_PAGE);
        next.setRedirect(true);
        return next; 
    }
    
    public pagereference goResults()
    {
        PageReference next = new PageReference(RESULT_PAGE);
        next.getParameters().put('userExamId',examID);
        next.setRedirect(true);
        return next; 
    }

    public pagereference ExamStart ()
    {
        challenge = true;
        examID = ApexPages.currentPage().getParameters().get('userExamID');
        token = ApexPages.currentPage().getParameters().get('token');
        
        try
        {
            UExam = [Select u.Examination_ID__c,
                 u.Examination_ID__r.Question_ID__c,
                 u.Id, u.Status__c, 
                 u.Question_ID__c, 
                 u.User_ID__c,
                 u.score__c, 
                 u.Perfect_Score__c,
                 u.Date_Completed__c
                 from User_Examination__c u 
                 where u.Id = :examID and u.Token__c = :token  and u.status__c != 'Completed' limit 1];

            Uscore = new User_Examination__c();
            if (Uexam.Score__c==null)
                Uexam.Score__c = 0;
        }
        catch(exception e)
        {
           system.debug(e);
           return goMain();
        }
                
        if (UExam.Examination_ID__c != null )
        {
            if (UExam.Question_ID__c == null)
                UExam.Question_ID__c = UExam.Examination_ID__r.Question_ID__c;

            challenge = false;
            questionIDPool = new List<String>();
            if (Uexam.Question_ID__c!=null)
                questionIDPool = Uexam.Question_ID__c.split(',',-1);

            perfectScore = 0;
            set<Integer> randPool = new set<Integer>();
            integer y;
            query = '';
            for(integer x = 0 ; x <questionIDPool.size(); x++)
            {
                if (x!=0) query += ' or';
                query += ' q.id = \'';
                query += questionIDPool[x]+'\''; 
            }
            List<question__c> addPool = (Database.Query('Select q.Difficulty__c, q.Id, q.Question__c from Question__c q where ('+query+') and q.Active__c = true'));
            for(integer x=0;x<addpool.size();x++)
            {
                for(;;)
                {
                    y = randomNumber(addPool.size());
                    if(!qstore.contains(y.format()))
                    {
                        qstore.add(y.format());
                        questionPool.add( new Question(addpool[y]));
                        break;
                    }
                }
                if(Uexam.Status__c=='Ongoing'&&Uexam.Perfect_Score__c==null)
                    perfectScore+=questionPool[x].score;
            }
            system.debug(questionPool.size());
            if(Uexam.Status__c=='Ongoing'&&Uexam.Perfect_Score__c==null) 
                Uexam.Perfect_Score__c=perfectScore;
            questStart();
            return null;
        }
        else
        {
            questionIDPool = new List<String>();
            perfectScore = 0;
            set<Integer> randPool = new set<Integer>();
            integer y;
            List<question__c> addPool = (Database.Query('Select q.Difficulty__c, q.Id, q.Question__c from Question__c q where q.Active__c = true'));
            for(integer x=0;x<addpool.size();x++)
            {
                for(;;)
                {
                    y = randomNumber(addPool.size());
                    if(!qstore.contains(y.format()))
                    {
                        qstore.add(y.format());
                        questionPool.add( new Question(addpool[y]));
                        break;
                    }
                }
            }
            questStart();
            return null;
        }
        return null;
    }
    
    public Integer randomNumber(Integer up)
    {
        System.debug('METHOD START : Random Number');
        System.debug('Random Number up' + up);        
        Integer random = Math.Round(Math.Random() * up);
        if(random == up) random--;
        System.debug('Random Number random' + random);    
        System.debug('METHOD END: Random Number');
        return random;
    }

    public class Question
    {
        String question;
        public List<selectOption> choicesOpt = new List<selectOption>();
        List<Choice__c> choices = new List<Choice__c>();
        String diff;
        public String qid {get; set;}
        public Integer score {get; set;}
        String answer;
        
        
        
        public String getQuestion()
        {
            System.debug('METHOD START getQuestion');
            System.debug('getQuestion question' + question);  
            System.debug('METHOD END getQuestion');  
            return question;
        }
        
        public List<selectOption> getChoicesOpt ()
        {
            System.debug('METHOD START getChoices');
            System.debug('getChoices choices' + choicesOpt);
            System.debug('METHOD END getChoices');          
            return choicesOpt ;
        }
        
        public Question(Question__c QMain)
        {
            System.debug('METHOD START Question');
            choices = [Select c.Answer__c, c.Choice__c, c.Id, c.Question_ID__c from Choice__c c where c.Question_ID__c = :QMain.ID ];
            question = Qmain.question__c;
            diff = QMain.Difficulty__c;
            qid = QMain.id;
            
            System.debug('Question choices' + choices);
            System.debug('Question question' + question);
            System.debug('Question diff' + diff);
            System.debug('Question qid' + qid);
            
            set<integer> cRand = new set<integer>();
            integer xx;
            for(integer x=0; x<choices.size(); x++)
            {
            
                   for(;;)
                    {
                        xx = Math.Round(Math.Random() * choices.size());
                        if (xx==choices.size()) xx--;
                        if(!cRand.contains(xx))
                        {
                            choicesOpt.add(new selectOption(choices[xx].choice__c,choices[xx].choice__c));
                            if (choices[xx].answer__c==true) answer = choices[xx].choice__c;
                            cRand.add(xx);
                            break;
                        }
                    }
            }
            score = 10+ ((choices.size()-2)*2);
            if (diff=='Intermediate') score +=2;
            if (diff=='Advanced') score +=4;
            
            System.debug('Question score' + score);
            System.debug('METHOD END Question');
        }
    }
    
    public pagereference questStart()
    {
        System.debug('METHOD START questStart');
        system.debug(qstore);

            if(questionPool.isEmpty())
            {
                if (UExam.Id!=null)
                {
                Uexam.Status__c='Completed';
                Uexam.Date_Completed__c = date.today();
                update(UExam);
                return goResults();
                }
                else
                {
                    return null;
                }  
            }
            
            System.debug('questStart questionPool' + questionPool);
            
            q=null;
            q = questionPool.get(0);
            qRemain=questionPool.size()-1;
            
            System.debug('questStart qRemain' + qRemain);
            
            questionPool.remove(0);
            try
            {
                Uexam.Question_ID__c=Uexam.Question_ID__c.replace(q.qid+',','');
            }catch(exception x){}
            try
            {
                 Uexam.Question_ID__c=Uexam.Question_ID__c.replace(q.qid,'');
            }catch(exception x){}
            cAnswer=q.answer;
            
            System.debug('questStart cAnswer' + cAnswer);
            
            update(UExam);
            
            System.debug('METHOD END questStart');
            
            return null;
   }
   
   public pagereference score()
   {
       System.debug('METHOD START score');
       try
       {
        if (UExam!=null)
        {
        if(cAnswer == answer)
            if (UExam.Score__c!=null)
            {
            if(challenge) UExam.Score__c+=1;
            else UExam.Score__c+=Uscore.Score__c;
            }
            else 
                return questStart();
        else if(canswer != answer && challenge)
        {
             UExam.Status__c='Completed';
             UExam.Date_Completed__c = date.today();
             update(UExam);
             return goResults();  
        } 
        answer='';
        
         System.debug('METHOD END score');
        return questStart();
        }
        else
            return questStart();
       }
       catch(DMLException ex)
       {
            return null;
       }
       
       
   }
    public static testMethod void examControllerTest() {
        
        ApexPages.currentPage().getParameters().put('userExamID','UE-00019');
        ApexPages.currentPage().getParameters().put('token','O6YzbkUfmDls7K_2BGDVE0Uw_3D_3D'); 
      
        Examination__c e = new Examination__c();
        e.Name__c= 'Sample Exam';
        e.Passing_Rate__c = 50;
        insert e;
        UserProfile__c p = new UserProfile__c();
        p.FirstName__c = 'Lui';
        p.LastName__c = 'Sample';
        p.Email__c= 'abc@yahoo.com';
        p.Location__c = 'Philippines';
        insert p; 
        
        User_Examination__c ex = new User_Examination__c();
        ex.Score__c=100;
        ex.User_ID__c =p.Id;
        ex.Perfect_Score__c= 100;
        ex.Examination_ID__c = e.ID;
        
        insert ex;
        
        Question__c c = new Question__c();
        c.Question__c = 'Sample';
        c.Difficulty__c='Difficult';
        c.Num_Asked__c=6;
        c.Num_Correct__c=5;   
        insert c;
         
        ExamControl controller = new ExamControl();
        
        controller.UExam = ex;
        controller.q = new Question(c);
        controller.q.getQuestion();
        controller.goMain();
        controller.goResults();   
        controller.ExamStart();
        controller.randomNumber(10);  
        controller.questStart();    
        controller.score();
 
        
    }
}