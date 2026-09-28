[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "customers csv_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "CustomerID", DestinationColumnName = "CustomerID"], [SourceColumnName = "FirstName", DestinationColumnName = "FirstName"], [SourceColumnName = "LastName", DestinationColumnName = "LastName"], [SourceColumnName = "Email", DestinationColumnName = "Email"], [SourceColumnName = "Phone", DestinationColumnName = "Phone"], [SourceColumnName = "City", DestinationColumnName = "City"], [SourceColumnName = "Country", DestinationColumnName = "Country"], [SourceColumnName = "SignupDate", DestinationColumnName = "SignupDate"], [SourceColumnName = "LoyaltyTier", DestinationColumnName = "LoyaltyTier"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"customers csv" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "471e948c-0039-4e1e-af23-3c4ffb3c9e68"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "87f4c1d5-b499-4476-96f0-2a40ea8d50f8"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Name = "raw"]}[Content],
  #"Navigation 4" = #"Navigation 3"{[Name = "customers.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 4", [Delimiter = ",", Columns = 10, QuoteStyle = QuoteStyle.None]),
  #"Removed top rows" = Table.Skip(#"Imported CSV", 1),
  #"Changed column type" = Table.TransformColumnTypes(#"Removed top rows", {{"Column1", type text}, {"Column2", type text}, {"Column3", type text}, {"Column4", type text}, {"Column5", type text}, {"Column6", type text}, {"Column7", type text}, {"Column8", type text}, {"Column9", type text}, {"Column10", type text}}),
  #"Promoted headers" = Table.PromoteHeaders(#"Changed column type", [PromoteAllScalars = true]),
  #"Removed columns" = Table.RemoveColumns(#"Promoted headers", {"Notes"}),
  #"Removed duplicates" = Table.Distinct(#"Removed columns", {"CustomerID"}),
  #"Trimmed text" = Table.TransformColumns(#"Removed duplicates", {{"City", each Text.Trim(_), type nullable text}}),
  #"Capitalized each word" = Table.TransformColumns(#"Trimmed text", {{"City", each Text.Proper(_), type nullable text}}),
  #"Replaced value" = Table.ReplaceValue(#"Capitalized each word", "morocco", "Morocco", Replacer.ReplaceText, {"Country"}),
  #"Replaced value 1" = Table.ReplaceValue(#"Replaced value", "MA", "Morocco", Replacer.ReplaceText, {"Country"}),
  #"Replaced value 2" = Table.ReplaceValue(#"Replaced value 1", "Maroc", "Morocco", Replacer.ReplaceText, {"Country"}),
  #"Capitalized each word 1" = Table.TransformColumns(#"Replaced value 2", {{"LoyaltyTier", each Text.Proper(_), type nullable text}}),
  #"Trimmed text 1" = Table.TransformColumns(#"Capitalized each word 1", {{"LoyaltyTier", each Text.Trim(_), type nullable text}}),
  #"Replaced value 3" = Table.ReplaceValue(#"Trimmed text 1", "", "None", Replacer.ReplaceValue, {"LoyaltyTier"}),
  #"Replaced value 4" = Table.ReplaceValue(#"Replaced value 3", "", "None", Replacer.ReplaceValue, {"Email"}),
  #"Changed column type with locale" = Table.TransformColumnTypes(#"Replaced value 4", {{"SignupDate", type date}}, "en-GB")
in
  #"Changed column type with locale";
shared #"customers csv_DataDestination" = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),
  Navigation_1 = Pattern{[workspaceId = "471e948c-0039-4e1e-af23-3c4ffb3c9e68"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "87f4c1d5-b499-4476-96f0-2a40ea8d50f8"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "dim_customer", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
