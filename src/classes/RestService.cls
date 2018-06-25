@RestResource(urlmapping='/showpositions/*')
global class RestService{

    @HttpGet
    global static List<Position__c> getPositions(){
        RestRequest req = RestContext.Request;
        String name = req.params.get('name');
        return [Select Name, Status__c from Position__c];
    }

}