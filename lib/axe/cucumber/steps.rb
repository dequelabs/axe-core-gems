require 'axe/cucumber'

Then "the page should be accessible", :accessible

Then "the page should not be accessible", :inaccessible

Then "the page should be accessible within $selector", :accessible_within

Then "the page should not be accessible within $selector", :inaccessible_within

Then "the page should be accessible excluding $selector", :accessible_excluding

Then "the page should not be accessible excluding $selector", :inaccessible_excluding

Then "the page should be accessible within $selector but excluding $selector", :accessible_within_but_excluding

Then "the page should not be accessible within $selector but excluding $selector", :inaccessible_within_but_excluding



Then "the page should be accessible according to $tag", :accessible_according_to

Then "the page should not be accessible according to $tag", :inaccessible_according_to

Then "the page should be accessible within $selector according to $tag", :accessible_within_according_to

Then "the page should not be accessible within $selector according to $tag", :inaccessible_within_according_to

Then "the page should be accessible excluding $selector according to $tag", :accessible_excluding_according_to

Then "the page should not be accessible excluding $selector according to $tag", :inaccessible_excluding_according_to

Then "the page should be accessible within $selector but excluding $selector according to $tag", :accessible_within_but_excluding_according_to

Then "the page should not be accessible within $selector but excluding $selector according to $tag", :inaccessible_within_but_excluding_according_to



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
