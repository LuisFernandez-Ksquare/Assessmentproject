/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-28-2023
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
            List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :account.Id];
            
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
                    update contactsToUpdate;
                }
                // If the total contact count is greater than 1000, use a for loop to iterate through the contacts in smaller chunks (ideally 150 records per chunk) and update the records.
                else {
                    Integer numOfIterations = (contacts.size() / 150) + 1;
                    for (Integer i = 0; i < numOfIterations; i++) {
                        Integer start = i * 150;
                        Integer endIndex = (i + 1) * 150;
                        if (endIndex > contacts.size()) {
                            endIndex = contacts.size();
                        }
                        List<Contact> contactsToUpdate = new List<Contact>();
                        for (Integer j = start; j < endIndex; j++) {
                            Contact contact = contacts.get(j);
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
