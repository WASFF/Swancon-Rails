Squeel.configure do |config|
  # To load symbol extensions (for a subset of the old MetaWhere functionality,
  # via ARel predicate methods on Symbols: :name.matches, etc)
  # config.load_core_extensions :symbol

  # To load both hash and symbol extensions
  # config.load_core_extensions :hash, :symbol
end
