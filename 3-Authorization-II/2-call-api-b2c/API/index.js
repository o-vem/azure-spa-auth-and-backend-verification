const express = require('express');
const morgan = require('morgan');
const passport = require('passport');
const config = require('./config.json');

const BearerStrategy = require('passport-azure-ad').BearerStrategy;

// this is the API scope you've exposed during app registration
const EXPOSED_SCOPES = [ "demo.read" ]

const options = {
    identityMetadata: `https://${config.metadata.b2cDomain}/${config.credentials.tenantName}/${config.policies.policyName}/${config.metadata.version}/${config.metadata.discovery}`,
    clientID: config.credentials.clientID,
    policyName: config.policies.policyName,
    isB2C: config.settings.isB2C,
    validateIssuer: config.settings.validateIssuer,
    loggingLevel: config.settings.loggingLevel,
    passReqToCallback: config.settings.passReqToCallback,
    scope: EXPOSED_SCOPES
}

const bearerStrategy = new BearerStrategy(options, (token, done) => {
        // Send user info using the second argument
        done(null, { }, token);
    }
);

const app = express();

app.use(morgan('dev'));

app.use(passport.initialize());

passport.use(bearerStrategy);

//enable CORS (for testing only -remove in production/deployment)
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Authorization, Origin, X-Requested-With, Content-Type, Accept');
    next();
});

// API endpoint
app.get('/api',
    passport.authenticate('oauth-bearer', {session: false}),
    (req, res) => {
        console.log('Validated claims: ', req.authInfo);
        
        // Service relies on the name claim.  
        res.status(200).json({'name': req.authInfo['name']});
    }
);

const port = process.env.PORT || 5000;

app.listen(port, () => {
    console.log('Listening on port ' + port);
});

module.exports = app;
