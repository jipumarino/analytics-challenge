Sequel.migration do 
  change do

    create_table :page_views do
      primary_key :id
      column :url,        "varchar(2048)", null: false
      column :referrer,   "varchar(2048)"
      column :created_at, "datetime",      null: false
      column :hash,       "varchar(40)",   null: false
    end

  end
end


