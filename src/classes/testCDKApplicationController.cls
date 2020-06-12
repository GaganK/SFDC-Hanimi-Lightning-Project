@IsTest(SeeAllData=true)
public class testCDKApplicationController
{
  @isTest
  public static void testCDLApplicationController()
  {
    test.startTest();
    PageReference pageRef = Page.cdlApplication;
    Test.setCurrentPage(pageRef);
    cdlApplicationController cdlApplicationController = new cdlApplicationController();
    pageRef.getParameters().put('applicationId', '');
    cdlApplicationController.init();
    cdlApplicationController.saveApplication();
    test.stopTest();
  }
}