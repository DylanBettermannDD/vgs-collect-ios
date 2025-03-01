//
//  VGSExpDateConfiguration.swift
//  VGSCollectSDK
//
//  Created by Dima on 22.01.2021.
//  Copyright © 2021 VGS. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// A class responsible for configuration `VGSTextField` with `fieldType = .expDate`. Extends `VGSConfiguration` class.
public final class VGSExpDateConfiguration: VGSConfiguration, VGSFormatSerializableProtocol {
       
  /// Input date format to convert.
  public var inputDateFormat: VGSCardExpDateFormat?
  
  /// Output date format.
  public var outputDateFormat: VGSCardExpDateFormat?
  
  /// Output date format.
  public var serializers: [VGSFormatSerializerProtocol] = []
  
  /// `FieldType.expDate` type of `VGSTextField` configuration.
  override public var type: FieldType {
    get { return .expDate }
    set {}
  }
  
  // MARK: - `VGSExpDateConfiguration` implementation
  
  /// Serialize Expiration Date
  internal func serialize(_ content: String) -> [String: Any] {
    var result = [String: Any]()
    for serializer in serializers {
      if let serializer = serializer as? VGSExpDateSeparateSerializer {
        /// remove dividers
        var dateDigitsString = content.digits
        
        /// get output date format, if not set - use default
        let outputDateFormat = outputFormat ?? .shortYear
        /// check output date components length
        let outputMonthDigits = outputDateFormat.monthCharacters
        let outputYearDigits = outputDateFormat.yearCharacters
        
        let mth: String
        let year: String
        if outputDateFormat.isYearFirst {
          /// take month digitis
          year = String(dateDigitsString.prefix(outputYearDigits))
          /// remove month digits
          dateDigitsString = String(dateDigitsString.dropFirst(outputYearDigits))
          /// take year digitis
          mth = String(dateDigitsString.prefix(outputMonthDigits))
        } else {
          /// take month digitis
          mth = String(dateDigitsString.prefix(outputMonthDigits))
          /// remove month digits
          dateDigitsString = String(dateDigitsString.dropFirst(outputMonthDigits))
          /// take year digitis
          year = String(dateDigitsString.prefix(outputYearDigits))
        }
        
        /// set result for specific fieldnames
        result[serializer.monthFieldName] = mth
        result[serializer.yearFieldName] = year
      }
    }
    return result
  }
  
  /// Returns if Content should be Serialized
  internal var shouldSerialize: Bool {
    return !serializers.isEmpty
  }
}

/// Implement `FormatConvertable` protocol.
extension VGSExpDateConfiguration: FormatConvertable {

  internal var outputFormat: VGSCardExpDateFormat? {
    return outputDateFormat
  }

  internal var inputFormat: VGSCardExpDateFormat? {
    return inputDateFormat
  }
  
  internal var convertor: TextFormatConvertor {
    return ExpDateFormatConvertor()
  }
}
