//
//  downloadManager.swift
//  try to download
//
//  Created by Rhythm Singla on 05/02/22.
//

import UIKit

protocol DownloadManagerDelegate{
    func showFileWithPath(url: URL)
    func gotAnError(error: Error)
    func updateDownloadProgress(progress: Float)
}

class DownloadManager: NSObject, URLSessionDownloadDelegate{
    
    var session: URLSession!
    var delegate: DownloadManagerDelegate?
    var uurl: URL?
    
    func openBaseURL(_ baseurl: String){
        uurl = URL(string: baseurl)
        
            do {
                guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                let savedURL = documentsURL.appendingPathComponent(uurl!.lastPathComponent)
                
                let fileManager = FileManager()
                //IF FILE ALREADY EXISTS AT savedURL
                if fileManager.fileExists(atPath: savedURL.path){
                    print("File Already Found")
                    delegate!.showFileWithPath(url: savedURL)
                }
                else{
                    startDownloading(baseurl)        
                }
            }
    }
    
    func startDownloading(_ baseurl: String){
        print("Start Downloading method called")
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.rhythm")
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let url = URL(string: baseurl)
//        let session = URLSession(configuration: .default)
        let task = session.downloadTask(with: url!)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let fileURL = location
            do {
                guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                let savedURL = documentsURL.appendingPathComponent(uurl!.lastPathComponent)
//                print(fileURL)
                print(savedURL.path)
                
                let fileManager = FileManager()
                //IF FILE ALREADY EXISTS AT savedURL
                if fileManager.fileExists(atPath: savedURL.path){
        //                        print("FILE'S PATH IS : \(urlPath)")
                    print("File Already Found")
                    delegate!.showFileWithPath(url: savedURL)
                }
                else{
//                    print("File ")
                try FileManager.default.moveItem(at: fileURL, to: savedURL)
                delegate?.showFileWithPath(url: savedURL)
            }
            }catch {
                print ("file error: \(error)")
            }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("ERROR GOT IN URL SESSION, DID COMPLETE WITH ERROR: \(String(describing: error ?? nil))")
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
           let prog = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
            self.delegate?.updateDownloadProgress(progress: prog)
        }
        
    }
}
