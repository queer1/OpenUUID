//
//  OpenUUIDAppDelegate.m
//  OpenUUID
//
//  Copyright (c) 2013 Cai, Zhi-Wei. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//


#import "OpenUUIDAppDelegate.h"

@implementation OpenUUIDAppDelegate

#pragma mark - Basic

+ (void) initialize
{
    // Hello world! :D
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    // Shut down the application when the main window closed.
	return YES;
}

#pragma mark - Main


- (IBAction)makeMeASandwish:(id)sender
{
    NSString *string_UUID;
    
    string_UUID = @"";
    
    [_textField_result setStringValue:@""];
    
    switch ([[_popUpBtn selectedItem] tag]) {
        case 0:
            string_UUID = [self getUUID];
            break;
        case 1:
            string_UUID = [self getHwUUID];
            break;
        case 2:
            string_UUID = [self getSystemSerialNumber];
            break;
        default:
            break;
    }
    
    [_textField_result setStringValue:string_UUID];
    
}

#pragma mark - UUID

// Random UUID.
- (NSString *)getUUID
{
    CFUUIDRef   uuidRef;
    CFStringRef uuidStringRef;
    
    uuidRef         = CFUUIDCreate(kCFAllocatorDefault);
    uuidStringRef   = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    
    if (uuidRef) CFRelease(uuidRef);
    return CFBridgingRelease(uuidStringRef);
}

// Hardare UUID shows in the system profiler.
- (NSString *)getHwUUID
{
    CFUUIDBytes uuidBytes;
    CFUUIDRef   uuid;
    CFStringRef uuidString;
    
    gethostuuid((unsigned char *)&uuidBytes, &(const struct timespec){0, 0});
    uuid        = CFUUIDCreateFromUUIDBytes(kCFAllocatorDefault, uuidBytes);
    uuidString  = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    
    if (uuid) CFRelease(uuid);
    return CFBridgingRelease(uuidString);
}

// Hardware serial number shows in "About this Mac" window.
- (NSString *)getSystemSerialNumber
{
    CFStringRef     serialNumber;
    io_service_t    ioPlatformExpertDevice;
    
    serialNumber = NULL;
    ioPlatformExpertDevice = IOServiceGetMatchingService(kIOMasterPortDefault,
                                                         IOServiceMatching("IOPlatformExpertDevice"));
    
    if (ioPlatformExpertDevice) {
        
        CFTypeRef serialNumberCFString;
        serialNumberCFString = IORegistryEntryCreateCFProperty(ioPlatformExpertDevice,
                                                               CFSTR(kIOPlatformSerialNumberKey),
                                                               kCFAllocatorDefault,
                                                               0);
        if (serialNumberCFString) serialNumber = serialNumberCFString;
        IOObjectRelease(ioPlatformExpertDevice);
    }
    return CFBridgingRelease(serialNumber);
}


#pragma mark - Misc

- (IBAction)goToGithub:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:define_githubURL]];
}

@end
