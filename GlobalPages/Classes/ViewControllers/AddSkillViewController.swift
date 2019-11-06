//
//  AddSkillViewController.swift
//  GlobalPages
//
//  Created by Abd Hayek on 10/27/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit

protocol AddSkillDelegate : class {
    func didAddTags(_ tags: [Tag])
}

class AddSkillViewController: AbstractController {

    @IBOutlet weak var txtTag: UITextField!
    @IBOutlet weak var btnAddTag: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tableViewConstant: NSLayoutConstraint!
    @IBOutlet weak var collectionViewConstant: NSLayoutConstraint!
    @IBOutlet weak var indicatiorView: UIActivityIndicatorView!
    @IBOutlet weak var lblSkillTitle: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    
    public var tags: [Tag] = []
    public var delegate: AddSkillDelegate?
    
    fileprivate var suggestedTags: [Tag] = []
    fileprivate var isSelectingFromList: Bool = false
    fileprivate var selectedTag: Tag?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func buildUp() {
        txtTag.addTarget(self, action: #selector(didTextChanged(_:)), for: .editingChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SkillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SkillCollectionViewCell")
        
        collectionView.collectionViewLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        
        tableViewConstant.constant = 0
    }
    
    override func customizeView() {
        lblSkillTitle.font = AppFonts.bigBold
        btnAddTag.titleLabel?.font = AppFonts.normalSemiBold
        btnSave.titleLabel?.font = AppFonts.normalBold
        
        lblSkillTitle.text = "CV_SKILLS_TITLE".localized
        btnSave.setTitle("CV_SAVE".localized, for: .normal)
        btnAddTag.setTitle("CV_ADD".localized, for: .normal)
    }
    
    override func viewWillLayoutSubviews() {
        self.collectionViewConstant.constant = self.collectionView.contentSize.height
    }
    
    @objc func didTextChanged(_ textField: UITextField) {
        if textField.text == "" {
            isSelectingFromList = false
        }else if !isSelectingFromList{
            let txt = textField.text
            self.tableViewConstant.constant = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if txt == self.txtTag.text {
                    ApiManager.shared.getTags(like: txt ?? "", completionBlock: {isSuccess, error, data in
                        self.suggestedTags = data
                        self.tableView.reloadData()
                        self.tableViewConstant.constant = data.count > 0 ? 100 : 0
                    })
                }
            }
        }
        
    }
}

// MARK:- UICollectionViewDelegate
extension AddSkillViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCollectionViewCell", for: indexPath) as! SkillCollectionViewCell
        
        cell.delegate = self
        cell.title = tags[indexPath.row].name ?? ""
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SkillCollectionViewCell
        self.didTabOnRemove(cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.tags[indexPath.row].name!.getLabelWidth(font: AppFonts.normal) + 60
        
        return CGSize(width: width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

// MARK:- SkillCollectionViewCellDelegate
extension AddSkillViewController: SkillCollectionViewDelegate {
    func didTabOnRemove(_ cell: SkillCollectionViewCell) {
        let removeAlert = UIAlertController(title: "GLOBAL_WARNING_TITLE".localized, message: "REMOVE_SKILL_MSG".localized, preferredStyle: .alert)
        
        removeAlert.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil))
        removeAlert.addAction(UIAlertAction(title: "DELETE".localized, style: .default, handler: {_ in
            self.tags.remove(at: self.collectionView.indexPath(for: cell)?.row ?? 0)
            self.collectionView.reloadData()
            self.collectionViewConstant.constant = self.collectionView.contentSize.height
            self.contentView.layoutIfNeeded()
            
            self.viewWillLayoutSubviews()
        }))
        
        self.present(removeAlert, animated: true, completion: nil)
    }
}

// MARK:- UITableViewDelegate
extension AddSkillViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestedTags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestedTagCell", for: indexPath)
        let title = cell.viewWithTag(1) as! UILabel
        
        title.text = self.suggestedTags[indexPath.row].name
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.txtTag.text = self.suggestedTags[indexPath.row].name
        self.isSelectingFromList = true
        self.selectedTag = self.suggestedTags[indexPath.row]
        self.suggestedTags = []
        self.tableView.reloadData()
        self.tableViewConstant.constant = 0
    }
}

// MARK:- IBAction
extension AddSkillViewController {
    @IBAction func SaveAction(_ sender: Any) {
        self.delegate?.didAddTags(self.tags)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddAction(_ sender: Any) {
        if isSelectingFromList {
            if !self.tags.contains(where: {$0.idString == self.selectedTag?.idString}) {
                self.tags.append(selectedTag!)
                self.collectionView.reloadData()
                //self.collectionViewConstant.constant = self.collectionView.contentSize.height
                self.contentView.layoutIfNeeded()
            }
            
        }else {
            if let text = txtTag.text, !text.isEmpty {
                self.btnAddTag.isHidden = true
                self.indicatiorView.startAnimating()
                self.txtTag.isEnabled = false
                
                ApiManager.shared.addTag(tagName: text, completionBlock: {error, tag in
                    if let error = error {
                        self.showMessage(message: error.type.errorMessage, type: .error)
                    }else {
                        self.tags.append(tag!)
                        self.collectionView.reloadData()
                        //self.collectionViewConstant.constant = self.collectionView.contentSize.height
                        self.contentView.layoutIfNeeded()
                        
                        self.btnAddTag.isHidden = false
                        self.indicatiorView.stopAnimating()
                        self.txtTag.isEnabled = true
                    }
                })
            }
            
        }
        
        self.isSelectingFromList = false
        self.txtTag.text = ""
        
    }
    
    @IBAction func CloseAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
