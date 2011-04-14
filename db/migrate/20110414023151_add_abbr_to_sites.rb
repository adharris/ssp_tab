class AddAbbrToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :abbr, :string
    Site.all.each do |site|
      site.abbr = site.name.gsub(/ /, '')[0..2]
      site.save
    end
  end

  def self.down
    remove_column :sites, :abbr
  end
end
