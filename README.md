# powershell_controldefaultprinter_session
Login/Logoff script to session-based environment that defines default print behavior. 

This is a known/common issue on RDS/Citrix environments based on Windows Server 2019. Issues with default printer reverting to a local PDF printer instead of network printer.

Things to remmeber on implementation:
- Export a "default printer reg" to central location (ex. NETLOGON). The script will then revert to a "default" if the printer within profile/session is incorrect.
