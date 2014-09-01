//
//  CDbmManger.m
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CDbManger.h"

@implementation CDbManger

@synthesize m_sql;
@synthesize m_dbName;

- (id) initWithDbName:(NSString*)dbname
{
    self = [super init];
    if (self != nil) {
        if ([self openOrCreateDatabase:dbname]) {
            [self closeDatabase];
        }
    }
    return self;
}

- (id) init
{
    NSAssert(0,@"Never Use this.Please Call Use initWithDbName:(NSString*)");
    return nil;
}

- (void) dealloc
{
    self.m_sql = nil;
    self.m_dbName = nil;
    [super dealloc];
}


-(BOOL)openOrCreateDatabase:(NSString*)dbName
{
    self.m_dbName = dbName;
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    if(sqlite3_open([[documentsDirectory stringByAppendingPathComponent:dbName] UTF8String],&m_sql) != SQLITE_OK)
    {
        NSLog(@"Create Database failed");
        return    NO;
    }
    return YES;
}

-(BOOL)createTable:(NSString*)sqlCreateTable
{
    if (![self openOrCreateDatabase:self.m_dbName]) {
        return NO;
    }
    char *errorMsg;
    if (sqlite3_exec (self.m_sql, [sqlCreateTable  UTF8String],NULL, NULL, &errorMsg) != SQLITE_OK)
    {
        NSLog(@"Create Table failed:%s",errorMsg);
        return NO;
    }
    [self closeDatabase];
    return YES;
}


-(void)closeDatabase
{
    sqlite3_close(self.m_sql); 
}


-(BOOL)updateTable:(NSString*)sqlUpdate
{
    if (![self openOrCreateDatabase:self.m_dbName]) {
        return NO;
    }
    char* errorMsg = NULL;
    if(sqlite3_exec(self.m_sql, [sqlUpdate UTF8String],0, NULL, &errorMsg) == SQLITE_OK){
        [self closeDatabase];
		return YES;
	}
    else {
        printf("更新表失败:%s",errorMsg);
        [self closeDatabase];
        return NO;
    }
    
    
    return YES;
}

-(NSArray*)querryTable:(NSString*)sqlQuerry
{
    if (![self openOrCreateDatabase:self.m_dbName]) {
        return nil;
    }
    int row = 0;
    int column = 0;
    char*    errorMsg = NULL;
    char**    dbResult = NULL;
    NSMutableArray*    array = [[NSMutableArray alloc] init];
    if(sqlite3_get_table(m_sql, [sqlQuerry UTF8String], &dbResult, &row,&column,&errorMsg ) == SQLITE_OK)
    {
        if (0 == row) {
            [self closeDatabase];
            return nil;
        }
        int index = column;
        for(int i = 0; i < row ; i++ ) {  
            NSMutableDictionary*    dic = [[NSMutableDictionary alloc] init];
            for(int j = 0 ; j < column; j++ ) {
                if (dbResult[index]) {
                    NSString*    value = [[NSString alloc] initWithUTF8String:dbResult[index]];
                    NSString*    key = [[NSString alloc] initWithUTF8String:dbResult[j]];
                    [dic setObject:value forKey:key];
                    [value release];
                    [key release];
                    
                }
				
                index ++;
            } 
            [array addObject:dic];
            [dic release];
            
        }
        
    }else {
        printf("%s",errorMsg);
        [self closeDatabase];
        return nil;
    }
	
    [self closeDatabase];
    
    return [array autorelease];
}


int processData(void* arrayResult,int columnCount,char** columnValue, char** columnName)
{
    int i; 
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    for( i = 0 ; i < columnCount; i ++ ) 
    { 
        if (columnValue[i]) {
            NSString* key = [[NSString alloc] initWithUTF8String:columnName[i]];
            NSString* value = [[NSString alloc] initWithUTF8String:columnValue[i]];
            [dic setObject:value forKey:key];
            
        }
        
    } 
    
    [(NSMutableArray*)arrayResult addObject:dic];
    [dic release];
    
    return 0; 
}

-(NSArray*)querryTableByCallBack:(NSString*)sqlQuerry
{
    if (![self openOrCreateDatabase:self.m_dbName]) {
        return nil;
    }
    
    char*    errorMsg = NULL;
    NSMutableArray* arrayResult = [[NSMutableArray alloc] init];
    
    if (sqlite3_exec(self.m_sql,[sqlQuerry UTF8String],processData,(void*)arrayResult,&errorMsg) != SQLITE_OK) {
        printf("查询出错:%s",errorMsg);
    }
    [self closeDatabase];
    
    return [arrayResult autorelease];
}


@end
