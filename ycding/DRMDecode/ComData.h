//
//  ComData.h
//  BookFMHD
//
//  Created by Ray Zhang on 9/21/11.
//  Copyright 2011 Showbox.mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALL_KINDS @"全部种类"

#pragma event name
#define EVENT_IMAGE_LOAD_COM        @"EVENTIMAGELOADCOM"
#define EVENT_BOOK_SEARCH_COM       @"EVENTBOOKSEARCHCOM"
#define EVENT_GOTO_PAGE             @"EVENTGOTOPAGE"
#define EVENT_GOTO_SEARCHPAGE       @"EVENTGOTOSEARCHPAGE"
#define EVENT_READING_END           @"EVENTREADINGEND"
#define EVENT_UPDATE_BOOKMARK       @"EVENTUPDATEBOOKMARK"


#pragma database status
#define STATUS_ADD                  1
#define STATUS_DELETE               2
#define STATUS_UPDATE               3
#define STATUS_FROME_SERVER         4


#pragma DownLoadStatus
#define DOWNLOAD_STATUS_LOADING     1
#define DOWNLOAD_STATUS_PAUSE       2
#define DOWNLOAD_STATUS_STOP        3
#define DOWNLOAD_STATUS_COM         4


#pragma const string
#define DEVICE_TYPE_IPAD   @"iPad"

@interface ComData : NSObject {
    
}

@end
