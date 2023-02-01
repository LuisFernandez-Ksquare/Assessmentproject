/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-01-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class UpdateContactsBatch implements Database.Batchable<sObject> {
    global List<Contact> contactsToUpdate;
    global Account account;
    @TestVisible global UpdateContactsBatch(List<Contact> contacts, Account account){
        this.contactsToUpdate = contacts;
        this.account = account;

    }

    // The query that returns the records to be processed
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Set<Id> ids =new Set<Id>(new Map<Id,Contact>(contactsToUpdate).keySet());
        return Database.getQueryLocator([
            SELECT Id, Push_Date__c, Account.PushToVendor__c
            FROM Contact
            WHERE Id =: ids
            LIMIT 150
        ]);
    }

    // Method to process each batch of records
    @TestVisible global void execute(Database.BatchableContext BC, List<Contact> contacts) {
        List<Contact> ContactsToSave = new List<Contact>();
        for (Contact contact : contacts) {
            if (contact.Account.PushToVendor__c == 'Yes') {
                contact.Push_Date__c = System.today();
            } else if (contact.Account.PushToVendor__c == 'No') {
                contact.Push_Date__c = null;
            }
            ContactsToSave.add(contact);
        }
        update ContactsToSave;
    }

    // Method to run after all batches have been processed
    global void finish(Database.BatchableContext BC) {
        
    }
}
