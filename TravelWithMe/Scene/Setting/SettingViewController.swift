//
//  SettingViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/15/23.
//

import UIKit

class SettingViewController: BaseViewController {
    
    let mainView = SettingView()
    let viewModel = SettingViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingNavigationItem()
        settingTableView()
    }
    
    func settingTableView() {
        mainView.settingTableView.delegate = self
        mainView.settingTableView.dataSource = self
    }
    
    func settingNavigationItem() {
        navigationItem.title = "설정"
    }
    
//    func removeKeyChainAndGotoLogin() {
//        
//        // 1. 키체인 초기화
//        KeychainStorage.shared.removeAllKeys()
//        
//        // 2. 로그인 화면으로 돌아가기
//        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//        let sceneDelegate = windowScene?.delegate as? SceneDelegate
//        
//        let vc = UINavigationController(rootViewController: LoginViewController())
//        sceneDelegate?.window?.rootViewController = vc
//        sceneDelegate?.window?.makeKeyAndVisible()
//        
//    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
        
        cell.textLabel?.text = viewModel.settingList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        print(viewModel.settingList[indexPath.row])
        
        
        // 로그아웃
        if indexPath.row == 0 {
            
            showDoubleButtonAlert("로그아웃", message: "로그아웃 하시겠습니까?") {
                
                // 1. 키체인 초기화
                KeychainStorage.shared.removeAllKeys()
                
                // 2. 로그인 화면으로 전환
                self.showNoButtonAlert("로그아웃 되었습니다", message: "로그인 화면으로 돌아갑니다") {
                    
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    
                    let vc = UINavigationController(rootViewController: LoginViewController())
                    sceneDelegate?.window?.rootViewController = vc
                    sceneDelegate?.window?.makeKeyAndVisible()
                    
                }
                
            }
        }
        
        
        // 회원 탈퇴
        if indexPath.row == 1 {
            
            showDoubleButtonAlert("회원 탈퇴", message: "회원 탈퇴 하시겠습니까?") {
                
                self.viewModel.withdraw { response in
                    switch response {
                    case .success(let result):
                        print("(Withdraw) 네트워크 응답 성공! \n1. 키체인 초기화 \n2. 로그인 화면으로 돌아감")
                        
                        
                        // 1. 키체인 초기화
                        KeychainStorage.shared.removeAllKeys()
                        
                        
                        // 2. 로그인 화면으로 돌아감
                        let nickStruct = decodingStringToStruct(type: ProfileInfo.self, sender: result.nick)
                        self.showNoButtonAlert("회원 탈퇴 완료", message: "정상적으로 탈퇴가 완료되었습니다. \(nickStruct?.nick ?? "회원")님, 감사합니다") {
                        
                            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                            let sceneDelegate = windowScene?.delegate as? SceneDelegate
                            
                            let vc = UINavigationController(rootViewController: LoginViewController())
                            sceneDelegate?.window?.rootViewController = vc
                            sceneDelegate?.window?.makeKeyAndVisible()
                        }
                    case .failure(let error):
                        print("(Withdraw) 네트워크 응답 실패")
                        
                        // 1. 공통 에러
                        if let commonError = error as? CommonAPIError {
                            print("(Withdraw) 네트워크 응답 실패! - 공통 에러")
                            self.showAPIErrorAlert(commonError.description)
                        }
                        
                        // 2. 회원 탈퇴 에러
                        if let withdrawError = error as? WithdrawAPIError {
                            print("(Withdraw) 네트워크 응답 실패! - 회원 탈퇴 에러")
                            self.showAPIErrorAlert(withdrawError.description)
                        }
                        
                        // 3. 토큰 관련 에러
                        if let refreshTokenError = error as? RefreshTokenAPIError {
                            print("(Withdraw) 네트워크 응답 실패! - 토큰 에러")
                            if refreshTokenError == .refreshTokenExpired {
                                print("- 리프레시 토큰 만료!!")
                                self.goToLoginViewController()
                            } else {
                                self.showAPIErrorAlert(refreshTokenError.description)
                            }
                        }
                        
                        // 4. 알 수 없는 에러
                        print("(Withdraw) 알 수 없는 에러")
                        self.showAPIErrorAlert(error.localizedDescription)
                        
                        
                    }
                }
                
                
            }
            
        }
        
    }
}
