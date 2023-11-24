import UIKit.UIApplication



public final class URLSchemeManager{
    
    public static let share = URLSchemeManager()
    
    //TODO: Set AppStoreAppID
    public static let RoutineAppStoreAppId = "6448030847" //나의 앱 -> 앱정보 -> 애플ID

    
    func openLink(url: String){
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }

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
    
    func openMailApp(email: String){
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    func openAppStore(appStoreAppID : String){
        let url = URL(string: "itms-apps://itunes.apple.com/app/id" + appStoreAppID)!
        UIApplication.shared.open(url)
    }    
    
}
