[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "suppliers csv_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "SupplierID", DestinationColumnName = "SupplierID"], [SourceColumnName = "SupplierName", DestinationColumnName = "SupplierName"], [SourceColumnName = "Department", DestinationColumnName = "Department"], [SourceColumnName = "ContactEmail", DestinationColumnName = "ContactEmail"], [SourceColumnName = "Phone", DestinationColumnName = "Phone"], [SourceColumnName = "Status", DestinationColumnName = "Status"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"suppliers csv" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "471e948c-0039-4e1e-af23-3c4ffb3c9e68"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "87f4c1d5-b499-4476-96f0-2a40ea8d50f8"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Name = "raw"]}[Content],
  #"Navigation 4" = #"Navigation 3"{[Name = "suppliers.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 4", [Delimiter = ",", Columns = 6, QuoteStyle = QuoteStyle.None]),
  #"Removed top rows" = Table.Skip(#"Imported CSV", 2),
  #"Removed bottom rows" = Table.RemoveLastN(#"Removed top rows", 1),
  #"Changed column type" = Table.TransformColumnTypes(#"Removed bottom rows", {{"Column1", type text}, {"Column2", type text}, {"Column3", type text}, {"Column4", type text}, {"Column5", type text}, {"Column6", type text}}),
  #"Promoted headers" = Table.PromoteHeaders(#"Changed column type", [PromoteAllScalars = true]),
  #"Capitalized each word" = Table.TransformColumns(#"Promoted headers", {{"Status", each Text.Proper(_), type nullable text}}),
  #"Trimmed text" = Table.TransformColumns(#"Capitalized each word", {{"Status", each Text.Trim(_), type nullable text}}),
  #"Replaced value" = Table.ReplaceValue(#"Trimmed text", "", "None", Replacer.ReplaceValue, {"ContactEmail"}),
  #"Replaced value 1" = Table.ReplaceValue(#"Replaced value", "", "None", Replacer.ReplaceValue, {"Phone"})
in
  #"Replaced value 1";
shared #"suppliers csv_DataDestination" = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),
  Navigation_1 = Pattern{[workspaceId = "471e948c-0039-4e1e-af23-3c4ffb3c9e68"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "87f4c1d5-b499-4476-96f0-2a40ea8d50f8"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "dim_supplier", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
