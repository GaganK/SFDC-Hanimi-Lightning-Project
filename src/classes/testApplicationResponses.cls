@IsTest(SeeAllData=true)
public class testApplicationResponses
{
  @IsTest
  public static void testApplicationResponses()
  {
    Test.startTest();
    Account account = new Account();
    account.Name = 'TestAccount'; insert account;
    Contact contact = new Contact();
    contact.AccountId = account.Id;
    contact.FirstName = 'Test';
    contact.LastName = 'Tester';
    contact.Email = 'test@test.com';
    contact.Gender__c = 'Male';
    contact.Online_Submission__c = true; insert contact;
    Application__c app = new Application__c();
    app.Application_Stage__c = 'Applied';
    app.Venture__c = account.Id; insert app;
    app.Tech_Specialization__c = 'Prime;Health'; update app;
    Test.stopTest();
  }
}