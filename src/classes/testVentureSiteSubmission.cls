@IsTest(SeeAllData=true)
private class testVentureSiteSubmission
{
  @IsTest
  private static void testVentureSiteSubmission()
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
    Venture_Site_Submission__c vss = new Venture_Site_Submission__c();
    vss.Application__c = app.Id;
    vss.Site_Rankings__c = 'CDL - Toronto';
    insert vss;
    Test.stopTest();
  }
}