ALTER DATABASE OperationsManager SET SINGLE_USER WITH ROLLBACK IMMEDIATE
 ALTER DATABASE OperationsManager SET ENABLE_BROKER
 ALTER DATABASE OperationsManager SET MULTI_USER
 
SELECT is_broker_enabled FROM sys.databases WHERE name='OperationsManager'