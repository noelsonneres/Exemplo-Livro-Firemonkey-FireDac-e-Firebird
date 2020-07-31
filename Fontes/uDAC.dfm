object fDAC: TfDAC
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 263
  Width = 334
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=C:\ProjetosXE\Database\Orion\ORIONSG.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Port=3050'
      'CharacterSet=WIN1252'
      'ExtendedMetadata=True'
      'Server=localhost'
      'DriverID=FB')
    LoginPrompt = False
    Transaction = FDDefaultTransaction
    UpdateTransaction = FDUpdateTransaction
    Left = 47
    Top = 8
  end
  object FDQuery: TFDQuery
    CachedUpdates = True
    Connection = FDConnection
    FetchOptions.AssignedValues = [evItems, evCache]
    FormatOptions.AssignedValues = [fvFmtDisplayDate]
    Left = 168
    Top = 8
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 47
    Top = 151
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    VendorLib = 'C:\Meus Programas\Firebird\Firebird_2_5\bin\fbclient.dll'
    Left = 47
    Top = 199
  end
  object FDMetaInfoQuery: TFDMetaInfoQuery
    Connection = FDConnection
    MetaInfoKind = mkTableFields
    Left = 257
    Top = 7
  end
  object FDUpdateTransaction: TFDTransaction
    Options.AutoStart = False
    Options.AutoStop = False
    Connection = FDConnection
    Left = 47
    Top = 102
  end
  object FDDefaultTransaction: TFDTransaction
    Connection = FDConnection
    Left = 47
    Top = 56
  end
  object FDScript: TFDScript
    SQLScripts = <>
    Connection = FDConnection
    Transaction = FDUpdateTransaction
    Params = <>
    Macros = <>
    Left = 168
    Top = 56
  end
  object FDIBSecurity: TFDIBSecurity
    DriverLink = FDPhysFBDriverLink
    Left = 168
    Top = 104
  end
  object FDMemTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    AutoCommitUpdates = False
    Left = 168
    Top = 152
  end
end
