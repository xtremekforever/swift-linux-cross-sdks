// Import all modules we expect to have in Swift
import Dispatch
import DispatchIntrospection
import Distributed
import FoundationNetworking
import FoundationXML
import Glibc
import Observation
import RegexBuilder
import SwiftOverlayShims
import XCTest

#if canImport(FoundationInternationalization)
    import FoundationInternationalization
#endif

#if canImport(Synchronization)
    import Synchronization
#endif

#if canImport(Testing)
    import Testing
#endif

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

print("Hello, World!")
