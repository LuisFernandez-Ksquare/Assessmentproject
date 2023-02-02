/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-01-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> searchContacts(String searchKey, Integer pageSize, Integer pageNumber) {
        return [SELECT Id, Name, Email, Phone FROM Contact 
                WHERE Name LIKE :searchKey + '%' 
                LIMIT :pageSize 
                OFFSET :pageSize * (pageNumber - 1)];
    }

    @AuraEnabled
    public static Contact createContact(Contact newContact) {
        insert newContact;
        return newContact;
    }
}



  