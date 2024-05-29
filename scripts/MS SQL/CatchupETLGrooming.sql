-- (c) Copyright 2004-2006 Microsoft Corporation, All Rights Reserved         --
-- Proprietary and confidential to Microsoft Corporation                      --       
-- File:      CatchupETLGrooming.sql                                          --
-- Contents: A bug in the ETL grooming code could have left the customer      --
-- Database with a large amount of ETL rows to groom. This script will groom   --
-- The ETL entries in a loop 100K rows at a time to avoid filling up the        --
-- Transaction log                                                             --
---------------------------------------------------------------------------------
DECLARE @RowCount int = 1;
DECLARE @BatchSize int = 100000;
DECLARE @SubscriptionWatermark bigint = 0;     
DECLARE @LastErr int;
-- Delete rows from the EntityTransactionLog. We delete the rows with TransactionLogId that aren't being
-- used anymore by the EntityChangeLog table and by the RelatedEntityChangeLog table.
SELECT @SubscriptionWatermark = dbo.fn_GetEntityChangeLogGroomingWatermark();
WHILE(@RowCount > 0)
BEGIN
  DELETE TOP(@BatchSize) ETL  
  FROM EntityTransactionLog ETL
  WHERE NOT EXISTS (SELECT 1 FROM EntityChangeLog ECL WHERE ECL.EntityTransactionLogId = ETL.EntityTransactionLogId) AND NOT EXISTS (SELECT 1 FROM RelatedEntityChangeLog RECL
  WHERE RECL.EntityTransactionLogId = ETL.EntityTransactionLogId)
  AND ETL.EntityTransactionLogId < @SubscriptionWatermark;        
  SELECT @LastErr = @@ERROR, @RowCount = @@ROWCOUNT;            
END