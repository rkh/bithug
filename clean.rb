Maglev.persistent do
  Maglev::PERSISTENT_ROOT["Bithug::Models"] = nil
  begin
    Kernel.remove_const(:Bithug)
  rescue Exception
  end
end
Maglev.commit_transaction
