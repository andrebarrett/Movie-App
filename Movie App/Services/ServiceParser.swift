//
//  Copyright © 2018 iMobilize. All rights reserved.
//

import Foundation

protocol ServiceParser {
    func parseDataDictionary(_ dictionary: [String: AnyObject]) -> Bool
}
