export const handler = async (event) => {
    console.log("Filtered AFT event: %O", event);

    let response = null;

    if (event && event.length > 0)  {
        const newGlobalSection = JSON.parse(JSON.parse(event[0].newCustomFields).global);
        const oldGlobalSection = JSON.parse(JSON.parse(event[0].oldCustomFields).global);

        const newSSOSection = JSON.parse(JSON.parse(event[0].newCustomFields).sso);
        const oldSSOSection = JSON.parse(JSON.parse(event[0].oldCustomFields).sso);

        console.log('Old SSO : %O', oldSSOSection);
        console.log('New SSO : %O', newSSOSection);

        const oldTfcWorkspaces = oldGlobalSection.security.tfc.workspaces
        const newTfcWorkspaces = newGlobalSection.security.tfc.workspaces

        console.log('Old Workspaces : %O', oldTfcWorkspaces);
        console.log('New Workspaces : %O', newTfcWorkspaces);

        response = {
            "include": "tags",
            "target_value": [{"aft:account_name": newGlobalSection.account_name}
            ]
        }
    }
    console.log("Response is: %O", response);
    return response;
};
