//
//  AppRootComponent.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import ModernRIBs


final class AppComponent: Component<EmptyDependency>, AppRootDependency {
  
  init() {
    super.init(dependency: EmptyComponent())
  }
  
}
