//
//  ServerStatusCode.swift
//  WithPeace
//
//  Created by Dylan_Y on 5/3/24.
//


enum StatusCode: Int {
    case informationalResponse = 100
    case successRequest = 200
    case redirection = 300
    case clientErrors = 400
    case serverErrors = 500
}

/////400
//enum BadRequest: Int {
//    case NOT_END_POINT = 40000
////    case NOT_FOUND_RESOURCE = 40000
//    case INVALID_ARGUMENT = 40001
//    case INVALID_PROVIDER = 40002
//    case METHOD_NOT_ALLOWED = 40003
//    case UNSUPPORTED_MEDIA_TYPE = 40004
//    case MISSING_REQUEST_PARAMETER = 40005
//    case METHOD_ARGUMENT_TYPE_MISMATCH = 40006
//}
//
/////401
//enum Unauthorized: Int {
//    case EXPIRED_TOKEN_ERROR = 40100
//    case INVALID_TOKEN_ERROR = 40101
//    case TOKEN_MALFORMED_ERROR = 40102
//    case TOKEN_TYPE_ERROR = 40103
//    case TOKEN_UNSUPPORTED_ERROR = 40104
//    case TOKEN_GENERATION_ERROR = 40105
//    case FAILURE_LOGIN = 40106
//    case FAILURE_LOGOUT = 40107
//    case TOKEN_UNKNOWN_ERROR = 40108
//}
//
/////402
//enum Forbidden: Int {
//    case ACCESS_DENIED_ERROR = 40300
//}
//
/////403
//enum NotFound: Int {
//    case NOT_FOUND_USER = 40401
//    case NOT_FOUND_POST = 40402
//}
//
/////500
//enum InternalServerError: Int {
//    case SERVER_ERROR = 50000
//    case AUTH_SERVER_USER_INFO_ERROR = 50001
//}
//
//enum ServerStatusCode1 {
//    ///400
//    enum BadRequest: Int {
//        case NOT_END_POINT = 40000
//    //    case NOT_FOUND_RESOURCE = 40000
//        case INVALID_ARGUMENT = 40001
//        case INVALID_PROVIDER = 40002
//        case METHOD_NOT_ALLOWED = 40003
//        case UNSUPPORTED_MEDIA_TYPE = 40004
//        case MISSING_REQUEST_PARAMETER = 40005
//        case METHOD_ARGUMENT_TYPE_MISMATCH = 40006
//    }
//
//    ///401
//    enum Unauthorized: Int {
//        case EXPIRED_TOKEN_ERROR = 40100
//        case INVALID_TOKEN_ERROR = 40101
//        case TOKEN_MALFORMED_ERROR = 40102
//        case TOKEN_TYPE_ERROR = 40103
//        case TOKEN_UNSUPPORTED_ERROR = 40104
//        case TOKEN_GENERATION_ERROR = 40105
//        case FAILURE_LOGIN = 40106
//        case FAILURE_LOGOUT = 40107
//        case TOKEN_UNKNOWN_ERROR = 40108
//    }
//
//    ///402
//    enum Forbidden: Int {
//        case ACCESS_DENIED_ERROR = 40300
//    }
//
//    ///403
//    enum NotFound: Int {
//        case NOT_FOUND_USER = 40401
//        case NOT_FOUND_POST = 40402
//    }
//
//    ///500
//    enum InternalServerError: Int {
//        case SERVER_ERROR = 50000
//        case AUTH_SERVER_USER_INFO_ERROR = 50001
//    }
//}
//
//struct Errorororor {
//    ///400
//    enum BadRequest: Int {
//        case NOT_END_POINT = 40000
//    //    case NOT_FOUND_RESOURCE = 40000
//        case INVALID_ARGUMENT = 40001
//        case INVALID_PROVIDER = 40002
//        case METHOD_NOT_ALLOWED = 40003
//        case UNSUPPORTED_MEDIA_TYPE = 40004
//        case MISSING_REQUEST_PARAMETER = 40005
//        case METHOD_ARGUMENT_TYPE_MISMATCH = 40006
//    }
//
//    ///401
//    enum Unauthorized: Int {
//        case EXPIRED_TOKEN_ERROR = 40100
//        case INVALID_TOKEN_ERROR = 40101
//        case TOKEN_MALFORMED_ERROR = 40102
//        case TOKEN_TYPE_ERROR = 40103
//        case TOKEN_UNSUPPORTED_ERROR = 40104
//        case TOKEN_GENERATION_ERROR = 40105
//        case FAILURE_LOGIN = 40106
//        case FAILURE_LOGOUT = 40107
//        case TOKEN_UNKNOWN_ERROR = 40108
//    }
//
//    ///402
//    enum Forbidden: Int {
//        case ACCESS_DENIED_ERROR = 40300
//    }
//
//    ///403
//    enum NotFound: Int {
//        case NOT_FOUND_USER = 40401
//        case NOT_FOUND_POST = 40402
//    }
//
//    ///500
//    enum InternalServerError: Int {
//        case SERVER_ERROR = 50000
//        case AUTH_SERVER_USER_INFO_ERROR = 50001
//    }
//}
//
//enum AllCase: Int {
//    
//    ///400
//    case NOT_END_POINT = 40000
//    //    case NOT_FOUND_RESOURCE = 40000
//    case INVALID_ARGUMENT = 40001
//    case INVALID_PROVIDER = 40002
//    case METHOD_NOT_ALLOWED = 40003
//    case UNSUPPORTED_MEDIA_TYPE = 40004
//    case MISSING_REQUEST_PARAMETER = 40005
//    case METHOD_ARGUMENT_TYPE_MISMATCH = 40006
//    
//    // 401
//    case EXPIRED_TOKEN_ERROR = 40100
//    case INVALID_TOKEN_ERROR = 40101
//    case TOKEN_MALFORMED_ERROR = 40102
//    case TOKEN_TYPE_ERROR = 40103
//    case TOKEN_UNSUPPORTED_ERROR = 40104
//    case TOKEN_GENERATION_ERROR = 40105
//    case FAILURE_LOGIN = 40106
//    case FAILURE_LOGOUT = 40107
//    case TOKEN_UNKNOWN_ERROR = 40108
//    
//    // 403
//    case ACCESS_DENIED_ERROR = 40300
//    
//    //403
//    case NOT_FOUND_USER = 40401
//    case NOT_FOUND_POST = 40402
//    
//    //500
//    case SERVER_ERROR = 50000
//    case AUTH_SERVER_USER_INFO_ERROR = 50001
//}
