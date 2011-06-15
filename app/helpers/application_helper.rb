module ApplicationHelper
  def link_to_edit(record)
    content_tag(:span, :class => 'edit action') do
      raw "[ #{link_to('edit', edit_polymorphic_path(record))} ]"
    end
  end
  
  def show_flash
    unless notice.blank?
      content_tag(:p, :id => 'notice') do
        notice
      end
    end
  end
  
  def link_back_to_list
    link_to '« Back to List', {:action => :index}, {:class => "link-back-to-list"}
  end
end
