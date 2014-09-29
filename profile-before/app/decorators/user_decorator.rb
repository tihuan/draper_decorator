class UserDecorator < ApplicationDecorator
  decorates :user
  # only #username will be delegated to User
  allows :username

  def avatar
    # link_to_if @user.url.present?, image_tag("avatars/#{avatar_name(@user)}", class: "avatar"), @user.url
    # h.link_to_if model.url.present?, h.image_tag("avatars/#{avatar_name(@user)}", class: "avatar"), model.url
    site_link(h.image_tag("avatars/#{avatar_name(@user)}", class: "avatar"))
  end

  def linked_name
    site_link(model.full_name.present? ? model.full_name : model.username)
  end

  def website
    handle_none(model.url) do
      h.link_to model.url, model.url
    end
  end

  def twitter
    handle_none(model.twitter_name) do
      h.link_to model.twitter_name, "http://twitter.com/#{model.twitter_name}"
    end
  end

  def bio
    handle_none(model.bio) do
      # Refactor Redcarpet call to application_decorator.rb
      # raw Redcarpet.new(model.bio, :hard_wrap, :filter_html, :autolink).to_html
      markdown (model.bio)
    end
  end

  def member_since
    model.created_at.strftime("%B %e, %Y")
  end

private

  def handle_none(value)
    if value.present?
      yield
    else
      h.content_tag :span, "None given", class: "none"
    end
  end

  def site_link(content)
    h.link_to_if model.url.present?, content, model.url
  end

  def avatar_name
    if model.avatar_image_name.present?
      model.avatar_image_name
    else
      "default.png"
    end
  end
end
