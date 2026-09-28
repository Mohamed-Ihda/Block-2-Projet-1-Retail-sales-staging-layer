[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "categories csv_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "CategoryCode", DestinationColumnName = "CategoryCode"], [SourceColumnName = "CategoryName", DestinationColumnName = "CategoryName"], [SourceColumnName = "Department", DestinationColumnName = "Department"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"categories csv" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "471e948c-0039-4e1e-af23-3c4ffb3c9e68"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "87f4c1d5-b499-4476-96f0-2a40ea8d50f8"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Name = "raw"]}[Content],
  #"Navigation 4" = #"Navigation 3"{[Name = "categories.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 4", [Delimiter = ",", Columns = 3, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Trimmed text" = Table.TransformColumns(#"Promoted headers", {{"CategoryCode", each Text.Trim(_), type nullable text}}),
  #"Uppercased text" = Table.TransformColumns(#"Trimmed text", {{"CategoryCode", each Text.Upper(_), type nullable text}}),
  #"Changed column type" = Table.TransformColumnTypes(#"Uppercased text", {{"CategoryName", type text}, {"Department", type text}})
in
  #"Changed column type";
shared #"categories csv_DataDestination" = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),
  Navigation_1 = Pattern{[workspaceId = "471e948c-0039-4e1e-af23-3c4ffb3c9e68"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "87f4c1d5-b499-4476-96f0-2a40ea8d50f8"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "dim_category", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
