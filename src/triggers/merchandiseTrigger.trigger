trigger merchandiseTrigger on Merchandise__c (before insert, before delete, after update) {

if (Trigger.isBefore)
{
  if (Trigger.isDelete)
  {
    for(Merchandise__c a: Trigger.old)
    {
       if (a.Description__c!='oktodelete')
       a.addError('Cant delete this record');
    }
  }
  
  if (Trigger.isInsert)
  { 
    Merchandise__c[] items = Trigger.new;
    MerchandiseController.UpdateDescription(items);
  }
}
else if (Trigger.isafter)
{
  
  if (Trigger.isUpdate)
  {
    List<Merchandise__c> mers = new  List<Merchandise__c>();
    Integer i=0;
    Merchandise__c[] items = Trigger.new;
    
    for (Merchandise__c c : items)
    //for (Integer i=0; i<5; i++)
    {
      if (c.Total_Inventory__c<50)
      {
      i++;
      mers.add(new Merchandise__c(Name='mer_'+i, Total_Inventory__c=50, Description__c='desc', Price__c=100));
        //c.Description__c = ' less than 50';
      }
    }
    insert mers;
  } 
}
}