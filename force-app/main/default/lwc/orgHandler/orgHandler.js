import { LightningElement, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getTriggerList from '@salesforce/apex/orgHandler.getTriggerList';
import updateTrigger from '@salesforce/apex/orgHandler.updateTrigger';

import noHeader from '@salesforce/resourceUrl/NoHeader';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class OrgHandler extends LightningElement {

    connectedCallback() {
        loadStyle(this, noHeader)
            .then(result => {});
    }

    @track
    triggers;

    wiredApexResult;

    @track
    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Object', fieldName: 'Object__c' },
        {label: 'Status', fieldName: 'Status__c'},
        {
            type:'button',
            fixedWidth: 150,
            typeAttributes: {
                label: 'Edit',
                name: 'edit',
                variant: 'brand'
            }
        }
    ];

    @wire(getTriggerList)
    getTriggersList(result) {
        this.wiredApexResult = result;
        if (result.data) {
            console.log(result.data);
            this.triggers = result.data;            
        }
        else if (result.error) {
            console.log(result.error);
        }
    }

    updateTrigger(event) {
        let tgName = event.detail.row.Name;
        let tgObject = event.detail.row.Object__c;
        this.objectName = event.detail.row.Object__c;
        console.log(tgName + ' ' + tgObject);
        updateTrigger({objectName: tgObject})
        .then(() => {
            console.log("updated successfully");
            return refreshApex(this.wiredApexResult);
        })
        .catch(() => {
            console.log("error");
        });
    }   
    
}