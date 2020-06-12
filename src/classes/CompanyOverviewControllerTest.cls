/**
 * Test class for CompanyOverviewController
 *
 * @author Sachin Rathore
 * @since 29/03/2020
 *
 */
@isTest
private class CompanyOverviewControllerTest{
    
    private static Admitted_Venture__c admittedVenture;
    
    static {
        loadData();
    }
    
    
    /**
     * Setup test data for verifying the functionalty of the controller
     * 
     * @author Sachin Rathore
     * @since 29/03/2020
     * 
     */
    @testSetup
    private static void setupTestData() 
    {
        Id ventorAccountId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Venture').getRecordTypeId();
        Account venture = new Account(Name = 'Test', RecordTypeId = ventorAccountId, BillingCountry = 'Canada', BillingState = 'Alberta',
        Industry_Multi__c = 'Advertising;Artificial Intelligence',Core_Technology__c = 'Blockchiain;Power',Website='www.test.com');
        insert venture;
        
        CDL_Site__c site = new CDL_Site__c(Name = 'CDL-Test', Country__c = 'Canada');
        insert site;
        
        Stream__c stream = new Stream__c(Name = 'Blockchain' );
        insert stream;
        
        Cohort__c cohort = new Cohort__c(CDL_Site__c= site.Id,Stream__c = stream.Id,Status__c='Active',Cohort_Year__c='2019-2020',Cohort_Num__c=1);
        insert cohort;
        
        Admitted_Venture__c admittedVenture = new Admitted_Venture__c(Cohort__c = cohort.Id,Venture__c=venture.Id);
        insert admittedVenture;
        
    }
    
    /**
     * Company information should be present
     * 
     * @author Sachin Rathore
     * @since 29/03/2020
     * 
     */
    @isTest private static void testGetCompanyDetails() {
        Test.startTest();
        List<CompanyOverviewController.CompanyWrapper> wrapperList = new List<CompanyOverviewController.CompanyWrapper>();
        wrapperList = CompanyOverviewController.getCompanyDetails(admittedVenture.Id);
        Test.stopTest();
        
        System.assertEquals(1,wrapperList.size(),'Company information not found');
    }
    
	/**
     * Company information not present
     * 
     * @author Sachin Rathore
     * @since 29/03/2020
     * 
     */
    @isTest private static void testCompanyDetailsNotPresent() {
		Test.startTest();
        List<CompanyOverviewController.CompanyWrapper> wrapperList = new List<CompanyOverviewController.CompanyWrapper>();
        wrapperList = CompanyOverviewController.getCompanyDetails(null);
        Test.stopTest();
        
        System.assertEquals(False,wrapperList[0].isSuccess,'Company information not present');
    }
	
    /**
     * Query data created in testSetup. This will be called before each test method execution
     * 
     * @author Sachin Rathore
     * @since 29/03/2020
     * 
     */
    private static void loadData() 
    {
        List<Admitted_Venture__c> admVenList = [Select Id from Admitted_Venture__c ];
        admittedVenture = !admVenList.isEmpty() ? admVenList[0] : null;
    }
    
}