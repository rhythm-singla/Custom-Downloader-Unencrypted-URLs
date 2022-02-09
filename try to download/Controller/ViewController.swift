//
//  ViewController.swift
//  try to download
//
//  Created by Rhythm Singla on 05/02/22.
//

import UIKit

class ViewController: UIViewController, DownloadManagerDelegate, UIDocumentInteractionControllerDelegate {
    
    
    @IBOutlet weak var downloadLabel: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var progressView: UIProgressView!
    
//    var session: URLSession!
   var downloadManager = DownloadManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let configuration = URLSessionConfiguration.background(withIdentifier:
//          "com.rhythm")
//         session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        progressView.progress = 0.0
        downloadManager.delegate = self
    }

    @IBAction func downloadPressed(_ sender: UIButton) {
        if(textField.text != ""){
//            print("Download started")
            downloadManager.openBaseURL(self.textField.text ?? "")
        }
    }
    
    
//    func openBaseURL(_ baseurl: String){
//        let url = URL(string: baseurl)
//        let task = session.downloadTask(with: url!)
//        task.resume()
//        print("Downloaded: Open Base URL")
        
//    }
    
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        print("Downloaded successfully")
//        
//        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//        
//        let documentDirectoryPath:String = path[0]
//        let savedURL = URL(fileURLWithPath: documentDirectoryPath.appendingFormat("/file.pdf"))
//        let fileManager = FileManager()
//        //IF FILE ALREADY EXISTS AT savedURL
//        if fileManager.fileExists(atPath: savedURL.path){
////                        print("FILE'S PATH IS : \(urlPath)")
//            showFileWithPath(urlPath: savedURL.path)
//        }
//        else{
//            do {
//                try fileManager.moveItem(at: location, to: savedURL)
//            }catch{
//                print("An error occurred while moving file to destination url")
//            }
//        }
//        showFileWithPath(urlPath: savedURL.path)
//    }
//
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        print("ERROR GOT IN URL SESSION, DID COMPLETE WITH ERROR: \(String(describing: error ?? nil))")
//    }
//
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
////        print("Bytes to write")
//        DispatchQueue.main.async {
//            self.progressView.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
//        }
//        
//    }
    
    func showFileWithPath(url: URL){
        
        if(FileManager.default.fileExists(atPath: url.path)){
            print("File Found at urlPath: showFileWithPath")
            DispatchQueue.main.async {
                let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: url.path))
                viewer.delegate = self
                viewer.presentPreview(animated: true)
            }
        }
        else{
            print("File not found, at urlPath")
            print(url)
        }
    }
    
    func updateDownloadProgress(progress: Float) {
        DispatchQueue.main.async {
            self.progressView.progress = progress
        }
    }
        
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        return self
    }
    
    func gotAnError(error: Error) {
        print("WE GOT AN ERROR: \(error)")
    }
    
    
}

