/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit


protocol HeaderViewDelegate {
    func bussinessGuiedeCliked()
    func findNearByClicked()
    func onDutyPharmacyClicked()
}



 class HeaderView: UICollectionReusableView {

  // MARK: - IBOutlets
   
  @IBOutlet weak var businessGuidCollectionView: UICollectionView!
  @IBOutlet weak var overlayView: UIView!
    
    // buttons
    @IBOutlet weak var bussinessGuideButton: UIButton!
    @IBOutlet weak var finNearByButton: UIButton!
    @IBOutlet weak var pharmacyButton: UIButton!
    @IBOutlet weak var pharmacyLabel: XUILabel!
    @IBOutlet weak var findNearByLabel: XUILabel!
    @IBOutlet weak var bussinessLabel: XUILabel!
    @IBOutlet weak var bussinessView: UIView!
    @IBOutlet weak var nearByView: UIView!
    @IBOutlet weak var pharmacyView: UIView!

    // delegate
    var delegate:HeaderViewDelegate?
    
  // MARK: - Life Cycle
  open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)

    guard let customFlowLayoutAttributes = layoutAttributes as? CustomLayoutAttributes else {
      return
    }

    overlayView?.alpha = customFlowLayoutAttributes.headerOverlayAlpha
  }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: HomeViewController.businessGuidCellId, bundle: nil)
        self.businessGuidCollectionView.register(nib, forCellWithReuseIdentifier: HomeViewController.businessGuidCellId)
        
        
        // customize
        self.bussinessLabel.font = AppFonts.smallBold
        self.findNearByLabel.font = AppFonts.smallBold
        self.pharmacyLabel.font = AppFonts.smallBold
        
         // colors
        self.bussinessView.backgroundColor = AppColors.skyBlue
        self.nearByView.backgroundColor = AppColors.lightGreen
        self.pharmacyView.backgroundColor = AppColors.lightPink

    }
    
    func customizeCell(){
        // corner raduice
        self.bussinessView.cornerRadius = 5
        self.nearByView.cornerRadius = 5
        self.pharmacyView.cornerRadius = 5
        // shadow
        self.bussinessView.dropShadow()
        self.nearByView.dropShadow()
        self.pharmacyView.dropShadow()
    }
    
    @IBAction func showBussinessGuides(_ sender: UIButton) {
        delegate?.bussinessGuiedeCliked()
    }
    
    
    @IBAction func showNearBy(_ sender: UIButton) {
        delegate?.findNearByClicked()
    }
    
    @IBAction func showPharmacies(_ sender: UIButton) {
        delegate?.onDutyPharmacyClicked()
    }
    
}
