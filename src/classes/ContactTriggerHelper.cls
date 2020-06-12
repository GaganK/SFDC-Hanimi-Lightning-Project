/*
 * Name: ContactTriggerHelper
 * Description: 
 * Last Modified By: Megha Raheja
 * Last Modified Date: 2019-03-22
 */
public class ContactTriggerHelper {
    
    // Initialize variables
    static Map<Id, Contact> newContactMap;
    static Map<Id, Contact> oldContactMap;
    
    /* Name: ContactTriggerHelper
     * Description: Constructor of the class
     * Parameters: Trigger.newMap, Trigger.oldMap
     * Return: NA
    */
    public ContactTriggerHelper(Map<Id, Contact> newMap, Map<Id, Contact> oldMap){
        // Intialize the map variables
        newContactMap = new Map<Id, Contact>();
        oldContactMap = new Map<Id, Contact>();
        
        // Assign values from trigger
        newContactMap = newMap;
        oldContactMap = oldMap;
    }
    
    /* Name: findMatchingLeadEmailAddress
     * Description: This method filter contacts where Email is NOT blank and send list to the Batch class
     * Parameters: Contact Map
     * Return: void
    */
    public void findMatchingLeadEmailAddress(Map<Id, Contact> contactMap){
        List<Contact> contactList = new List<Contact>();
        for(Contact con: contactMap.values()){
            if(con.Email != null){
                contactList.add(con);
            }
        }
       
        Database.executeBatch(new FindContactMatchOnLead(contactList), 100);
    }
}