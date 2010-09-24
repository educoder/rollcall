module ApplicationHelper
  def link_to_edit(record)
    content_tag(:span, :class => 'edit action') do
      "[ #{link_to('edit', edit_polymorphic_path(record))} ]"
    end
  end
  
  def show_flash
    unless notice.blank?
      content_tag(:p, :id => 'notice') do
        notice
      end
    end
  end
end
