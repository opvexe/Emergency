//
//  EGCameraView.swift
//  EGD
//
//  Created by jieku on 2017/6/8.
//
//
import UIKit
import AVFoundation
import SnapKit
import Photos

protocol EGCameraViewDelegate: NSObjectProtocol {
    func takePhotoUseCameraAction(takePhotoFinishImage: UIImage)
    func clickDissmiss()
}
typealias EGClickCameraBlock = ()->Void

//方便以后抽调使用
class EGCameraView: UIView{
    // MARK : AVCapture类
    fileprivate var device :AVCaptureDevice!
    fileprivate var session: AVCaptureSession = AVCaptureSession()
    fileprivate var videoInput: AVCaptureInput!
    fileprivate var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
    //MARK : UIButton
    fileprivate var takePhotoButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
    fileprivate var cameraBackButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 15, height: 25))
    fileprivate var flashLightButton: UIButton = UIButton(frame: CGRect(x: 20, y: 20, width: 25, height: 25))
    fileprivate var cameraSwitchButton: UIButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width - 20 - 30, y: 20, width: 30, height: 30))
    //MARK : 聚焦View/默认缩放/最大缩放
    fileprivate var effectiveScale:CGFloat = 1.0
    fileprivate var beginGestureScale:CGFloat = 1.0
    fileprivate let maxScale:CGFloat = 2.0
    //MARK :CameraPositon/flashType/currentView
    fileprivate var CameraPositon_: AVCaptureDevicePosition!
    //MARK :代理事件
    weak var delegate: EGCameraViewDelegate?
    //MARK :闭包
    var clickBlock : EGClickCameraBlock?
    
    //初始化摄像头闪光灯状态/前后置摄像头
    init(frame: CGRect, CameraPositon :AVCaptureDevicePosition){
        super.init(frame:frame)
        self.backgroundColor = UIColor.black
        CameraPositon_ = CameraPositon
        setUpUI()
        setUpGesture() //添加手势
        installCameraDevice()  //初始化相机
        startRunning()   //开始运行
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK :设置UI界面
extension EGCameraView {
    
    func setUpUI() {
        takePhotoButton.tag = 100       //拍照
        takePhotoButton.addTarget(self, action: #selector(dothing), for: UIControlEvents.touchUpInside)
        takePhotoButton.setImage(UIImage(named: "photo_nor"), for: UIControlState.normal)
        takePhotoButton.setImage(UIImage(named: "photo_high"), for: UIControlState.highlighted)
        takePhotoButton.setImage(UIImage(named: "photo_dis"), for: UIControlState.disabled)
        
        cameraBackButton.tag = 101      //返回
        cameraBackButton.setImage(UIImage(named: "back_bottom"), for: UIControlState.normal)
        cameraBackButton.addTarget(self, action: #selector(dothing), for: UIControlEvents.touchUpInside)
        
        flashLightButton.tag = 102      //闪光灯
        flashLightButton.setImage(UIImage(named: "flashlight_auto"), for: UIControlState.normal)
        flashLightButton.setImage(UIImage(named: "flashlight_auto_sel"), for: UIControlState.highlighted)
        flashLightButton.addTarget(self, action: #selector(dothing), for: UIControlEvents.touchUpInside)
        
        cameraSwitchButton.tag = 103    //前置摄像头
        cameraSwitchButton.setImage(UIImage(named: "sight_camera_switch"), for: UIControlState.normal)
        cameraSwitchButton.addTarget(self, action: #selector(dothing), for: UIControlEvents.touchUpInside)
        
        addSubview(takePhotoButton)
        addSubview(cameraBackButton)
        addSubview(flashLightButton)
        addSubview(cameraSwitchButton)
        
        snapMagin()
    }
}

//MARK :适配
extension EGCameraView {
    @objc fileprivate func snapMagin() {
        takePhotoButton.snp.updateConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-66) //自己的高度+10
        }
        
        cameraBackButton.snp.updateConstraints { (make) in
            make.top.equalTo(takePhotoButton.snp.top)
            make.left.equalTo(self).offset(45)
        }
    }
}
// MARK :点击事件
extension EGCameraView {
    @objc fileprivate func dothing(sender: UIButton) {
        switch sender.tag-100 {
        case 0:     //拍照
            takePhoto()
            break
        case 1:     //返回
            back()
            break
        case 2:    //闪光灯
            swithFlash()
            break
        case 3:    //前置摄像头
            switchCamera()
            break
        default:
            break
        }
    }
    
    @objc fileprivate func startRunning() {      //开始运行
        if session.isRunning == false {
            session.startRunning()
        }
    }
    
    @objc fileprivate func stopRunning(){     //停止运行
        if session.isRunning == true {
            session.stopRunning()
        }
    }
}
//MARK : 拍照，切换摄像头
extension EGCameraView {
    @objc fileprivate func takePhoto(){     //拍照
        let captureConnetion = stillImageOutput.connection(withMediaType: AVMediaTypeVideo)
        captureConnetion?.videoScaleAndCropFactor = effectiveScale
        stillImageOutput.captureStillImageAsynchronously(from: captureConnetion) { (imageBuffer, error) in
            let jpegData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageBuffer)
            let jpegImage = UIImage(data: jpegData!)
            UIImageWriteToSavedPhotosAlbum(jpegImage!, self,nil, nil)  //图片入库
            self.delegate?.takePhotoUseCameraAction(takePhotoFinishImage: jpegImage!)
        }
    }
    
    @objc fileprivate func back(){          //返回
        delegate?.clickDissmiss()
    }
    
    @objc fileprivate func swithFlash(){    //闪光灯切换
        //修改前必须先锁定
        do{ try device.lockForConfiguration() }catch{ }
        if device.hasFlash == false { return  print("设备不支持闪光灯")}
        if device.flashMode == AVCaptureFlashMode.off {
            device.flashMode = AVCaptureFlashMode.on
            flashLightButton.setImage(UIImage(named: "flashlight_on"), for: UIControlState.normal)
            flashLightButton.setImage(UIImage(named: "flashlight_on_sel"), for: UIControlState.highlighted)
        }else if device.flashMode == AVCaptureFlashMode.on{
            device.flashMode = AVCaptureFlashMode.auto
            flashLightButton.setImage(UIImage(named: "flashlight_auto"), for: UIControlState.normal)
            flashLightButton.setImage(UIImage(named: "flashlight_auto_sel"), for: UIControlState.highlighted)
        }else if device.flashMode == AVCaptureFlashMode.auto {
            device.flashMode = AVCaptureFlashMode.off
            flashLightButton.setImage(UIImage(named: "flashlight_off"), for: UIControlState.normal)
            flashLightButton.setImage(UIImage(named: "flashlight_off_sel"), for: UIControlState.highlighted)
        }
        device.unlockForConfiguration()
    }
    
    @objc fileprivate func switchCamera(){       //前置摄像头
        if session.isRunning {
            session.stopRunning()
        }
        if CameraPositon_ == AVCaptureDevicePosition.back {
            CameraPositon_ = AVCaptureDevicePosition.front
        }else {
            CameraPositon_ = AVCaptureDevicePosition.back
            installCameraDevice()
        }
        if session.isRunning == false {
            session.startRunning()
        }
    }
    
    @objc fileprivate func pin(_ recognizer:UIPinchGestureRecognizer) { //缩放
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0) {
            self.effectiveScale = 1.0;
        }
        let maxScaleAndCropFactor = stillImageOutput.connection(withMediaType: AVMediaTypeVideo).videoMaxScaleAndCropFactor
        if  self.effectiveScale > maxScaleAndCropFactor {
            self.effectiveScale = maxScaleAndCropFactor;
        }
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.025)
        previewLayer!.setAffineTransform(CGAffineTransform(scaleX: effectiveScale, y: effectiveScale))
        CATransaction.commit()
    }
    
    @objc fileprivate func tip(_ ges:UITapGestureRecognizer) {  //聚焦
        let currentPoint  = ges.location(in: self)
        self.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            self.isUserInteractionEnabled = true
        }
        do{ try device.lockForConfiguration() }catch{ }
        if device.isFocusModeSupported(.autoFocus) {
            device.focusPointOfInterest = currentPoint
            device.focusMode = .autoFocus
        }
        if device.isExposureModeSupported(.autoExpose) {
            device.exposurePointOfInterest = currentPoint
            device.exposureMode = .autoExpose
        }
        device.unlockForConfiguration()
    }
    
    @objc fileprivate func isCameraBack() ->Bool { //判断摄像头的方向
        guard CameraPositon_ == AVCaptureDevicePosition.back else {
            return false
        }
        return true
    }
    
}

//MARK :  初始化相机相关
extension EGCameraView {
    
    @objc fileprivate func installCameraDevice() {
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice] else { return }
        
        guard let dfilter = devices.filter({ return $0.position == CameraPositon_ }).first else{ return}
        device = dfilter
        guard let inputDevice = try? AVCaptureDeviceInput(device: dfilter) else { return }
        self.videoInput = inputDevice
        
        session.sessionPreset = AVCaptureSessionPresetHigh
        stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        if session.canAddInput(inputDevice) == true {
            session.addInput(self.videoInput)
        }
        if session.canAddOutput(stillImageOutput) == true {
            session.addOutput(stillImageOutput)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer.init(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.frame = self.bounds
        self.layer.addSublayer(previewLayer)
        //锁定设备之后才能修改设置,修改完再锁上 否则会崩溃
        do{ try dfilter.lockForConfiguration() }catch{ }
        if dfilter.hasFlash == false { return }
        dfilter.flashMode = AVCaptureFlashMode.auto
        dfilter.unlockForConfiguration()
    }
}
//MARK : 手势
extension EGCameraView: UIGestureRecognizerDelegate {
    //添加手势 + 缩放 + 聚焦
    fileprivate func setUpGesture() {
        let pinGesutre = UIPinchGestureRecognizer(target: self, action: #selector(pin(_:)))
        pinGesutre.delegate = self
        self.addGestureRecognizer(pinGesutre)
        
        let tapGesutre = UITapGestureRecognizer(target: self, action: #selector(tip(_: )))
        self.addGestureRecognizer(tapGesutre)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer .isKind(of: UIPinchGestureRecognizer.classForCoder()) {
            beginGestureScale = self.effectiveScale
        }
        return true
    }
}
