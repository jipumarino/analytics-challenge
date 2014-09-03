Sequel.migration do
  up {
    run "ALTER TABLE `page_views` ADD INDEX created_at_and_url (`created_at`, `url` (250))"
  }

  down {
    run "ALTER TABLE `page_views` DROP INDEX created_at_and_url"
  }
end
