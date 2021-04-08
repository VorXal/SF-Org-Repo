import { LightningElement } from 'lwc';

export default class Controls extends LightningElement {

    editToDo(){
        this.dispatchEvent(new CustomEvent('edit'));
    }

    deleteToDo(){
        this.dispatchEvent(new CustomEvent('delete'));
    }
}