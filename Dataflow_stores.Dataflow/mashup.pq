[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "stores csv_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "StoreID", DestinationColumnName = "StoreID"], [SourceColumnName = "StoreName", DestinationColumnName = "StoreName"], [SourceColumnName = "City", DestinationColumnName = "City"], [SourceColumnName = "Region", DestinationColumnName = "Region"], [SourceColumnName = "Channel", DestinationColumnName = "Channel"], [SourceColumnName = "OpenedDate", DestinationColumnName = "OpenedDate"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"stores csv" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "471e948c-0039-4e1e-af23-3c4ffb3c9e68"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "87f4c1d5-b499-4476-96f0-2a40ea8d50f8"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Name = "raw"]}[Content],
  #"Navigation 4" = #"Navigation 3"{[Name = "stores.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 4", [Delimiter = ",", Columns = 6, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"StoreID", type text}, {"StoreName", type text}, {"City", type text}, {"Region", type text}, {"Channel", type text}, {"OpenedDate", type date}}),
  #"Replaced value" = Table.ReplaceValue(#"Changed column type", "", "N/A", Replacer.ReplaceValue, {"City"}),
  #"Replaced value 1" = Table.ReplaceValue(#"Replaced value", "", "N/A", Replacer.ReplaceValue, {"Region"})
in
  #"Replaced value 1";
shared #"stores csv_DataDestination" = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),
  Navigation_1 = Pattern{[workspaceId = "471e948c-0039-4e1e-af23-3c4ffb3c9e68"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "87f4c1d5-b499-4476-96f0-2a40ea8d50f8"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "dim_store", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
