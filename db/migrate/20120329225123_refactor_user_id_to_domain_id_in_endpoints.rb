require 'uri'
class RefactorUserIdToDomainIdInEndpoints < ActiveRecord::Migration

  def self.up
    add_column :endpoints, :domain_id, :integer
    for endpoint in Endpoint.all
      domain = Domain.for_url(endpoint.url, endpoint.user_id)
      endpoint.domain_id = domain.id
      if ! endpoint.save
        puts "failed to map endpoint #{endpoint.id}: #{endpoint.errors.full_messages.join(', ')}, domain error: #{domain.errors.full_messages.join(', ')}"
      end
    end
    remove_column :endpoints, :user_id
    
    add_index :endpoints, [ :domain_id ]
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end
