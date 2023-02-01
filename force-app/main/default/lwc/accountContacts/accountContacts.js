import { LightningElement, track } from 'lwc';
import searchContacts from '@salesforce/apex/ContactController.searchContacts';
import createContact from '@salesforce/apex/ContactController.createContact';

const PAGE_SIZE = 5;

export default class ContactSearchComponent extends LightningElement {
  @track searchKey = '';
  @track contacts = [];
  columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Email', fieldName: 'Email', type: 'email' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' }
  ];
  @track page = {
    number: 1,
    size: PAGE_SIZE,
    totalPages: 0,
  };
  @track createNewContact = false;

  handleSearchKeyChange(event) {
    this.searchKey = event.target.value;
  }

  async searchContacts() {
    try {
      const result = await searchContacts({
        searchKey: this.searchKey,
        pageNumber: this.page.number,
        pageSize: this.page.size
      });
      this.contacts = result.contacts;
      this.page.totalPages = Math.ceil(result.totalNumberOfContacts / this.page.size);
    } catch (error) {
      console.error(error);
    }
  }

  handleSuccess(event) {
    this.contacts.push(event.detail.fields);
    this.createNewContact = false;
  }

  createContact() {
    this.createNewContact = true;
  }

  handleCancel(event) {
    this.createNewContact = false;
  }

  previousPage() {
    if (this.page.number > 1) {
      this.page.number--;
      this.searchContacts();
    }
  }

  nextPage() {
    if (this.page.number < this.page.totalPages) {
      this.page.number++;
      this.searchContacts();
    }
  }
}


