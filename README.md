# Flight Dashboard
Copyright (c) 2022 node-traversal

Track your flights on your day of travel.

Environment.xcconfig: A gitignored file containing secrets and configuration for the environment
** There are sever downsides to this approach **
- see https://www.lordcodes.com/articles/managing-secrets-within-an-ios-app
Options:
- FLIGHT_AWARE_API_KEY:  required, see https://flightaware.com/commercial/aeroapi/
- DATADOG_CLIENT_ID: optional, see https://docs.datadoghq.com/account_management/api-app-keys/#client-tokens
- LOGGER_FINE_ENABLED: true - enable more logging 
