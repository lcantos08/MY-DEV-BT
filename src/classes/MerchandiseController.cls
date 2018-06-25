global class MerchandiseController
{
public static void UpdateDescription(Merchandise__c[] items)
{
 for (Merchandise__c item: items)
 {
  if (item.Description__c!= 'lui')
   item.Description__c ='lui';
   
   item.Total_Inventory__c = item.Price__c*2;
 }
 
}
webservice static string getUserContext()
{
 return UserInfo.getFirstName();
}

}