require 'axe/cucumber/world'

# register module to expose #axe_steps to cucumber World
World(Axe::Cucumber::World)

Then "the page should be accessible", :accessible, on: -> { axe_steps }

Then "the page should not be accessible", :inaccessible, on: -> { axe_steps }

Then "the page should be accessible within $inclusion_selector", :accessible_within, on: -> { axe_steps }

Then "the page should not be accessible within $inclusion_selector", :inaccessible_within, on: -> { axe_steps }

Then "the page should be accessible excluding $exclusion_selector", :accessible_excluding, on: -> { axe_steps }

Then "the page should not be accessible excluding $exclusion_selector", :inaccessible_excluding, on: -> { axe_steps }

Then "the page should be accessible within $inclusion_selector but excluding $exclusion_selector", :accessible_within_but_excluding, on: -> { axe_steps }

Then "the page should not be accessible within $inclusion_selector but excluding $exclusion_selector", :inaccessible_within_but_excluding, on: -> { axe_steps }



Then "the page should be accessible according to $tag", :accessible_according_to

Then "the page should not be accessible according to $tag", :inaccessible_according_to

Then "the page should be accessible within $inclusion_selector according to $tag", :accessible_within_according_to

Then "the page should not be accessible within $inclusion_selector according to $tag", :inaccessible_within_according_to

Then "the page should be accessible excluding $exclusion_selector according to $tag", :accessible_excluding_according_to

Then "the page should not be accessible excluding $exclusion_selector according to $tag", :inaccessible_excluding_according_to

Then "the page should be accessible within $inclusion_selector but excluding $exclusion_selector according to $tag", :accessible_within_but_excluding_according_to

Then "the page should not be accessible within $inclusion_selector but excluding $exclusion_selector according to $tag", :inaccessible_within_but_excluding_according_to



Then "the page should be accessible checking $rule", :accessible_checking

Then "the page should not be accessible checking $rule", :inaccessible_checking

Then "the page should be accessible within $inclusion_selector checking $rule", :accessible_within_checking

Then "the page should not be accessible within $inclusion_selector checking $rule", :inaccessible_within_checking

Then "the page should be accessible excluding $exclusion_selector checking $rule", :accessible_excluding_checking

Then "the page should not be accessible excluding $exclusion_selector checking $rule", :inaccessible_excluding_checking

Then "the page should be accessible within $inclusion_selector but excluding $exclusion_selector checking $rule", :accessible_within_but_excluding_checking

Then "the page should not be accessible within $inclusion_selector but excluding $exclusion_selector checking $rule", :inaccessible_within_but_excluding_checking



Then "the page should be accessible with options $options", :accessible_custom

Then "the page should not be accessible with options $options", :inaccessible_custom

Then "the page should be accessible within $inclusion_selector with options $options", :accessible_within_custom

Then "the page should not be accessible within $inclusion_selector with options $options", :inaccessible_within_custom

Then "the page should be accessible excluding $exclusion_selector with options $options", :accessible_excluding_custom

Then "the page should not be accessible excluding $exclusion_selector with options $options", :inaccessible_excluding_custom

Then "the page should be accessible within $inclusion_selector but excluding $exclusion_selector with options $options", :accessible_within_but_excluding_custom

Then "the page should not be accessible within $inclusion_selector but excluding $exclusion_selector with options $options", :inaccessible_within_but_excluding_custom
