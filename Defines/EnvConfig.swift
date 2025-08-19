//
//  AppConfig.swift
//  UU Wallet
//
//  Created by Dev1 on 2024/6/25.
//

import Foundation
/*
 环境说明:
 
 DEBUG: 开发环境,一般用于日常开发和测试
 _baseURL = "http://13.228.216.76:10300/"
 
 RELEASE: 发布环境,一般用于内部测试或预发布
 _baseURL = "http://rel-forex-awssg-gateway.innotech-rel.com"
 
 STAGE: 预上线环境,一般生产环境的精确副本
 _baseURL = "https://forex-awssg-web.innotech-stage.com/"
 
 PROD: 生产环境,一般用于面向最终用户的实际运行环境
 _baseURL = "https://forex-gateway.uuwallet.com"
 
 
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 !!!!!!!!!!!!!!!!!isSafeTestEnvironment生产环境需保持为false!!!!!!!!!!!!!!!!
 !!!!!!!!!!!!!!!!!!是否启用加密开关(测试下注册按钮切换明文/密文)!!!!!!!!!!!!!!!!!
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
*/

enum UUEnvironment: String, CaseIterable {
    case dev
    case release
    case stage
    case prod
}

typealias Env = EnvConfig
struct EnvConfig {
    static let shared = EnvConfig()

    // MARK: isSecure

    // 有加密（密文传输）：1
    // 无加密（明文传输）：nil，或者0，或者其他非法值
    // 1 - 密文 0 - 明文

    private static let environmentKey = "APIEnvironment"
    private static let isSafeTestEnvironmentKey = "isSecure"
    private static let isPWRequstKey = "isPWRequstKey"

    static let channel = "iOS"
    static func useRSA() -> Bool {
#if DEBUG || STAGE
        let result = UserDefaults.standard.string(forKey: isSafeTestEnvironmentKey) == "1"
        JLog("use RSA result = \(result)")
        return result
#else
        return true
#endif
    }

    static func setUseRSA(_ useRSA: Bool) {
#if DEBUG || STAGE
        UserDefaults.standard.set(useRSA ? "1" : "0", forKey: isSafeTestEnvironmentKey)
#endif
    }

    // MARK: env

    static func getForceEnvironment() -> UUEnvironment? {
        var result: UUEnvironment?
#if DEBUG || STAGE
        let rawValue = UserDefaults.standard.string(forKey: environmentKey) ?? ""
        result = UUEnvironment(rawValue: rawValue)
        JLog("ForceEnvironment read from userDefaults: \(result.debugDescription)")
#endif
        return result
    }

    static func setForceEnvironment(_ environment: UUEnvironment?) {
#if DEBUG || STAGE
        JLog("ForceEnvironment set = \(environment.debugDescription)")
        if let environment {
            UserDefaults.standard.set(environment.rawValue, forKey: environmentKey)
        } else {
            UserDefaults.standard.removeObject(forKey: environmentKey)
        }
#endif
    }

    init() {
        var baseURL = Self._baseURL
        var publicKey = Self._publicKey
        var privateKey = Self._privateKey
        var environment = Self._environment
        var pwURL = Self._pwURL
        //var faqURL = Self._faqURL
        //var officVerifyURL = Self._officVerifyURL
#if DEBUG || STAGE
        if let forceEnvironment = Self.getForceEnvironment() {
            JLog("ForceEnvironment init force = \(forceEnvironment)")
            switch forceEnvironment {
            case .dev:
                baseURL = .dev
                publicKey = .dev
                privateKey = .dev
                environment = .dev
                pwURL = .dev
                //faqURL = .dev
                //officVerifyURL = .dev
            case .release:
                baseURL = .release
                publicKey = .release
                privateKey = .release
                environment = .release
                pwURL = .release
                //faqURL = .release
                //officVerifyURL = .release
            case .stage:
                baseURL = .stage
                publicKey = .stage
                privateKey = .stage
                environment = .stage
                pwURL = .stage
                //faqURL = .stage
                //officVerifyURL = .stage
            case .prod:
                baseURL = .prod
                publicKey = .prod
                privateKey = .prod
                environment = .prod
                pwURL = .prod
                //faqURL = .prod
                //officVerifyURL = .prod
            }
        }
#endif
        self.baseURL = baseURL.rawValue
        self.publicKey = publicKey.rawValue
        self.privateKey = privateKey.rawValue
        self.environment = environment
        self.pwURL = pwURL.rawValue
//        self.faqURL = faqURL.rawValue
//        self.officVerifyURL = officVerifyURL.rawValue
        self.isSafeTestEnvironment = environment != .prod
        JLog("ForceEnvironment init final environment = \(environment)")
    }
    private let environment: UUEnvironment
    
    // 内部环境为true，外部环境（prod）为false
    private var isSafeTestEnvironment: Bool
     
    private let baseURL: String
    private let publicKey: String
    private let privateKey: String
    private let pwURL: String
//    private let faqURL: String
//    private let officVerifyURL: String
    
    // 是否处于单元测试
    static var isRunningTests: Bool {
        return NSClassFromString("XCTestCase") != nil
    }

    // 内部环境为true，外部环境（prod）为false
    static var isSafeTestEnvironment: Bool {
#if DEBUG || STAGE || RELEASE
        if isRunningTests {
            JLog("isSafeTestEnvironment unit testing result = false")
        }
        JLog("isSafeTestEnvironment dev/stage/release result = true")
        return EnvConfig.shared.isSafeTestEnvironment
#else
        JLog("isSafeTestEnvironment PROD result = false")
        return false
#endif
    }

    static var environment: UUEnvironment {
        EnvConfig.shared.environment
    }

    static var baseURL: String {
        EnvConfig.shared.baseURL
    }

    static var publicKey: String {
        EnvConfig.shared.publicKey
    }

    static var privateKey: String {
        EnvConfig.shared.privateKey
    }
    
    static var pwURL: String {
        EnvConfig.shared.pwURL
    }
    
//    static var faqURL: String {
//        EnvConfig.shared.faqURL
//    }
//    
//    static var officVerifyURL: String {
//        EnvConfig.shared.officVerifyURL
//    }

    #if DEBUG
    private static let _environment: UUEnvironment = .dev
    private static let _baseURL: BaseURL = .dev
    private static let _publicKey: RSAPublicKey = .dev
    private static let _privateKey: RSAPrivateKey = .dev
    private static let _pwURL: PwURL = .dev
//    private static let _faqURL: FaqURL = .dev
//    private static let _officVerifyURL: OfficVerifyURL = .dev
    #elseif RELEASE
    private static let _environment: UUEnvironment = .release
    private static let _baseURL: BaseURL = .release
    private static let _publicKey: RSAPublicKey = .release
    private static let _privateKey: RSAPrivateKey = .release
    private static let _pwURL: PwURL = .release
//    private static let _faqURL: FaqURL = .release
//    private static let _officVerifyURL: OfficVerifyURL = .release
    #elseif STAGE
    private static let _environment: UUEnvironment = .stage
    private static let _baseURL: BaseURL = .stage
    private static let _publicKey: RSAPublicKey = .stage
    private static let _privateKey: RSAPrivateKey = .stage
    private static let _pwURL: PwURL = .stage
//    private static let _faqURL: FaqURL = .stage
//    private static let _officVerifyURL: OfficVerifyURL = .stage
    #elseif PROD
    private static let _environment: UUEnvironment = .prod
    private static let _baseURL: BaseURL = .prod
    private static let _publicKey: RSAPublicKey = .prod
    private static let _privateKey: RSAPrivateKey = .prod
    private static let _pwURL: PwURL = .prod
//    private static let _faqURL: FaqURL = .prod
//    private static let _officVerifyURL: OfficVerifyURL = .prod
    #endif

    static var macro: String {
#if DEBUG
        return "DEBUG"
#elseif RELEASE
        return "RELEASE"
#elseif STAGE
        return "STAGE"
#else
        return ""
#endif
    }
}
 
private enum BaseURL: String {
    case dev = "https://gateway.innotech-dev.com"
    case release = "https://gateway.innotech-rel.com"
    case stage = "https://gateway.innotech-stage.com" //https://gateway.innotech-stage.com
    case prod = "https://forex-gateway.uuwallet.com"
}

private enum PwURL: String {
    case dev = "https://powercard.innotech-dev.com"
    case release = "https://powercard.innotech-rel.com"
    case stage = "https://powercard.innotech-stage.com" //https://gateway.innotech-stage.com
    case prod = "https://pw.ulikewallet.com"
}

//private enum FaqURL: String {
//    case dev = "https://web.innotech-dev.com/faq/details"
//    case release = "https://web.innotech-rel.com/faq/details"
//    case stage = "https://web.innotech-stage.com/faq/details"
//    case prod = "https://www.uuwallet.com/faq/details"
//}
//
//private enum OfficVerifyURL: String {
//    case dev = "https://h5.innotech-dev.com/verify"
//    case release = "https://h5.innotech-rel.com/verify"
//    case stage = "https://h5.innotech-stage.com/verify"
//    case prod = "https://www.uuwallet.com/verify"
//}

private enum RSAPublicKey: String {
    // 公钥-dev
    case dev = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmrepWaH2zCbS9Sa79wXDiZAdUbXm9PZvNfllVszIXza2z88g4sy8iKESk7fB/bCCcknu7wLj4UXBO5W/fazQFm+5Q1Vh5udd3nsXZkymWyrxlk/bVF8JetgLk4+kDZWGvbs5lG2KzssvMLqL2dRVnViK4H8YJ2umqDTcHlpa6Ivb744OpflNg0cwfSv/oSI0PTr1DeYW3vOTEqBg2T8Z50bqQYHdH1bqki8W6Ns87XQ/3AxUqztf+hVDCuzOc8mNvJH9PL1GTtd33F1m0s0QMm8wB70glEWC48soddZrNF5mZgWxq+b6g2pQ66lyU0fsOrNUAbmgIYuW4QmgBtmqbwIDAQAB"

    // 公钥-rel
    case release = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlhopBl0ngBP5Bkm+PLe3OOrzvgwWSj1sXDQ6v1Ersr26UZ5JTQ32yPcXBe+HIuiHs1vAV0jN1lCuaU5FEwbmq2dlt+ZHRdYVQN8Rl0Fog0nc3W1IhnWbSZCEgbKRDJr+YO5lCjyCYVmlc6pXS0G1aGVrctBMe6azj9F+dngytOvLGmX60tLjlZruKbF1Pgi7E9tLiG6XY0Ul+TL7ubPP1A5XBJU2Fd5o8KgmLTQ6d7MnqlaFeLikhFw35+ATIFcIXaDR6Hq8q3JQxZB6iYIGpqWa13U47RFZ7qTOQA31BAWZeBwS9kgMansM4nW3IgvlZI1aN+E+zFl6R9ZAVeeK9QIDAQAB"

    // 公钥-Stage
    case stage = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAw9QpvRxevcEy2EoVVN6DKE/oVtmsJX7wV560tXO0S5PY3LyXObAWWPhxXqi+J2G6/vxJ6QJcQJn9nNo6CeUZXNZvT7KG2/Aojm3jZA0cC2wNMqHRcwW0CPyIFhDsctESBNppMEgwBsbWHbyJKFrjPfzJAKGrR4y5/Qb1E81H34aDgO5RwBN7rH+edajteKUrJ3g6DpsxGm/PyJ3Nq+nRcEyOOcMAArtAeua4r9O+gUPX9kXmVgCNMk+SzS/AWirPXRBMeeDf3sNCAmXGe+ZM9Rc1Fc9KPLPhUa63aHrVMO0Q3w2Nos/h5W9Nv7RsCnH2bzalSLgOunTtfmEy0M+/pQIDAQAB"

    // 公钥-prod
    case prod = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAl7HzbmEOoGJGE1FSXzFqfMNVdH0ef90RDVH5+IlgS4Aj0NplGZqvleOU7x6k8jb3jr3lC3VXBnVzBHIRkxTsw9yDlyuape2V4zZf2zisPOWvPSHDgxZPKsBOg1jfoN156G1Duxq1O/6dEhsdDWmp3PAwh5n2GN+dKsoVPPqyMNP6tqt3rBi4F2ojSewWATHixCBP8F56Vfut3Yk3u1+AJSPCPCJbRiBKhLMm3QzP1I3rpKDsp9yhgu6QTZYEroMuqr1/fOuyRLC80D8uXYEjmuzgu+sU2QplV5HyxoLBBtX+cKhrQQa9PqfJU8QSD9kAebqr59iBDg3PNkzQ2PHwjQIDAQAB"

}

private enum RSAPrivateKey: String {
    case dev = "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCK28IiUKCBHcAyuUKt4HiiRWbkHNJM5CXqEPrBUSl1MW/QtlLCrZth1hK5/oU0bHFWxm19gjF45QLBdSIo4hzwTD2iIe5keejzE+xb4uc2g1zXzAU8aHfP9zW/CrP3Ayb47C5rE47rX1JRuhvGu7Um+L+G+F10xhk6GPZU+Nt2XNksDgkds3iCUF5wkXp7+dzw0oyDQWlI6gwyI9Xe0Juufkhgm1JQ+0OMt3W3gUd5Z/FBkGtyjcjOYoQikxT7/zzGbehdh2ylZeG0BcrbBPRBRENYGeiff+BQ8Gd7SrEzQCpV5qYQEHARYZ7glVN7tFEVMaPQ4muFSPyrFBSMIQZTAgMBAAECggEAaORsl8NUG3S/1RFBH1urhNjsSnDDI7ZMNa4x3YpTyOVZU84GYm0GLTeq2bk8Ikewrh4iY2bPvEUyebTj4wI7XgIZpLoA/QFiSQzJxPd4NSOyJIlHg0RfDUfu36tUGsnUzMCMp/IUShSteHMfvFXbF99bvrcq0aU7NTnaCoIaNiP62zAy2+AogWWXO4hR3aJPW+Zg8GYtiY2UYVcThvWmpH5szm87PLhw+Ong9yfN+zroVuQ2yuKuYEYLTtetambsq/uVJlC01eM+d5XoywQ7dcGZgypHKIlKZogJPHbmo1BHIa3uXBnvepqfRCa632xgtQwMsHAbtb3BoXaJPIhqkQKBgQDQXxNINGIKYKpx8HTCP49+tHmGv8b/abeZYZHBWSBk2QV4eHAkM3xMfCce00qZ4LBm3b+zxjMFk1G1xrrrjs8GHv+damhgHhg14ubk2Y3/lDS0WxdYPkZqq9STOCJOr1X7zrMhfWOAz+EMYpu6dpbDspJs+tuEqhzdifOVEEvfjwKBgQCqmRum2+txqRFyvxkvjdFhpcb8kLvRXhG0m1+N20OHwBbQMSng89Q3n7nqZYngBQlO3yc95hO0j4HjwI0rWYlTljW0cMJDZqxksyMDP6WbXGrVAuKtZ/RzoRAKTtf9RkqUM8vg8FUxlnvA4hO02ZlzcI8swp7zpnNfQ+rMOj6K/QKBgDjtkMYMUbDGIisI581eMiUKx5zx7js/tcJ47qplYD1NMXptZS3uxwnabZG1Zk9OHMOt178U6kGesxc3mT/b/2GLvIhUVvnTnwex2yUw7uOhqRiRPnqEYRappWUnU/AtZQ9rtHL03+eEY9bPZf52gdArjGerzaecFlDMbLkP/7qvAoGBAIW/C4LBn9C4L8m6MFCr6p+XjG2uOtFl4pOpzDw2zra6zifio2aNQq9pNiSh/nn2+Nkw8l8A5ioE6FxaNVLrG1LAzNHuJR8ae8Vm++gsGfW3eroNTRGOEoQknaK3NXaHiSivgwOS5/e8dsE9fR2oCzoJ4PXCj0OOF510bbw3XZkxAoGAfcJqUkDxqm3/+oCzPDz8lJQm2nLNkDDzWCYpsKxO1CLY8H+CqihnbNgsy8iiHEJ05Jq/r4IugnI8rhVqsOJ7xUFBcumWDLkbapOF2rYo6xG1xnwLrK2xGchbBaayzLDU+tVChJ4jPVohfSk7PznVZnRAIdpe/Vj1FO4+iz25pW8="
    // 私钥-rel
    case release = "MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDSX079rpDZZrp+dyGifZnkzjW6NLweyu7JgdUXuY0uGTOuXVK3tCANhdpUOWqAOqZR4556j+8NnR0q9Ffrjc3endFAyVf0hIIiVQxDq53lvvZ+zIfFBkQq675T2rNGlFdk9u3KSlCfFWStZZcE/5mkW9zb+hZUDlhE1WClkncp99uoHkiCMnXCJTf6nOfoFd08NY0D12IbxZ80bMnJDoJLlCxiJTOsLu7Tg32k+h5/M+Bk5ssvRLizUnRT88oEZTXaaGaqXotN/ZFGhN14DkguIRLVtv8t3nvLbZqlfT84+RhDY8oO2e9ps2f0RvdfNIqL1cZYNOcJ7ZBBb5cLD6FPAgMBAAECggEAJ8Uf1EJ7nLXYfM79u0++V6yKKK0OgU3A7bRPOiB4aaYXCJgY6qSxSI0s9K40DZDI34NF8wqh2TOCD5xIwL26lSLFq9dEevPP/DiSzHo1q/i5dcgpxJwGKA0QGp8mNCoYCXzLAGqjKifrtAIYFjhR7en161owfWyG0GB8WGDDiVm72ljF6hoJ8dCPBr335J374I1XOW1bCUYFcGyVm7SYCtLpegus6qX5rwa/267GSJ0yJI6HxrK1FmtVqZbHFcIRRKsIwKtG0NXMe0ezt1Ya8xF8PSnIkSPr7mu1zGon4LT1dDzlD9kC09169ShAEn3UiKXasMdJ24yvjRpAlMtn0QKBgQDrlDV3fP4jg9YMWEKZeY5t8Z9YMVNeEOO2ZUehol85g73gyXLbnGQlyHNds1GJgEYRjtqL3qOVW1qSRP32DSlLgDLUs+0+TtQak8NObOyi/S28N+IurzkgLkG7nAFvufAlOFGvmpjG8r8eKd7y7EX3GUFoNKcvCKoXjfwhmJCE3wKBgQDkm7uZ58AvkxFCEU+0Ia/puikctBaY8f47x/wr+mE52oG6JyRR6w5gWHIuiyX5W01A+K9p2CVU87mapl38H3YJ+MIGtnsQbqJ3zVW1yQEYft7q06LrcL19iPM1ru40Cybdl2I0zeiFn/PzcuqUeRdnpKhnTM6YwYn9tfx6ucCBkQKBgEmdG4QGE+gHJ1jeL5mDyYUDjtZhO3rWbkGtrk+MzJLNXwUiDfkgCo9f7uTlxuHfqoWMDTDN1nIyhL/WPUGo5TGJktiyjLz+pvrTF6GnGd7onGUHVW9fI8uxiKrWWgCOqsMGsUfdWEY6zovfa6KfQFGxm6WzZlalL3mCzbm10dsjAoGACyfGScZTTH8CspShrQqPyPn6k5n+GEyGuWgS2BqJsAcHmYvba9vqga0PNVI48igQZwE7nhCcEb8q6W8A2xK18dqfrTAuZSjg6LOuYQaD9SwLuK3HH3IK7RtHsvDsUsHQjbObaTQ7Cno5r0GGTORzzeztAs1ur2mSUD0XKu3xhOECgYARvDSVPwYcBSIG7PS/oAv3LY3aeDa6xDtP6wCz3mLWU3crHROKncioqeM5Ukw4H7jL2v4OSKQd1WVKnUUWoIGB45iWRnZ2rOeWD+ZUitDu3pWMgAv3g5Q/EmJFFOiAtBKNDfa9jTdP7GD4J+V15KAUCMeNpHmEPg36rmAxFQPWWw=="
    case stage = "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDcZ+a2hSmsqaQdamfRNtvRyl6tgQz46dukkQuD+QvL3QHhxV+FsFOIQGXGs/KBmaHgw//pWoZmEKmEJrtdDmvEDAvpSPN4sHOddxRuAp0XybsJbu2uDbU4VuBkpV1yYoWRSh+ZqkaM/ldCFBUFqxRORI8LtvBdogZ4iuPK90e4cGk7H73BGOVU1bGTyHy4szZTekgKXPYB1ceiQAtXWIDAV24/c6n6M3Qy/o7T4gWwK6WEb2DO5y9Wg6sz9X8muLVOrUi6vuWW2UoueKstrVytoAqqVRsHa2DDJ3OzhcapxcvPLUvucvUXrtj3VuSRkQPfTCqCFqamGJljlP4GfWJRAgMBAAECggEACK7btRxXJVccEPAalbCPdar/Mp7rScmdxnST42+97hq/eptl3VySV+NwlwTLFJ2+tb4HAJSZR59XrE4B0uNQ7czrMbY26E3sShtxPbnC4ldnU9Jv0Ov3lBgBGFn27d0RhcUprEo75A1XlvH3V40zPDeheozLGKc70ccn/PyjsdGCKLne8NZ5WCx5Mf/9vjVntNTsS1uQvM1ZG/DosjrZwH9IRJRZN2mrFMo3AaI0iPd5GEGXDOODwme0MCOGDk1aX/UJug27DN53T1GEXEN3JgfJ2qZ9v/fwMOjVNMgqTKN++ifTLQrZJPxp6IhoP9vqXmNg8+pmMZEL7qO+uNdn+QKBgQD5cNSODo0tFwfoToP9rTFIvUZ3sMUMBB+PJTIqnFtc3+NN9XWrW+ByX8OR/BQO88CH02aLR+SLJiKJwipvZGSTqHtX4fnVZIOJggisiXPSuHZaMcfd8OKbtvB6f38XF496XMkfGZ8aEmbd1oqVLFwE802bBOANiZZpyLmLOjE5KQKBgQDiM52gr6RBG22lVJFzrz5dKN+oacTrgP5zKIMmSOJYjer/Evzvwb7fnx7/SYlbsZKieLW2tJOzFQ3Yck4fSAhiz7Ynt/3a549OMsT5xID8twmZn0xwlufwxtri4epk+meimcl2xnkJs2mUVjj3SLvbrhxlflfqO+20cFDFsYz86QKBgQC1rzgyzGiJ+id5To8XG6o1GCAWl/u+V9aA1g/nN4HYcP7ITsxJZx9hT11MnLYjeem3RQSA2Hmf3MP1YSa1ggM8BdDpXyAxDQg+BSe6PFfPmSojYfT5NDZqQuJ/5xOzxyZrct/PNkNLozGnzVeddfUEag8RpYhoc9nJ7TkwLs+hmQKBgGz/qkkv2dp1uRQd+CjinQ6PD5c7wGQrOHGNaAUewdMiL8bSA4gUuEFRj8I8UTAaFSqtOALeaP22e4F9Mx/nugLDTGc/RdgiFO/9juU8R1t/Z+Ta2h622PUxHXCOpEAcWawEpwvQ/6opBgswsSqXpc5py80sYHjCf/ye0o0wzVthAoGBANWOlWyvYFgP51SZI6ufP12nXZ/8JHZOJVkcIB+sSxjuuuN6JG/KzJlwagN9mnrZAwTjwmkA4X9XUhtJc1rga/18WqKxFv7oqjgehW5jMOuhNHqXBScmVJgaDeR/Du+3sCJR3yK56E9zFCo64ondO0dhJeN4f/qTopoP3ZI/Z1g4"
    case prod = "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC/8EsMGqkyVdb4dYmNcjCnQeBxhRkN3QbyfaUjiWtA4VDgZkFSpdqGOcrUN+cT3w1vLcMLphckX1vCmN7xvha3pXEuHLGO6U7EzLAOT5e67aVh19wORbRbBaWpT5jK2jFKSvUh1fOrcFtzNBqDWvzaOOurWw4L0HigcG26mxNjs51n5huMgGdTqu/v+y6TWKVWaaNputnn8pcH3Rc5aiJUvyJnuSwyOczDLrPYJ/zWdHUpArpL1DjaEZ5H+9G5wXxBz6wsPfvvC+OkA19e8sUzlh6fuEzFX1qIrPVkAM536WHKS9BOxrPBcNg6qW/0K4g1F3anJ2+7Ed/UB9hHHqqPAgMBAAECggEABQ/w4sZXPREfhNkQwi7HUrn9kfDpOsDgHIgs0VWgAwuORwTbZzMhotWmYFeDHDaPU6XY1ZdRV++961F929FgJwLRi95M3pCPt8gQQqhdv5vh90UqtCOpgJcTCfaj+IGtuCBm+7f5X8WsW8r9ggZl0dmbeZ8CrVQXwl+EvV22srPvw3lQMY1lJeBIT9A92dU3059xgXKE/laGNWf+i4QrxjJOglIAKvxri2jDSdf5+UAtobVNpd0Tz582HBx43Vtf/2ZPj9Y+r6iveojipMV9fG4bHbPzsAaUSASjehNuRxy0eBcugRtXoKTHI4+/icCY2XYh7GvEXS/POY/2WN3bUQKBgQDDkapcuDVaMDCqc5QcN/QkPMhCRNLJFrsZLxzg/q4udbXdVV7EAmrpIGq73H0le0HO4zSBJFc9llAvhYEpuoQgNTowk4WZyr5ZUVrbWsMsN8Jwzclxt6x4BJbVJR90IpHTj2yOgY5vC11Y0G8EaHMjWdK2kYdmuNuO2KWYvQmZPwKBgQD7P3NogPiG6j7HghjGEl3Q4N22nfqWbejXPQ/mUzawWtcbEKYEN7gAnZw/R64gaZ2ZVI058bFPlMQQcWEclMpgmYjTU7tXkQf8CP77lpF1AYPq3iRDi4x65uJwHd3R7AqtSc7zjy+3t5I75xkB8lZVS/q299PnZUTX/7mky3DKsQKBgQCpIsaKz8lciYbdM34pdX7RBDxRi8IcpWsEmclJERnFFopFtHpz3H9nxWBpvoQBMXs1mSwkcDB/FAufPb/6PdPdIwuDTWJjIoPDLWf9g55+FG82LdOFZMtlNNrZ1fRA9VDW/hhtmsB7awG9OO56inbhYOKqgGvwu/kurlFxKjQt8wKBgAoylRiUw4GWWF34pdDERhKITfdvihA4/c5eqBqNHhciWMC8eECLkmhT/VeELUkbgE4M5H6JlMzKGPsh3vMuBtjM4oTRTTVMqapNIyxK/DRnj1clFQu4ykbiwCYU0EAI+JX3/PJdyW4HgWP1CUrO7zofD1oFzRADSDwMIRjTOQzBAoGBAKKHdaEnYkBIE8/Mk5MUtTEj+pz/aUf+mUyGSYWVk6MG0ltprg0nKVctQeTcTIgLcQyRPZ0o1tSEjpSMoFwSLmf3vIa/N+HsaSpQ5AQHL0y1MkLADv+fvzIl4wX3Xn+Uu+5/061jNDlOP0OoIsHrVSfI/rzA0L1UYephekJndz4u"
}
