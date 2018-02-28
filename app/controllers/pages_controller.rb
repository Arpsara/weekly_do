# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  def home
    authorize :page, :home?
  end
end
