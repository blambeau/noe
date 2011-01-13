require "wlang/rulesets/basic_ruleset"
require "wlang/rulesets/encoding_ruleset"
require "wlang/rulesets/imperative_ruleset"

WLang::dialect("noe") do 
  rules WLang::RuleSet::Basic
  rules WLang::RuleSet::Imperative
end