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

syn keyword ndpRuleName given ass premise tick contained
syn match ndpRuleName /forall \+I \+const/ contained
syn keyword ndpRuleName forallI forallE existsI existsE contained
syn match ndpRuleName /[\^E^I~E~I/E/I]/ contained
syn match ndpRuleName /[=sub]/ contained
syn match ndpRuleName /[forall\->E]/ contained

syn match ndpRuleParen /[()]/ contained
syn match ndpComment /--.*$/ containedin=ndpFormula " HACK

" Highlight section
hi def link ndpComment Comment
hi def link ndpKeyword Keyword
hi def link ndpBoolean Boolean
hi def link ndpOperator Operator
hi def link ndpRuleParen Operator
hi def link ndpRuleName Underlined

let b:current_syntax = "ndp"
