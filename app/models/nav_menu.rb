=begin
  Camaleon CMS is a content management system
  Copyright (C) 2015 by Owen Peredo Diaz
  Email: owenperedo@gmail.com
  This program is free software: you can redistribute it and/or modify   it under the terms of the GNU Affero General Public License as  published by the Free Software Foundation, either version 3 of the  License, or (at your option) any later version.
  This program is distributed in the hope that it will be useful,  but WITHOUT ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the  GNU Affero General Public License (GPLv3) for more details.
=end
class NavMenu < TermTaxonomy
  default_scope { where(taxonomy: :nav_menu) }
  has_many :metas, ->{ where(object_class: 'NavMenu')}, :class_name => "Meta", foreign_key: :objectid, dependent: :destroy
  has_many :children, class_name: "NavMenuItem", foreign_key: :parent_id, dependent: :destroy
  belongs_to :site, :class_name => "Site", foreign_key: :parent_id

  def add_menu_items(menu_data=[])
    children.destroy_all
    saved_nav_items(self, menu_data) if menu_data.present?
  end

  def append_menu_item (value)
    item = children.new({name: value[:label]})
    if item.save
      item.set_meta('_default',{type: value[:type], object_id: value[:link]})
    end
  end

  private

  def saved_nav_items (nav_menu_item, items)
    items.each do |key, value|
      item = nav_menu_item.children.new({name: value[:label]})
      if item.save
        item.set_meta('_default',{type: value[:type], object_id: value[:link]})
        saved_nav_items(item, value[:children]) if value[:children].present?
      end
    end
  end



end
