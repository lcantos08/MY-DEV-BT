public class DayPagerController{
    
    public Integer selectedday { get; set; }
    public String objectType { get; set; }
    public String selectedmonth { 
        get{
            return selectedmonth ;
        }set {
            selectedmonth  = value;
            getDays();
        }
    }
    public String selectedYear { 
        get{
            return selectedYear ;
        }set {
            selectedYear = value;
            getDays();
        }
    }
    
    public List<SelectOption> getMonthOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0', '--Select--'));
        options.add(new SelectOption('1', 'Jan'));
        options.add(new SelectOption('2', 'Feb'));
        options.add(new SelectOption('3', 'Mar'));
        options.add(new SelectOption('4', 'Apr'));
        options.add(new SelectOption('5', 'May'));
        options.add(new SelectOption('6', 'Jun'));
        options.add(new SelectOption('7', 'Jul'));
        options.add(new SelectOption('8', 'Aug'));
        options.add(new SelectOption('9', 'Sep'));
        options.add(new SelectOption('10', 'Oct'));
        options.add(new SelectOption('11', 'Nov'));
        options.add(new SelectOption('12', 'Dec'));
        return options;
    }
    
    public List<SelectOption> getYearOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('2016', '--Select--'));
        options.add(new SelectOption('2016', '2016'));
        options.add(new SelectOption('2015', '2015'));
        return options;
    }
    
    public string l { get; set; }
    public void setMonth(){
        //selectedmonth   = l;
        getDays();
    }
    
    public DayPagerController(){
       
    }
    public List<Integer> getDays(){
        
        List<Integer> d = new List<Integer>();
        if (selectedMonth != null){
        for (Integer i = 1 ; i< BodyTechUtil.getMonthDays(Integer.valueOf(selectedmonth))+1; i++){
            d.add(i);
        }}
        return d;
    }
}