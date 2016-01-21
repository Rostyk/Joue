//
//  Strings.h

#define LOC_STRING(name, val)           NSLocalizedStringWithDefaultValue(name, nil, [NSBundle mainBundle], val, val)

// Generic
#define LOC_OK                          LOC_STRING(@"LOC_OK", @"OK")
#define LOC_DELETE                      LOC_STRING(@"LOC_DELETE", @"Delete")
#define LOC_UPLOAD                      LOC_STRING(@"LOC_UPLOAD", @"Upload")
#define LOC_ERROR                       LOC_STRING(@"LOC_ERROR", @"Error")
#define LOC_DONE                        LOC_STRING(@"LOC_DONE", @"Done")
#define LOC_CANCEL                      LOC_STRING(@"LOC_CANCEL", @"Cancel")
#define LOC_YES                         LOC_STRING(@"LOC_YES", @"YES")
#define LOC_NO                          LOC_STRING(@"LOC_NO", @"NO")

// Errors
#define LOC_ERR_INTERNET_CONNECTION     LOC_STRING(@"LOC_ERR_INTERNET_CONNECTION", @"No internet connection!")
#define LOC_ERR_EMPTY_SERVER_ADDRESS    LOC_STRING(@"LOC_ERR_EMPTY_SERVER_ADDRESS", @"server address must not be empty")
#define LOC_ERR_INVALID_SERVER_ADDRESS  LOC_STRING(@"LOC_ERR_INVALID_SERVER_ADDRESS", @"please enter a valid server address")
#define LOC_ERR_EMPTY_PORT              LOC_STRING(@"LOC_ERR_EMPTY_PORT", @"port field must not me empty")
#define LOC_ERR_INVALID_PORT            LOC_STRING(@"LOC_ERR_INVALID_PORT", @"port number is not valid")
#define LOC_ERR_EMPTY_EMAIL             LOC_STRING(@"LOC_ERR_EMPTY_EMAIL", @"email field must not be empty")
#define LOC_ERR_EMPTY_PASSWORD          LOC_STRING(@"LOC_ERR_EMPTY_PASSWORD", @"password filed must not be empty")
#define LOC_ERR_LOGIN_FAILED            LOC_STRING(@"LOC_ERR_LOGIN_FAILED", @"Failed to login, please check your username/password and server address")
#define LOC_ERR_HOST_CONNECT            LOC_STRING(@"LOC_ERR_HOST_CONNECT", @"Can not connect to host")
#define LOC_ERR_NO_DATABASE             LOC_STRING(@"LOC_ERR_NO_DATABASE", @"No databases found on server")
#define LOC_ERR_UNREACHABLE_HOST        LOC_STRING(@"LOC_ERR_UNREACHABLE_HOST", @"host is not reachable")
#define LOC_ERR_SELECT_LEAVE_TYPE       LOC_STRING(@"LOC_ERR_SELECT_LEAVE_TYPE", @"please select leave type")
#define LOC_ERR_SELECT_START_DATE       LOC_STRING(@"LOC_ERR_SELECT_START_DATE", @"please select start date")
#define LOC_ERR_SELECT_END_DATE         LOC_STRING(@"LOC_ERR_SELECT_END_DATE", @"please select end date")
#define LOC_ERR_SELECT_ACTION           LOC_STRING(@"LOC_ERR_SELECT_ACTION", @"please select action")
#define LOC_ERR_SELECT_DATE             LOC_STRING(@"LOC_ERR_SELECT_DATE", @"please select date")

//
#define LOC_SELECT_DATE         LOC_STRING(@"LOC_SELECT_DATE", @"Select date")
#define LOC_CHOOSE_LEAVE_TYPE   LOC_STRING(@"LOC_CHOOSE_LEAVE_TYPE", @"Choose Leave Type")
#define LOC_SELECT_TIME_SHEET   LOC_STRING(@"LOC_SELECT_TIME_SHEET", @"Select Timsheet")
#define LOC_REQUEST_SUCCESS     LOC_STRING(@"LOC_REQUEST_SUCCESS", @"request created successfully")
#define LOC_SETUP_SIGN_OUT      LOC_STRING(@"LOC_SETUP_SIGN_OUT", @"Set Up Time and Date you want to Sign Out")
#define LOC_LAST_SIGN_IN        LOC_STRING(@"LOC_LAST_SIGN_IN", @"Last Sign In:")
#define LOC_PRESENT             LOC_STRING(@"LOC_PRESENT", @"Present")
#define LOC_SIGN_OUT            LOC_STRING(@"LOC_SIGN_OUT", @"Sign out")
#define LOC_WORKING_FOR         LOC_STRING(@"LOC_WORKING_FOR", @"Already working for:")
#define LOC_SETUP_SIGN_IN       LOC_STRING(@"LOC_SETUP_SIGN_IN", @"Set Up Time and Date you want to Sign In")
#define LOC_LAST_SIGN_OUT       LOC_STRING(@"LOC_LAST_SIGN_OUT", @"Last Sign Out:")
#define LOC_ABSENT              LOC_STRING(@"LOC_ABSENT", @"Absent")
#define LOC_SIGN_IN             LOC_STRING(@"LOC_SIGN_IN", @"Sign in")
#define LOC_NOT_WORKING_FOR     LOC_STRING(@"LOC_NOT_WORKING_FOR", @"Not working for:")
#define LOC_UNDEFINED           LOC_STRING(@"LOC_UNDEFINED", @"undefined")
#define LOC_CHOOSE_ACTION_TYPE  LOC_STRING(@"LOC_CHOOSE_ACTION_TYPE", @"Choose Action Type")
#define LOC_ATTENDANCE_SUCCESS  LOC_STRING(@"LOC_ATTENDANCE_SUCCESS", @"Attendance created successfully")
#define LOC_PREVIOUS_MONTH      LOC_STRING(@"LOC_PREVIOUS_MONTH", @"previous month")
#define LOC_TOTAL               LOC_STRING(@"LOC_TOTAL", @"Total")

// Menu
#define LOC_MENU_SIGN                   LOC_STRING(@"LOC_MENU_SIGN", @"Sign in/out")
#define LOC_MENU_SIGN_HISTORY           LOC_STRING(@"LOC_MENU_SIGN_HISTORY", @"Sign in/out history")
#define LOC_MENU_ATTENDANCE_ANALYSIS    LOC_STRING(@"LOC_MENU_ATTENDANCE_ANALYSIS", @"Attendance analysis")
#define LOC_MENU_LEAVE_REQUEST          LOC_STRING(@"LOC_MENU_LEAVE_REQUEST", @"Leave Request")
#define LOC_MENU_LOGOUT                 LOC_STRING(@"LOC_MENU_LOGOUT", @"Logout")

// Queries
#define LOC_TOTAL_QUERY         LOC_STRING(@"LOC_TOTAL_QUERY", @"Total: %@")
