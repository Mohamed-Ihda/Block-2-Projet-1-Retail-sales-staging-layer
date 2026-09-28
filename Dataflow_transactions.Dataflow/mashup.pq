[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "transactions_2022 csv_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "TransactionID", DestinationColumnName = "TransactionID"], [SourceColumnName = "TransactionDate", DestinationColumnName = "TransactionDate"], [SourceColumnName = "CustomerID", DestinationColumnName = "CustomerID"], [SourceColumnName = "StoreID", DestinationColumnName = "StoreID"], [SourceColumnName = "ItemCode", DestinationColumnName = "ItemCode"], [SourceColumnName = "CategoryCode", DestinationColumnName = "CategoryCode"], [SourceColumnName = "UnitPrice", DestinationColumnName = "UnitPrice"], [SourceColumnName = "Quantity", DestinationColumnName = "Quantity"], [SourceColumnName = "TotalAmount", DestinationColumnName = "TotalAmount"], [SourceColumnName = "PaymentMethod", DestinationColumnName = "PaymentMethod"], [SourceColumnName = "Location", DestinationColumnName = "Location"], [SourceColumnName = "DiscountApplied", DestinationColumnName = "DiscountApplied"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"transactions_2022 csv" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "471e948c-0039-4e1e-af23-3c4ffb3c9e68"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "87f4c1d5-b499-4476-96f0-2a40ea8d50f8"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Name = "raw"]}[Content],
  #"Navigation 4" = #"Navigation 3"{[Name = "transactions_2022.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 4", [Delimiter = ",", Columns = 13, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"TransactionID", type text}, {"TransactionDate", type date}, {"CustomerID", type text}, {"StoreID", type text}, {"ItemCode", type text}, {"CategoryCode", type text}, {"UnitPrice", type number}, {"Quantity", Int64.Type}, {"TotalAmount", type number}, {"PaymentMethod", type text}, {"Location", type text}, {"DiscountApplied", type logical}, {"SourceFile", type text}}),
  #"Removed columns" = Table.RemoveColumns(#"Changed column type", {"SourceFile"})
in
  #"Removed columns";
shared #"transactions_2023 csv" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "471e948c-0039-4e1e-af23-3c4ffb3c9e68"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "87f4c1d5-b499-4476-96f0-2a40ea8d50f8"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Name = "raw"]}[Content],
  #"Navigation 4" = #"Navigation 3"{[Name = "transactions_2023.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 4", [Delimiter = ",", Columns = 12, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Changed column type with locale" = Table.TransformColumnTypes(#"Promoted headers", {{"TransactionDate", type date}, {"TransactionID", type text}, {"CustomerID", type text}, {"StoreID", type text}, {"ItemCode", type text}, {"CategoryCode", type text}, {"UnitPrice", type number}, {"Quantity", Int64.Type}, {"TotalAmount", type number}, {"PaymentMethod", type text}, {"Location", type text}, {"DiscountApplied", type logical}}, "en-GB")
in
  #"Changed column type with locale";
shared #"transactions_2024_2025 csv" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "471e948c-0039-4e1e-af23-3c4ffb3c9e68"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "87f4c1d5-b499-4476-96f0-2a40ea8d50f8"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Name = "raw"]}[Content],
  #"Navigation 4" = #"Navigation 3"{[Name = "transactions_2024_2025.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 4", [Delimiter = ",", Columns = 12, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"TransactionID", type text}, {"TransactionDate", type date}, {"CustomerID", type text}, {"StoreID", type text}, {"ItemCode", type text}, {"CategoryCode", type text}, {"UnitPrice", type number}, {"Quantity", Int64.Type}, {"TotalAmount", type number}, {"PaymentMethod", type text}, {"Location", type text}, {"DiscountApplied", type logical}})
in
  #"Changed column type";
shared Transactions = let
  Source = Table.Combine({#"transactions_2022 csv", #"transactions_2023 csv", #"transactions_2024_2025 csv"}),
  #"Removed duplicates" = Table.Distinct(Source, {"TransactionID", "TransactionDate", "CustomerID", "StoreID", "ItemCode", "CategoryCode", "UnitPrice", "Quantity", "TotalAmount", "PaymentMethod", "Location", "DiscountApplied"}),
  #"Added custom" = Table.TransformColumnTypes(Table.AddColumn(#"Removed duplicates", "TransactionYear", each Date.Year([TransactionDate])), {{"TransactionYear", Int64.Type}}),
  #"Changed column type" = Table.TransformColumnTypes(#"Added custom", {{"UnitPrice", type number}, {"Quantity", type number}, {"TotalAmount", type number}}),
  #"Replaced value" = Table.ReplaceValue(#"Changed column type", "", "UNKNOWN", Replacer.ReplaceValue, {"ItemCode"})
in
  #"Replaced value";
shared #"transactions_2022 csv_DataDestination" = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),
  Navigation_1 = Pattern{[workspaceId = "471e948c-0039-4e1e-af23-3c4ffb3c9e68"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "87f4c1d5-b499-4476-96f0-2a40ea8d50f8"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "fact_transaction", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
