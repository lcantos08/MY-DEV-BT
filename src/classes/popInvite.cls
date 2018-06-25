public class popInvite {
 
    public boolean displayInvite {get; set;}
 
    public void send() {
        
        displayInvite = false;
    }
 
    public void invite() {
        displayInvite = true;
    }
    
    public void cancel(){ 
        displayInvite = false;
    }   
}