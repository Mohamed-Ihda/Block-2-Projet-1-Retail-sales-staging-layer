[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "products csv_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "ItemCode", DestinationColumnName = "ItemCode"], [SourceColumnName = "ItemName", DestinationColumnName = "ItemName"], [SourceColumnName = "CategoryCode", DestinationColumnName = "CategoryCode"], [SourceColumnName = "UnitPrice", DestinationColumnName = "UnitPrice"], [SourceColumnName = "SupplierID", DestinationColumnName = "SupplierID"], [SourceColumnName = "Active", DestinationColumnName = "Active"], [SourceColumnName = "CategoryName", DestinationColumnName = "CategoryName"], [SourceColumnName = "Department", DestinationColumnName = "Department"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"products csv" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "471e948c-0039-4e1e-af23-3c4ffb3c9e68"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "87f4c1d5-b499-4476-96f0-2a40ea8d50f8"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Name = "raw"]}[Content],
  #"Navigation 4" = #"Navigation 3"{[Name = "products.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 4", [Delimiter = ";", Columns = 6, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Replaced value" = Table.ReplaceValue(#"Promoted headers", "MAD ", "", Replacer.ReplaceText, {"UnitPrice"}),
  #"Trimmed text" = Table.TransformColumns(#"Replaced value", {{"UnitPrice", each Text.Trim(_), type nullable text}}),
  #"Changed column type with locale" = Table.TransformColumnTypes(#"Trimmed text", {{"UnitPrice", type number}}, "fr-FR"),
  #"Trimmed text 1" = Table.TransformColumns(#"Changed column type with locale", {{"ItemName", each Text.Trim(_), type nullable text}}),
  #"Trimmed text 2" = Table.TransformColumns(#"Trimmed text 1", {{"CategoryCode", each Text.Trim(_), type nullable text}}),
  #"Uppercased text" = Table.TransformColumns(#"Trimmed text 2", {{"CategoryCode", each Text.Upper(_), type nullable text}}),
  #"Removed duplicates" = Table.Distinct(#"Uppercased text", {"ItemCode", "ItemName", "CategoryCode", "UnitPrice", "SupplierID", "Active"}),
  #"Merged queries" = Table.NestedJoin(#"Removed duplicates", {"CategoryCode"}, dim_category, {"CategoryCode"}, "dim_category", JoinKind.LeftOuter),
  #"Expanded dim_category" = Table.ExpandTableColumn(#"Merged queries", "dim_category", {"CategoryName", "Department"}, {"CategoryName", "Department"}),
  #"Appended query" = Table.Combine({#"Expanded dim_category", TempTable})
in
  #"Appended query";
shared dim_category = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "471e948c-0039-4e1e-af23-3c4ffb3c9e68"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "87f4c1d5-b499-4476-96f0-2a40ea8d50f8"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "dim_category", ItemKind = "Table"]}[Data]
in
  #"Navigation 2";
shared TempTable = let
  Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WCvXz9vMP91PSUQrNy87LL89TyCxJzQVx/byBJJwRiVCBxIqNBQA=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [ItemCode = _t, ItemName = _t, CategoryCode = _t, UnitPrice = _t, SupplierID = _t, Active = _t, CategoryName = _t, Department = _t]),
  #"Changed column type" = Table.TransformColumnTypes(Source, {{"UnitPrice", type number}})
in
  #"Changed column type";
shared #"products csv_DataDestination" = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),
  Navigation_1 = Pattern{[workspaceId = "471e948c-0039-4e1e-af23-3c4ffb3c9e68"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "87f4c1d5-b499-4476-96f0-2a40ea8d50f8"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "dim_product", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
