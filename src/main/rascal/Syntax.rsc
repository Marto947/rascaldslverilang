module Syntax

layout Layout = [\ \t]*;

start syntax MainModule
    = mainModule: NL* 'defmodule' ID moduleName 
    NL*
    FileImport* fileImport
    Body body
    'end'
;

syntax FileImport
    = fileImport: 'using' ID importName NL+
;

// Falta añadir Equation y Relation que no se agregan al no tener reglas de producción definidas
syntax Body
    = body: (Statement NL*)* statements
;

syntax Statement
    = statement: Space space
    | Operator operator
    | Variables variables
    | Rule rule
    | Expression expression
    | AttributeList attributeList
;

syntax Space
    = space: 'defspace' ID spaceName ('\<' ID)? subspaceRelation 'end'
;

syntax Operator
    = operator: 'defoperator' ID operatorName ':' Domain domain ('-\>' Domain)+ range 'end'
;

syntax Domain
    = domain: 'bool' | 'int' | 'real' | ID domainName
;

syntax AttributeList
    = attributeList: '[' Attribute+ attributes ']'
;

syntax Attribute
    = attribute: ID operatorName (':' Domain)? attributeDomain
;

syntax Variables
    = variables: 'defvar' (ID ':' Domain)+ variableList 'end'
;

syntax Rule
    = rule: 'defrule' Invocation opApl1 '-\>' Invocation opApl2 'end'
;

syntax Invocation
    = invocation: '(' ID opName ID+ params ')'
;

//Expression ya sirve!
syntax Expression
    = expression: 'defexpression' TopExp topExp 'end'
;

syntax TopExp
    = exp: '(' Quantifier quantifier ID obj1 'in' ID obj2 (('.' TopExp) | AttributeList ) follow ')'
    | OrExp orExp
;

syntax OrExp
    = orExp: OrExp orExp 'or' AndExp andExp | AndExp andExp
;

syntax AndExp
    = andExp: AndExp andExp 'and' NotExp notExp | NotExp notExp
;

syntax NotExp
    = notExp: 'not' RelExp
    | RelExp
;

syntax RelExp
    = relExp: Primary obj1 RelOp relOp Primary obj2 
    | customInfix: Primary obj1 ID customOp Primary obj2
    | Primary primary
;

syntax Primary
    = primary: ID
    | Number
    | '(' OrExp ')'
;

syntax Number
    = number: INT | FLOAT
;

syntax RelOp
    = relOp: '=' | '\>=' | '\<=' | '≡' | '\<\>' 
;

syntax Quantifier
    = quantifier: 'forall' | 'exists' | 'defer'
;

//No utilizado todvía pero pertenece al lenguaje
syntax ArithOp
    = '+' | '-' | '*' | '/' | '**' | '%' 
;

lexical NL = "\n" | "\r\n";
lexical INT = ([\-0-9][0-9]* !>> [0-9]); 
lexical FLOAT = [0-9]+ "." [0-9]+;
lexical ID = ([a-zA-Z][a-zA-Z0-9_/.\-]* !>> [a-zA-Z0-9_/.\-]) \ Reserved;
keyword Reserved = "forall" | "exists" | "defer" | "not" | "and" | "or" | "in" 
| "defrule" | "defexpression" | "defvar" | "defoperator" | "defspace" | "defmodule" | "using"
| "bool" | "int" | "real" | "end" ;