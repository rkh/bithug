Maglev.persistent do
  Maglev::PERSISTENT_ROOT["Bithug::Models"] = nil
  Object.remove_const(:Bithug)
end
Maglev.commit_transaction
