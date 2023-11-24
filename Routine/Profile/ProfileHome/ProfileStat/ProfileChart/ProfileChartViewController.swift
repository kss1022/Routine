//
//  ProfileChartViewController.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs
import UIKit

protocol ProfileChartPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ProfileChartViewController: UIViewController, ProfileChartPresentable, ProfileChartViewControllable {

    weak var listener: ProfileChartPresentableListener?
}
