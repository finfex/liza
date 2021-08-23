module BlockchainExploring
  def explorer=(hash)
    write_attribute(:explorer_address, hash.fetch('address'))
    write_attribute(:explorer_transaction, hash.fetch('transaction'))
    write_attribute(:explorer_contract_address, hash.fetch('contract_address', nil))
  end

  def explore_contract_address_url(contract_address)
    explorer_contract_address.to_s.gsub('#{contract_address}', contract_address)
  end

  def explore_address_url(address)
    explorer_address.to_s.gsub('#{address}', address)
  end

  def explore_transaction_url(txid)
    explorer_transaction.to_s.gsub('#{txid}', txid)
  end
end
