@import "CCModelSharedFunctions.j"

/*
	@global
	@group CCModelAssociation
*/

CCModelAssociationHasOne = 0;
CCModelAssociationHasMany = 1;
CCModelAssociationBelongsTo = 2;
CCModelAssociationHasAndBelongsToMany = 3;

@implementation CCModelAssociation : CPObject
{
	CCModelAssociationType associationType @accessors;
	CPString modelName @accessors;
	CPString foreignTable @accessors;
	CPString foreignKey @accessors;
	CPString associatedForeignKey @accessors;
	CCModel  associatedModel @accessors;
}

- (id)initWithAssociationType:(CCModelAssociationType)assocType
{
	if (self = [super init])
	{
		modelName = nil;
		[self setAssociationType:assocType];
	}
	return self;
}

+ (id)associationWithType:(CCModelAssociationType)assocType
{
	return [[self alloc] initWithAssociationType:assocType];
}

+ (id)habtmAssociationWithModelName:(CPString)aModelName
{
	var association = [self associationWithType:CCModelAssociationHasAndBelongsToMany];
	[association setModelName:aModelName];
	return association;
}

- (CPString)foreignKey
{
	if ((foreignKey == nil || [foreignKey isEqual:@""]) && modelName != nil)
		return CCModelRawName(modelName)+"_id";
	return foreignKey;
}

- (CPString)foreignTable
{
	if ((foreignTable == nil || [foreignTable isEqual:@""]) && modelName != nil)
		return CCModelTableName(modelName);
	return foreignKey;
}

- (CPString)associatedForeignKey
{
	if ((associatedForeignKey == nil || [associatedForeignKey isEqual:@""]) && associatedModel != nil)
		return CCModelRawName([associatedModel name])+"_id";
	return associatedForeignKey;
}

@end