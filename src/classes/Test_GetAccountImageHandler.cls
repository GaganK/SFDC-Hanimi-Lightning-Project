@isTest
Private class Test_GetAccountImageHandler {
    static testMethod void acctLogocheck(){
        Id p = [select id from profile where name='Partner Community User'].id;
           
            Account ac = new Account(name ='TestGrazitti') ;
            insert ac; 
           
            Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
            insert con;  
                      
            User user = new User(alias = 'test153', email='test123555@noemail.com',
                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                    localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                    ContactId = con.Id,
                    timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
           
            insert user;
            system.runAs(user) {
                GetAccountImageHandler.accountImageURL();
            }

    }  
}