/**
 * Configuration object to be passed to MSAL instance on creation. 
 * For a full list of MSAL.js configuration parameters, visit:
 * https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/configuration.md 
 */
const msalConfig = {
    auth: {
        clientId: "Enter_the_Application_Id_Here", // This is the ONLY mandatory field that you need to supply.
        authority: "https://login.microsoftonline.com/Enter_the_Tenant_Info_Here", // Defaults to "https://login.microsoftonline.com/common"
        redirectUri: "/", // You must register this URI on Azure Portal/App Registration. Defaults to window.location.href
    },
    cache: {
        cacheLocation: "localStorage", // This configures where your cache will be stored
        storeAuthStateInCookie: false, // Set this to "true" if you are having issues on IE11 or Edge
    },
};

// Add here the endpoints for MS Graph API services you would like to use.
const graphConfig = {
    graphMeEndpoint: {
        uri: "https://graph.microsoft.com/v1.0/me",
        scopes: ["User.Read"]
    },
    graphMailEndpoint: {
        uri: "https://graph.microsoft.com/v1.0/me/messages",
        scopes: ["Mail.Read"]
    }
};

/**
 * Scopes you add here will be prompted for user consent during sign-in.
 * By default, MSAL.js will add OIDC scopes (openid, profile, email) to any login request.
 * For more information about OIDC scopes, visit: 
 * https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent#openid-connect-scopes
 */
const loginRequest = {
    scopes: ["User.Read"]
};

// exporting config object for jest
if (typeof exports !== 'undefined') {
    module.exports = {
        msalConfig: msalConfig,
    };
}
