#import <UIKit/UIKit.h>
#import <AppList.h> //Using AppList to generate list of apps
#import <SBSearchTableViewCell.h>
#import <SBUIController.h>
#import <substrate.h>

ALApplicationList *apps;
ALApplicationTableDataSource *dataSource;

static UITableView *table = nil;
static CGFloat sectionHeaderWidth;
static CGFloat searchRowHeight;

// wildcat = iPad
static inline BOOL is_wildcat() { return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad); }

%hook UITableView
- (void)setAlpha:(float)alpha { 
    if (self != table) 
        %orig; 
}
%end

%hook SBSearchView
- (id)initWithFrame: (CGRect)frame withContent: (id)content onWallpaper: (id)wallpaper {
    if ((self = %orig)) {
        table = [self tableView];
        BOOL isWildcat = is_wildcat();
        sectionHeaderWidth = isWildcat ? 68.0f : 39.0f;
        searchRowHeight = isWildcat ? 72.0f : 44.0f;
        table.rowHeight = searchRowHeight;
    }
    return self;
}
%end

%hook SBApplicationController
- (void)loadApplications {
    // Gets the list of all the applications
    %orig;

    apps = [ALApplicationList sharedApplicationList];
    dataSource = [[ALApplicationTableDataSource alloc] init];
    dataSource.sectionDescriptors = [ALApplicationTableDataSource standardSectionDescriptors];
    //apps = [[ALApplicationTableDataSouce alloc] init];
    //apps.sectionDescriptors = [ALApplicationTableDataSource standardSectionDescriptors];
}
%end

%hook SBSearchController

%new(c@:)
-(BOOL)shouldGTFO { 
    SBSearchView *sv;
    object_getInstanceVariable(self, "_searchView", (void**)sv);
    //Ivar object_getInstanceVariable(id obj, const char *name, void **outValue)
    return ![[[sv searchBar] text] isEqualToString:@""]; 
    //UIView searchView = [[[objc_getClass("SBSearchController") sharedInstance] searchView] retain];
    //return ![[[[searchView searchBar] text] isEqualToStirng:@""];
    //return ![[[[objc_getClass("SBSearchController") sharedInstance] searchView] searchBar] text] isEqualToStirng:@""];
}
//returns false when there is no search term

- (BOOL)_hasSearchResults { return YES; }

- (BOOL)respondsToSelector: (SEL)selector { 
    return selector == @selector(tableView:heightForRowAtIndexPath:) ? NO : %orig; 
}

- (float)tableView: (id)tv heightForRowAtIndexPath: (id)ip { 
    return searchRowHeight; 
}

%new(i@:@i)
- (int)tableView: (UITableView *)tableView sectionForSectionIndexTitle: (NSString *)title atIndex: (NSInteger)index {
    // Asks the datasource to return the index for the section having the given title and section title index
   
    int idx = [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
    for (int i = 0; i < [apps applicationCount]; i++) {
        NSIndexPath *path = [NSIndexPath indexPathWithIndex:i];
        if (idx <= [[UILocalizedIndexedCollation currentCollation] sectionForObject:[dataSource displayIdentifierForIndexPath:path] collationStringSelector:@selector(displayName)]) return i;
    }
    return -1;
}

%new(@@:@)
- (NSArray *)sectionIndexTitlesForTableView: (UITableView *)tableView {
    //return the titles for the sections for a table view
    if ([self shouldGTFO]) {
        return nil;
    } else {
        id titles = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
        //titles = [titles subarrayWithRange:NSMakeRange(0, [titles count] - 1)];
        return titles;
    }
}

- (id)tableView: (id)tableView cellForRowAtIndexPath: (id)indexPath {
    // Asks the data source for a cell to insert in a particular 
    // location of the table view. (required)
    if ([self shouldGTFO]) return %orig;

    int s = [indexPath section];

    id cell = [tableView dequeueReusableCellWithIdentifier:@"dude"];
    if (cell) {
        [cell clearContents];
    } else {
        cell = [[[SBSearchTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"dude"] autorelease]; //Actually need a style
        //float f = sectionHeaderWidth;
        //void *fin = dynamic_cast<float *>(sectionHeaderWidth);
        //object_setInstanceVariable(cell, "_sectionHeaderWidth", f); //setInstanceVariable doesn't work on floats
        //MSHookIvar<float>(cell, "_sectionHeaderWidth") = sectionHeaderWidth;

        //Thanks caughtinflux! Broken substrate.h is a killer
        float *secWidth = &(MSHookIvar<float>(cell, "_sectionHeaderWidth")); 
        if (secWidth) {
            *secWidth = sectionHeaderWidth;
        }
        [cell setEdgeInset:0];
    }

    [cell setBadged:NO];
    [cell setBelowTopHit:YES];
    [cell setUsesAlternateBackgroundColor:NO];
    if (s == 0) {
        [cell setFirstInTableView:YES];
    }
    else {
        [cell setFirstInTableView:NO];
    }

    [cell setTitle:[[dataSource displayIdentifierForIndexPath:indexPath] description]];
    //[cell setAuxiliaryTitle:]; //It would be cool if it showed the last message etc; similiar to runninglist
    //[cell setSubtitle:]; //see above
    [cell setFirstInSection:YES];

    SBSearchView *sv;
    object_getInstanceVariable(self, "_searchView", (void**)sv);
    [[sv tableView] setScrollEnabled:YES];
    [cell setNeedsDisplay];

    return cell;
}
- (void)tableView: (id)tableView didSelectRowAtIndexPath: (id)indexPath {
    //This launches the app
    if ([self shouldGTFO]) { %orig; return; }

    id app = [dataSource displayIdentifierForIndexPath:indexPath];
    //SBUIController *sv;
    //object_getInstanceVariable(objc_getClass("SBUIController"), "_sharedInstance", (void**)sv);
    [[objc_getClass("SBUIController") sharedInstance] activateApplicationAnimated:app];
    //[[SBUIController sharedInstance] activateApplicationAnimated:app];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (int)tableView: (id)tableView numberOfRowsInSection: (int)s {
    if ([self shouldGTFO]) return %orig;
    else return 1;
}
- (int)numberOfSectionsInTableView: (id)tableView {
    if ([self shouldGTFO]) return %orig;
    return [apps applicationCount];
}
- (id)tableView: (id)tv viewForHeaderInSection: (int)s {
    //Asks the delegate for a view object to display in the 
    // header of the specified section of the table view.

    if ([self shouldGTFO]) return %orig;

    id v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sectionHeaderWidth, searchRowHeight)];
    NSIndexPath *path = [NSIndexPath indexPathWithIndex:s];
    //id m = [[[SBIconModel sharedInstance] applicationIconForDisplayIdentifier:[dataSource displayIdentifierForIndexPath:path]] getIconImage:is_wildcat()];
    //id i = [[UIImageView alloc] initWithImage:m];
    id i = [apps iconOfSize:ALApplicationIconSizeSmall forDisplayIdentifier:[dataSource displayIdentifierForIndexPath:path]];
    CGRect r = [i frame];
    r.size = [i size];
    CGSize size = [v frame].size;
    r.origin.y = (size.height - r.size.height) * 0.5f;
    r.origin.x = (size.width - r.size.width) * 0.5f;
    [i setFrame:r];
    [v addSubview:i];
    [i release];
    [v setOpaque:0];
    [v setUserInteractionEnabled:NO];

    return [v autorelease];
}
%end
