module AST

data MainModule 
    = mainModule(str moduleName, list[FileImport] fileImports, Body body)
;

data FileImport
    = fileImport(str importName)
;

data Body
    = body(list[Statement] statements)
;

data Statement
    = defspace(Space space)
    | defoperator(Operator operator)
    | defvariable(Variables variables)
    | defrule(Rule rule)
    | defexpression(Expression expression)
    | defattribute(AttributeList attributeList)
;

data Space
    = space(str spaceName)
    | subspace(str subSpace, str superSpace)
;

data Operator
    = operator(str operatorName, Domain domain, list[Domain] rangeList)
;

data Domain
    = boolDomain()
    | intDomain()
    | realDomain()
    | nameDomain(str domainName);

data AttributeList
    = attributeList(list[Attribute] attributes)
;

data Attribute
    = withDomain(str operatorName, Domain domain)
    | noDomain(str operatorName)
;

data Variables
    = Variables(list[VarDecl] variableList)
;

data VarDecl
    = varDecl(str varName, Domain domain)
;

data Rule
    = rule(Invocation firstInv, Invocation secondInv)
;

data Invocation
    = invocation(str opName, list[str] params)
;

data Expression
    = expression(TopExp topExp)
;

data TopExp
    = quantExp(Quantifier quantifier, str obj1, str obj2, FollowExp follow)
    | orExpRec(OrExp orExp)
;

data FollowExp
    = nextExp(TopExp topExp)
    | attributes(AttributeList attributes)
;

data OrExp
    = orExp(list[AndExp] andTerms)
;

data AndExp
    = andExp(list[NotExp] notTerms)
;

data NotExp
    = negated(RelExp exp)
    | plain(RelExp exp)
;

data RelExp
    = withRelOp(Primary obj1, RelOp relOp, Primary obj2)
    | customInfix(Primary obj1, str customOp, Primary obj2)
    | onlyPrimary(Primary primary)
;

data Primary
    = primaryStr(str id)
    | primaryNum(Number number)
    | grouped(OrExp orExp)
;

data Number
    = intNumber(int val)
    | floatNumber(num val);

data RelOp
    = eq()
    | ge()
    | le()
    | equiv()
    | iff()
;

data Quantifier
    = forall()
    | exists()
    | defer()
;

