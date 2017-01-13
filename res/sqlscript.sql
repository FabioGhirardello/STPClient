CREATE VIEW msg as
SELECT TradeId, Type, OrderID, TradeDate, Role, BaseCcy || '/' || TermCcy as CcyPair, Side, Dealt, CASE WHEN Side = 'Sell' THEN  -(BaseAmt) ELSE BaseAmt END as BaseAmt2, ValueDate, AllInRate, CptyID
FROM STPMessage
WHERE TradeDate >= (SELECT date('now', '-5 day')) and Type = 'FXSpot';