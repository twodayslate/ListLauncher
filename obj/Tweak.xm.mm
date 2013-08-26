#line 1 "Tweak.xm"
#import <UIKit/UIKit.h>
#import <AppList.h> 

static ALApplicationTableDataSource *apps = nil;
static id app_id = nil; 
static UITableView *table = nil;
static CGFloat sectionHeaderWidth;
static CGFloat searchRowHeight;

static inline BOOL is_wildcat() { return (BOOL)(int)[[UIDevice currentDevice] isWildcat]; }

#include <logos/logos.h>
#include <substrate.h>
@class SBApplicationController; @class SBSearchView; @class UITableView; @class SBSearchController; 
static void (*_logos_orig$_ungrouped$UITableView$setAlpha$)(UITableView*, SEL, float); static void _logos_method$_ungrouped$UITableView$setAlpha$(UITableView*, SEL, float); static id (*_logos_orig$_ungrouped$SBSearchView$initWithFrame$withContent$onWallpaper$)(SBSearchView*, SEL, CGRect, id, id); static id _logos_method$_ungrouped$SBSearchView$initWithFrame$withContent$onWallpaper$(SBSearchView*, SEL, CGRect, id, id); static void (*_logos_orig$_ungrouped$SBApplicationController$loadApplications)(SBApplicationController*, SEL); static void _logos_method$_ungrouped$SBApplicationController$loadApplications(SBApplicationController*, SEL); static BOOL _logos_method$_ungrouped$SBSearchController$shouldGTFO(SBSearchController*, SEL); static BOOL (*_logos_orig$_ungrouped$SBSearchController$_hasSearchResults)(SBSearchController*, SEL); static BOOL _logos_method$_ungrouped$SBSearchController$_hasSearchResults(SBSearchController*, SEL); static BOOL (*_logos_orig$_ungrouped$SBSearchController$respondsToSelector$)(SBSearchController*, SEL, SEL); static BOOL _logos_method$_ungrouped$SBSearchController$respondsToSelector$(SBSearchController*, SEL, SEL); static float (*_logos_orig$_ungrouped$SBSearchController$tableView$heightForRowAtIndexPath$)(SBSearchController*, SEL, id, id); static float _logos_method$_ungrouped$SBSearchController$tableView$heightForRowAtIndexPath$(SBSearchController*, SEL, id, id); static int _logos_method$_ungrouped$SBSearchController$tableView$sectionForSectionIndexTitle$atIndex$(SBSearchController*, SEL, UITableView *, NSString *, NSInteger); static NSArray * _logos_method$_ungrouped$SBSearchController$sectionIndexTitlesForTableView$(SBSearchController*, SEL, UITableView *); static id (*_logos_orig$_ungrouped$SBSearchController$tableView$cellForRowAtIndexPath$)(SBSearchController*, SEL, id, id); static id _logos_method$_ungrouped$SBSearchController$tableView$cellForRowAtIndexPath$(SBSearchController*, SEL, id, id); static void (*_logos_orig$_ungrouped$SBSearchController$tableView$didSelectRowAtIndexPath$)(SBSearchController*, SEL, id, id); static void _logos_method$_ungrouped$SBSearchController$tableView$didSelectRowAtIndexPath$(SBSearchController*, SEL, id, id); static int (*_logos_orig$_ungrouped$SBSearchController$tableView$numberOfRowsInSection$)(SBSearchController*, SEL, id, int); static int _logos_method$_ungrouped$SBSearchController$tableView$numberOfRowsInSection$(SBSearchController*, SEL, id, int); static int (*_logos_orig$_ungrouped$SBSearchController$numberOfSectionsInTableView$)(SBSearchController*, SEL, id); static int _logos_method$_ungrouped$SBSearchController$numberOfSectionsInTableView$(SBSearchController*, SEL, id); static id (*_logos_orig$_ungrouped$SBSearchController$tableView$viewForHeaderInSection$)(SBSearchController*, SEL, id, int); static id _logos_method$_ungrouped$SBSearchController$tableView$viewForHeaderInSection$(SBSearchController*, SEL, id, int); 

#line 12 "Tweak.xm"

static void _logos_method$_ungrouped$UITableView$setAlpha$(UITableView* self, SEL _cmd, float alpha) { 
    if (self != table) 
        _logos_orig$_ungrouped$UITableView$setAlpha$(self, _cmd, alpha); 
}



static id _logos_method$_ungrouped$SBSearchView$initWithFrame$withContent$onWallpaper$(SBSearchView* self, SEL _cmd, CGRect frame, id content, id wallpaper) {
    if ((self = _logos_orig$_ungrouped$SBSearchView$initWithFrame$withContent$onWallpaper$(self, _cmd, frame, content, wallpaper))) {
        table = [self tableView];
        BOOL isWildcat = is_wildcat();
        sectionHeaderWidth = isWildcat ? 68.0f : 39.0f;
        searchRowHeight = isWildcat ? 72.0f : 44.0f;
        table.rowHeight = searchRowHeight;
    }
    return self;
}



static void _logos_method$_ungrouped$SBApplicationController$loadApplications(SBApplicationController* self, SEL _cmd) {
    
    
    _logos_orig$_ungrouped$SBApplicationController$loadApplications(self, _cmd);

    [apps release];

    apps = [ALApplicationList sharedApplicationList];

    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        apps = [[ALApplicationTableDataSource alloc] init];
        apps.sectionDescriptors = [ALApplicationTableDataSource standardSectionDescriptors];
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
}




static BOOL _logos_method$_ungrouped$SBSearchController$shouldGTFO(SBSearchController* self, SEL _cmd) { return ![[[[self searchView] searchBar] text] isEqualToString:@""]; }


static BOOL _logos_method$_ungrouped$SBSearchController$_hasSearchResults(SBSearchController* self, SEL _cmd) { return YES; }

static BOOL _logos_method$_ungrouped$SBSearchController$respondsToSelector$(SBSearchController* self, SEL _cmd, SEL selector) { 
    return selector == @selector(tableView:heightForRowAtIndexPath:) ? NO : _logos_orig$_ungrouped$SBSearchController$respondsToSelector$(self, _cmd, selector); 
}

static float _logos_method$_ungrouped$SBSearchController$tableView$heightForRowAtIndexPath$(SBSearchController* self, SEL _cmd, id tv, id ip) { 
    return searchRowHeight; 
}


static int _logos_method$_ungrouped$SBSearchController$tableView$sectionForSectionIndexTitle$atIndex$(SBSearchController* self, SEL _cmd, UITableView * tableView, NSString * title, NSInteger index) {
    int idx = [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
    for (int i = 0; i < [apps count]; i++) {
        if (idx <= [[UILocalizedIndexedCollation currentCollation] sectionForObject:[apps objectAtIndex:i] collationStringSelector:@selector(displayName)])
            return i;
    }
    return -1;
}


static NSArray * _logos_method$_ungrouped$SBSearchController$sectionIndexTitlesForTableView$(SBSearchController* self, SEL _cmd, UITableView * tableView) {
    if ([self shouldGTFO]) {
        return nil;
    } else {
        id titles = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
        
        return titles;
    }
}
static id _logos_method$_ungrouped$SBSearchController$tableView$cellForRowAtIndexPath$(SBSearchController* self, SEL _cmd, id tv, id ip) {
    
    if ([self shouldGTFO]) return _logos_orig$_ungrouped$SBSearchController$tableView$cellForRowAtIndexPath$(self, _cmd, tv, ip);

    int s = [ip section];

    id cell = [tv dequeueReusableCellWithIdentifier:@"dude"];
    if (cell) {
        [cell clearContents];
    } else {
        cell = [[[objc_getClass("SBSearchTableViewCell") alloc] initWithStyle:(UITableViewCellStyle)0 reuseIdentifier:@"dude"] autorelease];
        MSHookIvar<float>(cell, "_sectionHeaderWidth") = sectionHeaderWidth;
        [cell setEdgeInset:0];
    }

    [cell setBadged:NO];
    [cell setBelowTopHit:YES];
    [cell setUsesAlternateBackgroundColor:NO];
    if ([ip section] == 0) [cell setFirstInTableView:YES];
    else [cell setFirstInTableView:NO];

    
    [cell setTitle:[[dataSource displayIdentifierForIndexPath:indexPath] displayName]];
    
    
    [cell setFirstInSection:YES];

    [[[self searchView] tableView] setScrollEnabled:YES];
    [cell setNeedsDisplay];

    return cell;
}
static void _logos_method$_ungrouped$SBSearchController$tableView$didSelectRowAtIndexPath$(SBSearchController* self, SEL _cmd, id tv, id ip) {
    
    if ([self shouldGTFO]) { _logos_orig$_ungrouped$SBSearchController$tableView$didSelectRowAtIndexPath$(self, _cmd, tv, ip); return; }

    id a = [apps objectAtIndex:[ip section]];
    [[objc_getClass("SBUIController") sharedInstance] activateApplicationAnimated:a];
    [tv deselectRowAtIndexPath:ip animated:YES];
}

static int _logos_method$_ungrouped$SBSearchController$tableView$numberOfRowsInSection$(SBSearchController* self, SEL _cmd, id tv, int s) {
    if ([self shouldGTFO]) return _logos_orig$_ungrouped$SBSearchController$tableView$numberOfRowsInSection$(self, _cmd, tv, s);
    else return 1;
}
static int _logos_method$_ungrouped$SBSearchController$numberOfSectionsInTableView$(SBSearchController* self, SEL _cmd, id tv) {
    if ([self shouldGTFO]) return _logos_orig$_ungrouped$SBSearchController$numberOfSectionsInTableView$(self, _cmd, tv);

    return [apps count];
}
static id _logos_method$_ungrouped$SBSearchController$tableView$viewForHeaderInSection$(SBSearchController* self, SEL _cmd, id tv, int s) {
    if ([self shouldGTFO]) return _logos_orig$_ungrouped$SBSearchController$tableView$viewForHeaderInSection$(self, _cmd, tv, s);

    id v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sectionHeaderWidth, searchRowHeight)];
    id m = [[[objc_getClass("SBIconModel") sharedInstance] applicationIconForDisplayIdentifier:[[apps objectAtIndex:s] displayIdentifier]] getIconImage:is_wildcat()];
    id i = [[UIImageView alloc] initWithImage:m];
    CGRect r = [i frame];
    r.size = [m size];
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

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$UITableView = objc_getClass("UITableView"); MSHookMessageEx(_logos_class$_ungrouped$UITableView, @selector(setAlpha:), (IMP)&_logos_method$_ungrouped$UITableView$setAlpha$, (IMP*)&_logos_orig$_ungrouped$UITableView$setAlpha$);Class _logos_class$_ungrouped$SBSearchView = objc_getClass("SBSearchView"); MSHookMessageEx(_logos_class$_ungrouped$SBSearchView, @selector(initWithFrame:withContent:onWallpaper:), (IMP)&_logos_method$_ungrouped$SBSearchView$initWithFrame$withContent$onWallpaper$, (IMP*)&_logos_orig$_ungrouped$SBSearchView$initWithFrame$withContent$onWallpaper$);Class _logos_class$_ungrouped$SBApplicationController = objc_getClass("SBApplicationController"); MSHookMessageEx(_logos_class$_ungrouped$SBApplicationController, @selector(loadApplications), (IMP)&_logos_method$_ungrouped$SBApplicationController$loadApplications, (IMP*)&_logos_orig$_ungrouped$SBApplicationController$loadApplications);Class _logos_class$_ungrouped$SBSearchController = objc_getClass("SBSearchController"); { const char *_typeEncoding = "c@:"; class_addMethod(_logos_class$_ungrouped$SBSearchController, @selector(shouldGTFO), (IMP)&_logos_method$_ungrouped$SBSearchController$shouldGTFO, _typeEncoding); }MSHookMessageEx(_logos_class$_ungrouped$SBSearchController, @selector(_hasSearchResults), (IMP)&_logos_method$_ungrouped$SBSearchController$_hasSearchResults, (IMP*)&_logos_orig$_ungrouped$SBSearchController$_hasSearchResults);MSHookMessageEx(_logos_class$_ungrouped$SBSearchController, @selector(respondsToSelector:), (IMP)&_logos_method$_ungrouped$SBSearchController$respondsToSelector$, (IMP*)&_logos_orig$_ungrouped$SBSearchController$respondsToSelector$);MSHookMessageEx(_logos_class$_ungrouped$SBSearchController, @selector(tableView:heightForRowAtIndexPath:), (IMP)&_logos_method$_ungrouped$SBSearchController$tableView$heightForRowAtIndexPath$, (IMP*)&_logos_orig$_ungrouped$SBSearchController$tableView$heightForRowAtIndexPath$);{ const char *_typeEncoding = "i@:@i"; class_addMethod(_logos_class$_ungrouped$SBSearchController, @selector(tableView:sectionForSectionIndexTitle:atIndex:), (IMP)&_logos_method$_ungrouped$SBSearchController$tableView$sectionForSectionIndexTitle$atIndex$, _typeEncoding); }{ const char *_typeEncoding = "@@:@"; class_addMethod(_logos_class$_ungrouped$SBSearchController, @selector(sectionIndexTitlesForTableView:), (IMP)&_logos_method$_ungrouped$SBSearchController$sectionIndexTitlesForTableView$, _typeEncoding); }MSHookMessageEx(_logos_class$_ungrouped$SBSearchController, @selector(tableView:cellForRowAtIndexPath:), (IMP)&_logos_method$_ungrouped$SBSearchController$tableView$cellForRowAtIndexPath$, (IMP*)&_logos_orig$_ungrouped$SBSearchController$tableView$cellForRowAtIndexPath$);MSHookMessageEx(_logos_class$_ungrouped$SBSearchController, @selector(tableView:didSelectRowAtIndexPath:), (IMP)&_logos_method$_ungrouped$SBSearchController$tableView$didSelectRowAtIndexPath$, (IMP*)&_logos_orig$_ungrouped$SBSearchController$tableView$didSelectRowAtIndexPath$);MSHookMessageEx(_logos_class$_ungrouped$SBSearchController, @selector(tableView:numberOfRowsInSection:), (IMP)&_logos_method$_ungrouped$SBSearchController$tableView$numberOfRowsInSection$, (IMP*)&_logos_orig$_ungrouped$SBSearchController$tableView$numberOfRowsInSection$);MSHookMessageEx(_logos_class$_ungrouped$SBSearchController, @selector(numberOfSectionsInTableView:), (IMP)&_logos_method$_ungrouped$SBSearchController$numberOfSectionsInTableView$, (IMP*)&_logos_orig$_ungrouped$SBSearchController$numberOfSectionsInTableView$);MSHookMessageEx(_logos_class$_ungrouped$SBSearchController, @selector(tableView:viewForHeaderInSection:), (IMP)&_logos_method$_ungrouped$SBSearchController$tableView$viewForHeaderInSection$, (IMP*)&_logos_orig$_ungrouped$SBSearchController$tableView$viewForHeaderInSection$);} }
#line 168 "Tweak.xm"