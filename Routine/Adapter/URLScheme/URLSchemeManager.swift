import UIKit.UIApplication



public final class URLSchemeManager{
    
    public static let share = URLSchemeManager()

    func openSettingApp(){
        if let url = URL(string: UIApplication.openSettingsURLString){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func openCallApp(phoneNumber : String){
        if let url = URL(string: "tel:\(phoneNumber)") {
            UIApplication.shared.open(url)
        }
    }
    
    func openMessageApp(phoneNumber : String){
        if let url = URL(string: "sms:\(phoneNumber)") {
            UIApplication.shared.open(url)
        }
    }
    
    func openAppStore( appStoreAppID : String){
        let url = URL(string: "itms-apps://itunes.apple.com/app/id" + appStoreAppID)!
        UIApplication.shared.open(url)
    }    
    
}
