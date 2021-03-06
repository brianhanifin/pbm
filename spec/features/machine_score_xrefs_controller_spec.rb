require 'spec_helper'

describe MachineScoreXrefsController do
  before(:each) do
    @region = FactoryGirl.create(:region, :name => 'portland')
    @location = FactoryGirl.create(:location, :region => @region)
  end

  describe 'add machine scores', :type => :feature, :js => true do
    it 'adds a score' do
      lmx = FactoryGirl.create(:location_machine_xref, :location => @location, :machine => FactoryGirl.create(:machine))

      visit "/#{@region.name}/?by_location_id=#{@location.id}"

      page.find("div#add_scores_lmx_banner_#{lmx.id}").click
      fill_in('score', :with => 1234)
      fill_in('initials', :with => 'cap')
      select('GC', :from => 'rank')
      click_on('Add Score')

      sleep(1)

      lmx.machine_score_xrefs.first.score.should == 1234
      lmx.machine_score_xrefs.first.initials.should eq 'cap'
      lmx.machine_score_xrefs.first.rank.should == 1
    end

    it 'removes non-digit characters from high scores' do
      lmx = FactoryGirl.create(:location_machine_xref, :id => 1, :location => @location, :machine => FactoryGirl.create(:machine))

      visit "/#{@region.name}/?by_location_id=#{@location.id}"

      page.find("div#add_scores_lmx_banner_#{lmx.id}").click
      fill_in('score', :with => '1,234')
      fill_in('initials', :with => 'cap')
      select('GC', :from => 'rank')
      click_on('Add Score')

      sleep(1)

      lmx.machine_score_xrefs.first.score.should == 1234
      lmx.machine_score_xrefs.first.initials.should eq 'cap'
      lmx.machine_score_xrefs.first.rank.should == 1
    end
  end

  describe 'feeds', :type => :feature, :js => true do
    it 'Should only display the last 50 scores in the feed' do
      old_machine = FactoryGirl.create(:machine, :name => 'Spider-Man')
      recent_machine = FactoryGirl.create(:machine, :name => 'Twilight Zone')

      oldest_entry = FactoryGirl.create(:location_machine_xref, :id => 1, :location => @location, :machine => old_machine)
      (1 .. 50).each {|i| FactoryGirl.create(:location_machine_xref, :id => i + 1, :location => @location, :machine => recent_machine) }
      (1 .. 50).each {|i| FactoryGirl.create(:machine_score_xref, :location_machine_xref => LocationMachineXref.find(i + 1)) }

      visit "/#{@region.name}/machine_score_xrefs.rss"

      page.body.should have_content('Twilight Zone')
      page.body.should_not have_content('Spider-Man')
    end
  end

  describe 'displays scores correctly', :type => :feature, :js => true do
    it 'honors the hide/show of the display area' do
      lmx = FactoryGirl.create(:location_machine_xref, :location => @location, :machine => FactoryGirl.create(:machine))

      visit "/#{@region.name}/?by_location_id=#{@location.id}"

      page.should_not have_css("div#show_scores_lmx_banner_#{lmx.id}")

      page.find("div#add_scores_lmx_banner_#{lmx.id}").click
      fill_in('score', :with => 1234)
      fill_in('initials', :with => 'cap')
      select('GC', :from => 'rank')
      click_on('Add Score')

      sleep(1)

      page.should have_css("div#show_scores_lmx_banner_#{lmx.id}")
    end
  end
end
