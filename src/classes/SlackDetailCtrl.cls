public  without sharing class SlackDetailCtrl {
  @AuraEnabled 
    public static String fetchSlackUrlDetail(){
       User userObj = new User();
        userObj = [SELECT Slack_Url__c, Id FROM User WHERE Id = : UserInfo.getUserId()];
        return userObj.Slack_Url__c;
    }
}