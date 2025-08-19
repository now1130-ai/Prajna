//
//  CameraController.swift
//  shopga
//
//  Created by gogo on 2025/7/30.
//

import SnapKit
import UIKit
import Photos
import QMUIKit
import FirebaseAI

class CameraController: BaseVC {
    
    private var image: UIImage?
    
    override func initView() {
        super.initView()
        
        view.addSubview(img)
        img.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(navView.snp.bottom).offset(22)
            make.width.height.equalTo(100)
        }
        
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { make in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(btnHeight)
            make.bottom.equalTo(view).offset(-22)
        }
        
//        Task {
//            await gemini()
//        }
    }
    
    func imgAction() {
        
        CameraHandler.shared.showActionSheet()
        CameraHandler.shared.imagePickedBlock = { [weak self] image in

            self?.showLoading()
//            CommonLoadingView.shared.showLoading(self!.view)
            let zipImage = UIImage.compressImageSize(image: image, maxLength: 100 * 1024 * 1024)
            self?.image = zipImage
            let dataImg = zipImage.jpegData(compressionQuality: 1.0)
            if dataImg == nil { return }
            self?.img.image = zipImage
            
            Task {
                await self?.geminiImg(image: zipImage)
                self?.dismissLoading()
            }
        
//            let data = "{\"data\":[{\"brand\":\"Apple\",\"model\":\"MacBook Pro\",\"review\":\"The image prominently features a modern Apple MacBook Pro laptop, characterized by its Space Gray finish and the distinctive display notch. The screen displays a vibrant purple and blue wallpaper, and the macOS dock is visible at the bottom. The keyboard appears to be a full-size, black Magic Keyboard. The large trackpad is also clearly visible. Two small astronaut figurines are present on the right side of the laptop, adding a personal touch to the setup.\"}]}"
////            
//        guard let jsonData = data.data(using: .utf8) else {
//               fatalError("Could not convert string to Data")
//           }
//            
//        do {
//                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
//                    
//                    let result = jsonObject["data"]
//                    guard let dataList = result as? [[String: Any]] else { return }
//                    let brands = BaseJsonUtil.parseModelArray(dataList, modelType: BrandModel.self) ?? []
//
//                    let vc = BrandDetailController()
//                    vc.list = brands
////                        vc.image = zipImage
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            } catch {
//                print("Error parsing JSON: \(error)")
//            }
        
//            do {
//                let result = jsonData["data"] as? Any
//                guard let dataSource = result as? [[String: Any]] else { return }
//                
//                    if let dataList = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
//                        let brands = BaseJsonUtil.parseModelArray(dataList, modelType: BrandModel.self) ?? []
//                        
//                        let vc = BrandDetailController()
//                        vc.list = brands
////                        vc.image = zipImage
//                        self.navigationController?.pushViewController(vc, animated: true)
//
//                    } else {
//                        print("Failed to cast JSON object to [[String: Any]].")
//                    }
//                } catch {
//                    print("Error decoding JSON: \(error)")
//                }
            
//            FileApi.manager.uploadImage(imageData: data!) { [weak self] resp in
//                CommonLoadingView.shared.dismissLoading()
//                JLog(resp)
//                guard let url = resp as? String else {
//                    ErrorAlert.showErrorInView(self?.view, error: "uu.Image upload failed".localized)
//                    return
//                }
//                self?.avatarUrl = url
//                self?.showAvatar()
//            } fail: { [weak self] _, _ in
//                ErrorAlert.showErrorInView(self?.view, error: "uu.Image upload failed".localized)
//                CommonLoadingView.shared.dismissLoading()
//            }
        }
    }
    
    func gemini() async{
        
        // Initialize the Gemini Developer API backend service
        let ai = FirebaseAI.firebaseAI(backend: .googleAI())

        // Create a `GenerativeModel` instance with a model that supports your use case
        let model = ai.generativeModel(modelName: "gemini-2.5-flash")

        // Provide a prompt that contains text
        let prompt = "Write a story about a magic backpack."

        // To generate text output, call generateContent with the text input
        let response = try? await model.generateContent(prompt)
        print(response?.text ?? "No text in response.")
    }
    
    func geminiImg(image: UIImage) async{
        // Initialize the Gemini Developer API backend service
        let ai = FirebaseAI.firebaseAI(backend: .googleAI())

        // Create a `GenerativeModel` instance with a model that supports your use case
//        let model = ai.generativeModel(modelName: "gemini-2.5-flash")
        
        /*
         https://firebase.google.com/docs/ai-logic/generate-structured-output?hl=zh-cn&api=dev
         */
        let jsonSchema = Schema.object(
          properties: [
            "data": Schema.array(
              items: .object(
                properties: [
                  "brand": .string(),
                  "model": .string(),
                  "review": .string(),
//                  "accessory": .enumeration(values: ["hat", "belt", "shoes"]),
                ],
//                optionalProperties: ["accessory"]
              )
            ),
          ]
        )
        
        // Create a `GenerativeModel` instance with a model that supports your use case
        let model = ai.generativeModel(
          modelName: "gemini-2.5-flash",
          // In the generation config, set the `responseMimeType` to `application/json`
          // and pass the JSON schema object into `responseSchema`.
          generationConfig: GenerationConfig(
            responseMIMEType: "application/json",
            responseSchema: jsonSchema,
          )
        )
        

        // Provide a text prompt to include with the image
//        let prompt = "What's in this picture?"
        let prompt = "请问图片里包含哪些品牌"
//        let prompt = "请问图片里包含哪些品牌，并已销售顾问的角色给出评价和推荐，以参考如下json要求返回：[{\"brand\":\"Apple\",\"model\":\"MacBook Pro\",\"review\":\"您正在寻找一款兼具卓越性能与优雅设计的笔记本电脑吗？Apple 的 MacBook Pro 绝对是您的理想之选。它专为创意专业人士和开发者量身打造，配备了色彩精准的 Retina 显示屏和强劲的处理器，无论是进行高强度的图形设计、视频剪辑，还是复杂的编程任务，都能轻松应对。macOS 操作系统与硬件的完美结合，为您带来了无与伦比的流畅体验和系统稳定性。MacBook Pro 不仅仅是一台电脑，更是一项经久耐用、保值性高的优质投资，是您提升工作效率和品味的不二之选。\"},{\"brand\":\"Logitech\",\"model\":\"未知型号\",\"review\":\"想要为您的桌面增添震撼的音效体验吗？Logitech（罗技）的音响产品将是您的绝佳选择。作为电脑外设领域的领导品牌，Logitech 以其高性价比和可靠的音质而广受好评。无论是沉浸在音乐的海洋，还是享受电影的震撼音效，抑或是投身于激烈的游戏世界，Logitech 的扬声器都能为您提供清晰、有力的声音表现。其简约而现代的设计风格，能够完美融入您的桌面环境，为您带来视听双重享受。如果您在预算内追求高品质的音响体验，Logitech 绝对值得您的信赖。\"}]"

        
        // To generate text output, call generateContent and pass in the prompt
        let response = try? await model.generateContent(image, prompt)
        
        print(response?.text ?? "No text in response.")
        if !isEmptyStr(response?.text) {
            showDetail(jsonStr: (response?.text)!, image: image)
        }
    }
    
    func showDetail(jsonStr: String, image: UIImage) {
        guard let jsonData = jsonStr.data(using: .utf8) else {
           fatalError("Could not convert string to Data")
       }
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                
                let result = jsonObject["data"]
                guard let dataList = result as? [[String: Any]] else { return }
                let brands = BaseJsonUtil.parseModelArray(dataList, modelType: BrandModel.self) ?? []

                let vc = BrandDetailController()
                vc.list = brands
                vc.image = image
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
    // MARK: - setter & getter
    
    lazy var img: UIImageView = {
        let v = UIImageView(image: UIImage(named: "ic_avatar_default_g"))
        v.setViewCorner(radius: 30)
        
        return v
    }()
    
    lazy var loginBtn: BaseButton = {
        let btn = BaseButton.creat(backgroundColor: .theme, font: .creat(type: .MB, size: 18),textColor: .white)
        btn.setTitle("btn".localized, for: .normal)
        btn.setViewCorner(radius: 24)
        btn.tapHandler = { [weak self] _ in
            self?.imgAction()
        }
        return btn
    }()

}

class CameraHandler: NSObject {
    static let shared = CameraHandler()

    var imagePickedBlock: ((UIImage) -> Void)?

    private func openCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .camera
                myPickerController.modalPresentationStyle = .fullScreen
                myPickerController.allowsEditing = true
                UIApplication.topViewController()?.present(myPickerController, animated: true, completion: nil)

            } else {
                self.showErrorAlert()
            }
        }
    }

    private func openPhotoLibrary() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                myPickerController.modalPresentationStyle = .fullScreen
                myPickerController.allowsEditing = true
                UIApplication.topViewController()?.present(myPickerController, animated: true, completion: nil)
            } else {
                self.showErrorAlert()
            }
        }
    }

    // error tip
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "uu.Error".localized, message: "uu.The device does not support".localized, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "uu.Sure".localized, style: .cancel, handler: nil)
        alertController.addAction(action)
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }

    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera".localized, style: .default, handler: { [weak self] (_: UIAlertAction) in
            self?.requestCameraAccess()
        }))
        actionSheet.addAction(UIAlertAction(title: "PhotoAlbum".localized, style: .default, handler: { [weak self] (_: UIAlertAction) in
            self?.requestPhotoLibraryAccess()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        UIApplication.topViewController()?.present(actionSheet, animated: true, completion: nil)
    }
    
    /// 直接跳转相册
    func goToAabum() {
        requestPhotoLibraryAccess()
    }

    private func requestPhotoLibraryAccess() {
        // 检查相册权限状态
        let status = PHPhotoLibrary.authorizationStatus()
        // 根据权限状态进行处理
        switch status {
        case .authorized:
            // 用户已经授权访问相册
            openPhotoLibrary()
        case .limited:
            // "用户授予了有限的照片库访问权限"
            openPhotoLibrary()
        case .notDetermined:
            // 用户还没有决定是否授权访问相册，需要请求权限
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                if #available(iOS 14, *) {
                    if status == .authorized || status == .limited {
                        // 用户授权访问相册
                        self?.openPhotoLibrary()
                    } else {
                        // 用户拒绝了访问相册权限
                        JLog("用户拒绝访问相册")
                    }
                } else {
                    if status == .authorized {
                        // 用户授权访问相册
                        self?.openPhotoLibrary()
                    } else {
                        // 用户拒绝了访问相册权限
                        JLog("用户拒绝访问相册")
                    }
                }
            }
        case .denied, .restricted:
            // 用户已经拒绝或限制了访问相册权限，可以提示用户在设置中打开权限
            JLog("用户拒绝或限制了访问相册权限")
            openAppSettings()
        @unknown default:
            // 处理未知权限状态
            break
        }
    }

    /// 打开系统设置页面
    private func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
    }

    private func requestCameraAccess() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .authorized:
            // 用户已授权使用相机
            openCamera()
        case .notDetermined:
            // 用户尚未做出选择，请求相机权限
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    // 用户授权使用相机
                    self?.openCamera()
                } else {
                    // 用户拒绝了相机权限
                    JLog("用户拒绝了相机权限")
                }
            }
        case .denied, .restricted:
            // 用户已拒绝或限制了相机权限
            JLog("用户拒绝或限制了相机权限")
            SystemPermissionAlertViewController.Camera(controller: UIApplication.topViewController())
//            openAppSettings()
        @unknown default:
            break
        }
    }
}

extension CameraHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        imagePickedBlock?(image)
        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }
}

