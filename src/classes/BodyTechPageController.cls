public class BodyTechPageController{
    
    public string p { get; set; }
    public BodyTechPageController(){
        p = 'ds';
    }
    
    public void setView(){
        System.debug('PPPPPP:' +p);
    }

}