class PagesController < ApplicationController
  def index
    @tasks = [
      { :date => Date.today, :name => 'Open Escrow', :description => 'Lorem Ipsum' },
      { :date => Date.today + 4.days, :name => 'Appraisal', :description => 'Lorem Ipsum' },
      { :date => Date.today + 8.days, :name => 'Inspection', :description => 'Lorem Ipsum', :active => true },
      { :date => Date.today + 15.days, :name => 'Insurance', :description => 'Lorem Ipsum' },
      { :date => Date.today + 21.days, :name => 'Loan', :description => 'Lorem Ipsum' },
      { :date => Date.today + 29.days, :name => 'Close Escrow', :description => 'Lorem Ipsum' }
    ]
  end
end