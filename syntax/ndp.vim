" Vim syntax file
" Language: Natural Deduction Proof file
" Author: github user xiaoshihou514

if exists("b:current_syntax")
  finish
endif

scriptencoding utf-8

" Syntax section
syn match ndpFormula /^[^[]\+/ contains=ndpKeyword,ndpBoolean,ndpOperator,ndpPredAp
syn match ndpRule /\[.*/ contains=ndpRuleName,ndpRuleParen

syn keyword ndpKeyword forall exists contained
syn match ndpBoolean /\b$T\|F$\b/ contained
syn match ndpOperator /[\^~=\-><->\,.()/]/ contained

" IDK, viml!
syn match ndpRuleName /\<forall\>/ contained containedin=ndpRule
syn match ndpRuleName /\<I\>/ contained containedin=ndpRule
syn match ndpRuleName /\<const\>/ contained containedin=ndpRule
syn keyword ndpRuleName given ass premise tick refl LEM PC MT contained
syn keyword ndpRuleName forallI forallE existsI existsE contained
syn match ndpRuleName /[\^E^I~E~I/E/I]/ contained
syn match ndpRuleName /[\->I\->E<\->I<\->E]/ contained
syn match ndpRuleName /[=sub=sym]/ contained
syn match ndpRuleName /[forall\->E]/ contained
syn match ndpRuleName /[FEFITI]/ contained

syn match ndpRuleParen /[()]/ contained
" HACK: "override" formula and rule highlights
syn match ndpComment /--.*$/ containedin=ndpFormula,ndpRule

" Highlight section
hi def link ndpComment Comment
hi def link ndpKeyword Keyword
hi def link ndpBoolean Boolean
hi def link ndpOperator Operator
hi def link ndpRuleParen Operator
hi def link ndpRuleName Underlined

let b:current_syntax = "ndp"
