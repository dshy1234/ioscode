//
//  CDbmManger.h
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface CDbManger : NSObject {
	
    sqlite3*    m_sql;
    NSString*    m_dbName;
}
@property(nonatomic)sqlite3*    m_sql;
@property(nonatomic,retain)NSString*    m_dbName;


-(id)initWithDbName:(NSString*)dbname;

-(BOOL)openOrCreateDatabase:(NSString*)DbName;

-(BOOL)createTable:(NSString*)sqlCreateTable;

-(void)closeDatabase;

-(BOOL)updateTable:(NSString*)sqlUpdate;

-(NSArray*)querryTable:(NSString*)sqlQuerry;

-(NSArray*)querryTableByCallBack:(NSString*)sqlQuerry;

@end
