/*
    Made by Joey & Wowie
*/
public class LeaderboardController {

    private String testType;
    private String dateRange;
    
    private static final String EXAMINATION = 'Examination';
    private static final String CHALLENGE   = 'Challenge';

    private static final String WEEKLY = 'This Week';    
    private static final String OVERALL= 'All Time';    
    
    public ID examinationId{get; set;}    
    public String selectedExaminationId {get; set;}
    public String selectedExaminationType {get; set;}  
    public String selectedDateRange {get; set;}  
    public Boolean isChallenge{get; set;}

    /*
    Type: Examination or Challenge
    Date: This week, This month, All time
    Examination type: Dropdown list of all of the Examinations based on the Examination ID
    */
    
    public LeaderboardController()
    {   
        isChallenge   = false; 
        examinationId = [SELECT ID FROM Examination__c Limit 1].Id;
        testType      = EXAMINATION;
        dateRange     = WEEKLY;                        
    }
    /** Returns the list of examinations for the drop-down list*/
    public List<SelectOption> getExaminations()
    {
        
        List<Examination__c> examinations = [SELECT ID, Name__c FROM Examination__c];
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        for(Integer i = 0 ; i < examinations.size(); i++)
        {
            options.add(new SelectOption(examinations[i].ID,examinations[i].Name__c));         
        }        
        return options;         
    }
    /** Returns the types of examinations for the drop-down list*/
    public List<SelectOption> getExaminationTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(EXAMINATION ,EXAMINATION ));
        options.add(new SelectOption(CHALLENGE,CHALLENGE));
        return options;
    }
    /** Returns the date ranges for the drop-down list*/    
    public List<SelectOption> getDateRanges() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption( WEEKLY ,WEEKLY ));
        options.add(new SelectOption( OVERALL,OVERALL));
        return options;
    }
    /** Action function in selecting date range*/    
    public PageReference selectDateRangeFunction() 
    {
        if (selectedDateRange == WEEKLY)        
            dateRange = WEEKLY;        
        else        
            dateRange = OVERALL;
                
        return null;
    } 
    /** Action function in selecting examination type */        
    public PageReference selectExaminationTypeFunction() 
    {
        if (selectedExaminationType == EXAMINATION)
        {
            testType = EXAMINATION;
            examinationId = [SELECT ID FROM Examination__c Limit 1].Id;        
            selectedExaminationId = examinationId;
            isChallenge = false;
            return new PageReference('/apex/Leaderboard?testType=' + EXAMINATION);             
        }
        else
        {
            testType = CHALLENGE;
            isChallenge = true;
            examinationId = null;
            return new PageReference('/apex/Leaderboard?testType=' + CHALLENGE);             
        }        
    }
    /** Action function in selecting examination ID*/            
    public PageReference selectExaminationIdFunction() 
    {
        examinationId = selectedExaminationId;
        return null;
    }

    /* Gets the data from the Leaderboard*/
    public List<Leader_Board__c> getLeaderboard()
    {
        System.debug('Rerendering the leaderboard');
        System.debug('Selected examinationId: ' + examinationId);
        System.debug('Selected selectedExaminationId: ' + selectedExaminationId);
        System.debug('Selected type: ' + testType);
        System.debug('Selected dateRange: ' + dateRange);
        
        List<Leader_Board__c> exam = new List<Leader_Board__c>();
        
        // Weekly
        Date weekEnd = Date.today();
        Date weekStart = weekEnd.addDays(-7);
        
        Id oldUserId = null;
        Decimal avgScore = 0; // Average score              
        Decimal totScore = 0; // Total Score
        Integer trial = 0; // Tries
        Decimal bestScore = 0; // Best Score
        Decimal[] ranking = new List<Decimal>();
        String name = '';
        
        Map<Id, Leader_Board__c> userExamMapping = new Map<Id, Leader_Board__c>();
        List<User_Examination__c> userExamList = new List<User_Examination__c>();
        
        
        if (dateRange == WEEKLY){
            userExamList = [select User_ID__c, User_ID__r.LastName__c, User_ID__r.FirstName__c, Score__c from User_Examination__c where Status__c = 'Completed' and Examination_ID__c = :examinationId and Date_Completed__c >= :weekStart and Date_Completed__c <= :weekEnd order by User_ID__c];
        } else {
            userExamList = [select User_ID__c, User_ID__r.LastName__c, User_ID__r.FirstName__c, Score__c from User_Examination__c where Status__c = 'Completed' and Examination_ID__c = :examinationId order by User_ID__c];
        }
        
        System.debug('Examination Id : ' + examinationId);
        for (User_Examination__c userExam :userExamList)
        {
            if (userExam.User_ID__c != oldUserId && oldUserId != null)
            {                  
                System.debug('Total Score : ' + totScore);  
                System.debug('Trial : ' + trial);
                // Save average
                avgScore = totScore/trial;
                avgScore.setScale(1, System.RoundingMode.HALF_UP); // round off to 1 decimal place
                ranking.add(testType != CHALLENGE ? avgScore : bestScore);
                
                System.debug('Test Type : ' + testType);
                System.debug('Average Score : ' + avgScore);
                System.debug('Best Score : ' + bestScore);
                
                // Map here
                userExamMapping.put(oldUserId, new Leader_Board__c(Rank__c=1,
                                                                   User_Profile_ID__c=oldUserId,
                                                                   User_Name__c=name,
                                                                   Trial__c=trial,
                                                                   Best_Score__c=bestScore,
                                                                   Average__c=avgScore));    
                
                // Reset here
                name = '';
                avgScore = 0;
                totScore = 0;
                trial = 0;
                bestScore = 0;                    
            }
            
            if (userExam.User_ID__c != oldUserId)
            {
                oldUserId = userExam.User_ID__c;
            }
            
            name = userExam.User_ID__r.LastName__c + ', ' + userExam.User_ID__r.FirstName__c;
            totScore += userExam.Score__c;
            trial++;
            if (userExam.Score__c > bestScore){
                bestScore = userExam.Score__c;
            }
            
        }
        
        // Save last row here
        if (userExamList.size() > 0)
        {
            // Save average
            avgScore = totScore/trial;
            avgScore.setScale(1, System.RoundingMode.HALF_UP); // round off to 1 decimal place
            ranking.add(testType != CHALLENGE ? avgScore : bestScore);
            // Map here
            userExamMapping.put(oldUserId, new Leader_Board__c(Rank__c=1,
                                                               User_Profile_ID__c=oldUserId,
                                                               User_Name__c=name,
                                                               Trial__c=trial,
                                                               Best_Score__c=bestScore,
                                                               Average__c=avgScore));
        }
        
        // sort ranking in ascending                      
        ranking.sort();         
        for (Integer i=0; i<ranking.size(); i++)
        {
            System.debug('Rank ' + i + ' ' + ranking[i]);
        }
        
        // Calculate ranking here                   
        Decimal rank = 0;   
        Integer ctr = 0;    
        Decimal samectr = 0;  
        Decimal forRanking = 0;        
        for (Id userid :userExamMapping.keySet())
        {      
            samectr = 0;    
            rank = 0;  
            ctr = 1;    
            Leader_Board__c leader = userExamMapping.get(userid);
            forRanking = testType != CHALLENGE ? leader.Average__c : leader.Best_Score__c;
            System.debug('User : ' + leader.User_Name__c);
            System.debug('Score : ' + forRanking);
            for (Integer i=ranking.size()-1; i>=0; i--)
            {                  
                System.debug('Ranks : ' + ranking[i]);                           
                if (ranking[i] == forRanking)
                {    
                    samectr++;
                    rank += ctr; 
                    System.debug('Rank ' + ctr + ' = ' + rank);
                    if ((i > 0 && ranking[i] != ranking[i-1]) || i == 0)
                    {
                        System.debug('Orig rank : ' + rank);
                        System.debug('Counter : ' + ctr);                        
                        rank = rank > ctr ? (rank*1.0)/samectr : rank;
                        System.debug('Ranking : ' + rank);
                        break;
                    }    
                }
                ctr++;
            }
            leader.Rank__c = rank;
            exam.add(leader);
        }
        // Sort here
        exam = sortStandard(exam);
        System.debug('Total Count : ' + exam.size());       
        return exam;
    }
    
     private static List<Leader_Board__c> sortStandard(List<Leader_Board__c> leaderboard) 
     {        
         List<Leader_Board__c> resultList = new List<Leader_Board__c>();            
         /* Create a map of rank to Leader_Board__c collection */        
         Map<Decimal, List<Leader_Board__c>> leadMap = new Map<Decimal, List<Leader_Board__c>>();                
         for(Leader_Board__c l:leaderboard) 
         {            
             if(leadMap.get(l.Rank__c) == null) 
             { 
                 leadMap.put(l.Rank__c, new List<Leader_Board__c>()); 
             }            
             leadMap.get(l.Rank__c).add(l);        
         }                
         List<Decimal> keys = new List<Decimal>(leadMap.keySet());                
         
         /* Leverage the standard, primitive collection sort method */        
         keys.sort();                
         
         for(Decimal key:keys) 
         { 
             resultList.addAll(leadMap.get(key)); 
         }                
         
         return resultList;    
      }
      static testMethod void leaderboardControllerTest() {
        PageReference leaderboardPage = Page.Leaderboard;
        Test.setCurrentPage(leaderboardPage);       
        
        /* Load the default page*/
        LeaderboardController leaderboardController = new LeaderboardController();
        leaderboardController.getExaminations();
        leaderboardController.getExaminationTypes();
        leaderboardController.getDateRanges();
        leaderboardController.getLeaderboard();
        
        leaderboardController.selectExaminationIdFunction();
        
        /* Select the Overall date range*/
        leaderboardController.selectedDateRange = OVERALL;
        leaderboardController.selectDateRangeFunction();
        leaderboardController.getLeaderboard();

        /* Select the Weekly date range*/
        leaderboardController.selectedDateRange = WEEKLY;
        leaderboardController.selectDateRangeFunction();
        leaderboardController.getLeaderboard();
                
        /* Select the Challenge Exams*/
        leaderboardController.selectedExaminationType = CHALLENGE;
        leaderboardController.selectExaminationTypeFunction();
        leaderboardController.getLeaderboard();
        
        /* Select the Examination Exams*/
        leaderboardController.selectedExaminationType = EXAMINATION;
        leaderboardController.selectExaminationTypeFunction();
        leaderboardController.getLeaderboard();
      }
}