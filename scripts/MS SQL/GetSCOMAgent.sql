select bme.DisplayName from MT_HealthService mths 
INNER JOIN BaseManagedEntity bme on bme.BaseManagedEntityId = mths.BaseManagedEntityId 
where IsManuallyInstalled = 1