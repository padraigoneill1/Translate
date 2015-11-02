//
//  ViewController.swift
//  Translate
//
//  Created by Robert O'Connor on 16/10/2015.
//  Copyright © 2015 WIT. All rights reserved.
//  test

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var label: UILabel!
    // Input data into the Array:
    let languageData = ["French", "Turkish", "Gaelic"]
    //var data = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect data:
        // Connect data:
        languagePicker.dataSource = self
        languagePicker.delegate = self
      
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  languageData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  languageData[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       label.text = languageData[row]
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

        
    
    
    
   
    


        

    
    @IBAction func translate(sender: AnyObject) {
        
        let str = textToTranslate.text
        let escapedStr = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        var langStr = String()
        
        if let language = label.text {
            switch (language){
                case "French":
                    langStr = ("en|fr").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                case "Gaelic":
                    langStr = ("en|ga").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                
                case "Turkish":
                    langStr = ("en|tr").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                
                default:
                    langStr = ("en|fr").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                
            }

        }
        else{
            //backup in the case that language switch returns nil value for langStr
            langStr = ("en|fr").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!

        }
        
        let urlStr:String = ("http://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr)
        
        let url = NSURL(string: urlStr)
        
        let request = NSURLRequest(URL: url!)// Creating Http Request
        
        //var data = NSMutableData()var data = NSMutableData()
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        var result = "<Translation Error>"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            
            indicator.stopAnimating()
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    
                    let jsonDict: NSDictionary!=(try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                    
                    if(jsonDict.valueForKey("responseStatus") as! NSNumber == 200){
                        let responseData: NSDictionary = jsonDict.objectForKey("responseData") as! NSDictionary
                        
                        result = responseData.objectForKey("translatedText") as! String
                    }
                }
                
                self.translatedText.text = result
            }
        }
        
    }
}

