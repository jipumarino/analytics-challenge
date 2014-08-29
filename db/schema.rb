Sequel.migration do
  change do
    create_table(:page_views) do
      primary_key :id, :type=>"int(11)"
      column :url, "varchar(2048)", :null=>false
      column :referrer, "varchar(2048)"
      column :created_at, "datetime", :null=>false
      column :hash, "varchar(40)", :null=>false
    end
    
    create_table(:schema_migrations) do
      column :filename, "varchar(255)", :null=>false
      
      primary_key [:filename]
    end
  end
end
Sequel.migration do
  change do
    self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20140829222644_create_page_views.rb')"
  end
end
