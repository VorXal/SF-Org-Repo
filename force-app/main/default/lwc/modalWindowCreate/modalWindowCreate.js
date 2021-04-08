import { LightningElement, api } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import TODO_OBJECT from '@salesforce/schema/ToDoItem__c';
import NAME_FIELD from '@salesforce/schema/ToDoItem__c.Name';
import DESCRIPTION_FIELD from '@salesforce/schema/ToDoItem__c.Description__c';
import CATEGORY_FIELD from '@salesforce/schema/ToDoItem__c.Category__c';
import PRIORITY_FIELD from '@salesforce/schema/ToDoItem__c.Priority__c';
import STATUS_FIELD from '@salesforce/schema/ToDoItem__c.Status__c';


export default class ModalWindowCreate extends LightningElement {

    fields = [NAME_FIELD, DESCRIPTION_FIELD, CATEGORY_FIELD, PRIORITY_FIELD, STATUS_FIELD];

    closeModal(){
        this.dispatchEvent(new CustomEvent('close'));
    }

    handleSubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        this.template.querySelector('lightning-record-form').submit(fields);
     }
}