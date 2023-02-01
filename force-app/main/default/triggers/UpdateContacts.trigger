/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-01-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger UpdateContacts on Account (after update) {
    // Create a list to store the contacts that will be updated
    List<Contact> contactsToUpdate = new List<Contact>();
     // Iterate through the list of accounts that were updated
    for (Account account : Trigger.new) {
     // Check if the "PushToVendor__c" field was changed
        if (account.PushToVendor__c != Trigger.oldMap.get(account.Id).PushToVendor__c) {
     // Query for all related contacts for the account
            List<Contact> contacts = [SELECT Id,Push_Date__c FROM Contact WHERE AccountId = :account.Id];
     // Check the total number of contacts returned by the query
            if (contacts.size() > 200) {
     // If the total contact count is greater than 200 and less than or equal to 1000, use a one-time process to update the records
                if (contacts.size() <= 1000) {
                    for (Contact contact : contacts) {
                        if (account.PushToVendor__c == 'Yes') {
                            contact.Push_Date__c = System.today();
                        } else if (account.PushToVendor__c == 'No') {
                            contact.Push_Date__c = null;
                        }
                        contactsToUpdate.add(contact);
                    }
                    System.enqueueJob(new UpdateContactsQueueable(contactsToUpdate));
                }
     // If the total contact count is greater than 1000, use a for loop to iterate through the contacts in smaller chunks (ideally 150 records per chunk) and update the records.
                else {
                    Database.executeBatch(new UpdateContactsBatch(contactsToUpdate,account),150);
                }
            }
     // If the total contact count is less than or equal to 200, update the contacts synchronously.
            else {
                for (Contact contact : contacts) {
                    if (account.PushToVendor__c == 'Yes') {
                        contact.Push_Date__c = System.today();
                    } else if (account.PushToVendor__c == 'No') {
                        contact.Push_Date__c = null;
                    }
                    contactsToUpdate.add(contact);
                }
                update contactsToUpdate;
            }
        }
    }
}
