

CREATE OR ALTER FUNCTION Warehouse.EvaluateTemperature (@Temp decimal(10, 2)) 
RETURNS char(10)
BEGIN
	RETURN CASE
		WHEN @Temp < 3.5 THEN 'Too cold'
		WHEN @Temp > 4.0 THEN 'Too hot'
		ELSE 'Just right'
	END;
END;
GO


SELECT
	Temperature,
	Warehouse.EvaluateTemperature(Temperature) AS 'Evaluation'
FROM Warehouse.ColdRoomTemperatures;
GO