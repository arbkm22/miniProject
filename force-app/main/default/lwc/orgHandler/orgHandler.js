import { LightningElement, track, wire } from 'lwc';
import getTriggers from '@salesforce/apex/orgHandlerClass.getTriggers';

import noHeader from '@salesforce/resourceUrl/NoHeader';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class OrgHandler extends LightningElement {
    
    TriggerNameList = [];
    EnumOrIdList = [];
    ApiVersionList = [];
    
    connectedCallback() {
        loadStyle(this, noHeader)
            .then(result => {});
    }

    @wire(getTriggers) getTriggersList({ data, error }) {
        if (data)
            console.log(data);
        else if (error) 
            console.log(error);
    }
}