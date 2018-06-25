/* Unit test for ExamControl
    _beejay*/
@isTest
private class TestExamControl
{   
        static testMethod void myUnitTest() {      
        test.startTest();       
        ExamControl controller = new ExamControl();
        controller.goMain();
        controller.goResults();   
        controller.ExamStart();
        controller.randomNumber(10);        
        controller.questStart();    
        test.stopTest();
    }
}