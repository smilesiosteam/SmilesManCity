//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 12/07/2023.
//

import UIKit
import LottieAnimationManager
import SmilesUtilities
import SmilesOffers

class RestaurantsRevampTableViewCell: UITableViewCell {
    
    enum OfferCellType {
        case home
        case collectionDetails
        case categoryDetails
    }

    // MARK: - IBOutlet
    
    @IBOutlet var parentContainerView: UIView!
    @IBOutlet var offerView: UIView!
    @IBOutlet var offerLabel: UILabel!
    @IBOutlet var restaurantStatusView: UIView!
    @IBOutlet var restaurantStatusImageView: UIImageView!
    @IBOutlet var restaurantStatusLabel: UILabel!
    @IBOutlet var favoriteView: UIView!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var ratingView: UIView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var ratingImageView: UIImageView!
    @IBOutlet var locationView: UIView!
    @IBOutlet var locationImageView: UIImageView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var cuisinesLabel: UILabel!
    @IBOutlet var restaurantTitleLabel: UILabel!
    @IBOutlet var closingTimeView: UIView!
    @IBOutlet var closingTimeLabel: UILabel!
    @IBOutlet var minimumOrderStackView: UIStackView!
    @IBOutlet var minimumOrderPriceLabel: UILabel!
    @IBOutlet var minimumOrderTitleLabel: UILabel!
    @IBOutlet var minimumOrderSeparatorView: UIView!
    @IBOutlet var deliveryChargesPriceLabel: UILabel!
    @IBOutlet var deliveryChargesTitleLabel: UILabel!
    @IBOutlet var dimmedView: UIView!
    @IBOutlet var restaurantDistanceView: UIView!
    @IBOutlet var restaurantDistanceImageView: UIImageView!
    @IBOutlet var restaurantDistanceLabel: UILabel!
    @IBOutlet var smileyPointsView: UIView!
    @IBOutlet var pointsIcon: UIImageView!
    @IBOutlet var offerPointsLabel: UILabel!
    @IBOutlet var offerPriceLabel: UILabel!
    @IBOutlet var offerOrSeparatorLabel: UILabel!
    @IBOutlet var partnerImageView: UIImageView!
    @IBOutlet var notEligibleView: UIView!
    @IBOutlet var lockImageView: UIImageView!
    @IBOutlet var lottieAnimationView: UIView!
    @IBOutlet weak var ribbonImageView: UIImageView!
    @IBOutlet weak var offerViewTrailingSpaceFromFavView: NSLayoutConstraint!
    @IBOutlet weak var offerViewTrailingSpaceFromRibbon: NSLayoutConstraint!
    
    @IBOutlet var cuisinesLabelTopToPartnerImage: NSLayoutConstraint!
    @IBOutlet var cuisinesLabelTopToRatingView: NSLayoutConstraint!
    
    var restaurantData: Restaurant?
    var offerData: OfferDO?
    var favoriteCallback: ((_ isFavorite: Bool, _ restaurantId: String) -> ())?
    
    var offerCellType: OfferCellType = .home
    private let isFavoriteOfferNil = false
    
    //MARK: - Cell Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        setupFonts()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setupUI() {
        parentContainerView.RoundedViewConrner(cornerRadius: 12.0)
        parentContainerView.layer.borderColor = UIColor.appRevampCellBorderGrayColor.cgColor
        parentContainerView.layer.borderWidth = 1.0
        
        notEligibleView.RoundedViewConrner(cornerRadius: 12.0)
        
        if !AppCommonMethods.languageIsArabic() {
            offerView.addMaskedCorner(withMaskedCorner: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner], cornerRadius: 14.0)
        } else {
            offerView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMinXMaxYCorner], cornerRadius: 14.0)
        }
        
        favoriteView.addMaskedCorner(withMaskedCorner: [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner], cornerRadius: favoriteView.frame.height / 2)
        
        restaurantStatusView.backgroundColor = UIColor(red: 19 / 255, green: 23 / 255, blue: 40 / 255, alpha: 1).withAlphaComponent(0.5)
        restaurantStatusView.layer.cornerRadius = 16.0
        
        ratingView.layer.cornerRadius = 14.0
        ratingView.layer.borderColor = UIColor.appRevampBorderGrayColor.cgColor
        ratingView.layer.borderWidth = 1
        
        locationView.layer.cornerRadius = 14.0
        locationView.layer.borderColor = UIColor.appRevampBorderGrayColor.cgColor
        locationView.layer.borderWidth = 1
        
        lottieAnimationView.isHidden = true
        
        minimumOrderSeparatorView.backgroundColor = .appRevampClosingTextGrayColor
        minimumOrderSeparatorView.isHidden = true
        deliveryChargesPriceLabel.isHidden = true
        deliveryChargesTitleLabel.isHidden = true
        
        partnerImageView.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: partnerImageView.frame.height / 2)
        partnerImageView.layer.borderColor = UIColor.white.cgColor
        partnerImageView.layer.borderWidth = 2.0
        
        favoriteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setupFavoriteGesture)))
//        favoriteView.backgroundColor = .appRevampFilterTextColor.withAlphaComponent(0.5)
        
        minimumOrderStackView.setCustomSpacing(6.0, after: minimumOrderTitleLabel)
        minimumOrderStackView.setCustomSpacing(6.0, after: minimumOrderSeparatorView)
        
        cuisinesLabel.textAlignment = AppCommonMethods.languageIsArabic() ? .right : .left
        restaurantTitleLabel.textAlignment = AppCommonMethods.languageIsArabic() ? .right : .left
    }
    
    private func setupFonts() {
        offerLabel.fontTextStyle = .smilesBody4
        restaurantStatusLabel.fontTextStyle = .smilesTitle1
        ratingLabel.fontTextStyle = .smilesBody4
        locationLabel.fontTextStyle = .smilesBody4
        closingTimeLabel.fontTextStyle = .smilesBody4
        cuisinesLabel.fontTextStyle = .smilesBody3
        restaurantTitleLabel.fontTextStyle = .smilesHeadline3
        minimumOrderPriceLabel.fontTextStyle = .smilesBody3
        minimumOrderTitleLabel.fontTextStyle = .smilesBody3
        deliveryChargesPriceLabel.fontTextStyle = .smilesBody3
        deliveryChargesTitleLabel.fontTextStyle = .smilesBody3
    }
    
    @objc private func setupFavoriteGesture() {
        if let restaurantData = restaurantData {
            if let isFavoriteRestaurant = restaurantData.isFavoriteRestaurant, let restaurantId = restaurantData.restaurantId {
                favoriteCallback?(isFavoriteRestaurant ? false : true, restaurantId)
            }
        }
        
        if let offerData = offerData, let offerId = offerData.offerId {
            if let isFavoriteOffer = offerData.isWishlisted {
                favoriteCallback?(isFavoriteOffer ? false : true, offerId)
            } else {
                favoriteCallback?(isFavoriteOfferNil ? false : true, offerId)
            }
        }
    }
    
    func setBackGroundColor(color: UIColor) {
        contentView.backgroundColor = color
    }
    
    func showFavouriteAnimation(isRestaurant: Bool = true) {
        
        let showAnimation = isRestaurant ? restaurantData?.isFavoriteRestaurant : offerData?.isWishlisted
        if showAnimation ?? false {
            favoriteButton.setImage(nil, for: .normal)
            LottieAnimationManager.showAnimation(onView: favoriteButton, withJsonFileName: "Heart") { [weak self] isCompleted in
                self?.setFavouriteIcon(isRestaurant: isRestaurant)
            }
        } else {
            setFavouriteIcon(isRestaurant: isRestaurant)
        }
        
    }
    
    private func setFavouriteIcon(isRestaurant: Bool = true) {
        
        var image = UIImage(named: "fvrtIcon")
        if isRestaurant {
            if let isFavorite = restaurantData?.isFavoriteRestaurant {
                if isFavorite {
                    image = UIImage(named: "fvrtIconFilled")
                }
            }
        } else {
            if let isFavorite = offerData?.isWishlisted {
                if isFavorite {
                    image = UIImage(named: "fvrtIconFilled")
                }
            }
        }
        favoriteButton.setImage(image, for: .normal)
        
    }
    
    // MARK: -- For restaurant cell in FoodOrderRevamp
    func configureCell(with restaurant: Restaurant) {
        cuisinesLabelTopToPartnerImage.isActive = false
        cuisinesLabelTopToRatingView.isActive = true
        
        smileyPointsView.isHidden = true
        partnerImageView.isHidden = true
        notEligibleView.isHidden = true
//        closedTitleLabel.textAlignment = .center
        self.restaurantData = restaurant

        setFavouriteIcon()
        
        restaurantTitleLabel.text = restaurant.restaurantName ?? ""
        if let cuisines = restaurant.cuisines, !cuisines.isEmpty {
            cuisinesLabel.text = cuisines.joined(separator: ", ")
        }
        
        restaurantImageView.setImageWithUrlString(restaurant.imageUrl.asStringOrEmpty(),defaultImage: "offerDefaultPlaceholder")
        
        
        if restaurant.restaurantOrderType == .isDelivery || restaurant.restaurantOrderType == .isDeliveryAndPickup || restaurant.restaurantOrderType == .none {
            if let minimumOrderPrice = restaurant.minimumOrder, minimumOrderPrice > 0.0, let deliveryChargesPrice = restaurant.deliveryCharges, deliveryChargesPrice > 0.0 {
                minimumOrderPriceLabel.text = "\(minimumOrderPrice) \("AED".localizedString)"
                minimumOrderPriceLabel.isHidden = false
                minimumOrderTitleLabel.isHidden = false
                
                minimumOrderSeparatorView.isHidden = false
                
                deliveryChargesPriceLabel.text = "\(deliveryChargesPrice) \("AED".localizedString)"
                deliveryChargesPriceLabel.isHidden = false
                deliveryChargesTitleLabel.isHidden = false
                
                minimumOrderTitleLabel.text = "RestaurantMinOrder".localizedString
                deliveryChargesTitleLabel.text = "DeliveryCharges".localizedString
            } else if let minimumOrderPrice = restaurant.minimumOrder, minimumOrderPrice > 0.0 {
                minimumOrderPriceLabel.isHidden = false
                minimumOrderTitleLabel.isHidden = false
                minimumOrderSeparatorView.isHidden = true
                deliveryChargesPriceLabel.isHidden = true
                deliveryChargesTitleLabel.isHidden = true
                
                minimumOrderPriceLabel.text = "\(minimumOrderPrice) \("AED".localizedString)"
                minimumOrderTitleLabel.text = "RestaurantMinOrder".localizedString
            } else if let deliveryChargesPrice = restaurant.deliveryCharges, deliveryChargesPrice > 0.0 {
                minimumOrderPriceLabel.isHidden = true
                minimumOrderTitleLabel.isHidden = true
                minimumOrderSeparatorView.isHidden = true
                deliveryChargesPriceLabel.isHidden = false
                deliveryChargesTitleLabel.isHidden = false
                
                deliveryChargesPriceLabel.text = "\(deliveryChargesPrice) \("AED".localizedString)"
                deliveryChargesTitleLabel.text = "DeliveryCharges".localizedString
            } else {
                minimumOrderPriceLabel.isHidden = true
                minimumOrderTitleLabel.isHidden = true
                minimumOrderSeparatorView.isHidden = true
                deliveryChargesPriceLabel.isHidden = true
                deliveryChargesTitleLabel.isHidden = true
            }
        }

        if let rating = restaurant.restaurantRating, rating > 0 {
            ratingLabel.text = String(format: "%.1f", rating)
            ratingImageView.isHidden = false
            ratingView.isHidden = false
        } else {
            ratingImageView.isHidden = true
            ratingLabel.text = ""
            ratingView.isHidden = true
        }
        
        updateOfferView(for: restaurant)

        switch restaurant.restaurantStatusType {
        case .open:
            restaurantStatusView.isHidden = true
            updateUIWithOpenRestaurant(restaurant: restaurant)

        case .willClose:
            restaurantStatusView.isHidden = true
            updateUIWithWillCloseRestaurant(restaurant: restaurant)

        case .willOpen:
            restaurantStatusView.isHidden = false
            offerView.isHidden = true
            updateUIWithWillOpenRestaurant(restaurant: restaurant)

        case .closed:
            restaurantStatusView.isHidden = true
            updateUIWithClosedRestaurant(restaurant: restaurant)

        case .temporaryClose:
            restaurantStatusView.isHidden = false
            offerView.isHidden = true
            updateUIWithTemporaryClosedRestaurant(restaurant: restaurant)

        default:
            restaurantStatusView.isHidden = true
        }
    }
    
    // MARK: -- For nearby offer cell in HomeRevamp
    
//    func checkDealForEligability(offer: OfferDO) {
//        if let getEligibilityMatrixResponse = GetEligibilityMatrixResponse.sharedInstance(), let notEligibleObject = getEligibilityMatrixResponse.notEligibleObject {
//            if offer.recommendationModelType == .food {
//                notEligibleView.alpha = notEligibleObject.foodOrder ? 1.0 : 0.0
//                self.isUserInteractionEnabled = !notEligibleObject.foodOrder
//            } else {
//                if (notEligibleObject.dealsForYou) {
//                    notEligibleView.alpha = 1.0
//                    self.isUserInteractionEnabled = false
//                } else {
//                    if notEligibleObject.thirdPartyOffers {
//                        notEligibleView.alpha = 1.0
//                        self.isUserInteractionEnabled = false
//                    } else {
//                        if notEligibleObject.cinema, let isCinema = offer.cinemaOfferFlag, isCinema {
//                            notEligibleView.alpha = 1.0
//                            self.isUserInteractionEnabled = false
//                        } else if let offerType = offer.offerType, offerType.lowercased().contains("etisalat"), !(getEligibilityMatrixResponse.isEtisalatUser) {
//                            notEligibleView.alpha = 1.0
//                            self.isUserInteractionEnabled = false
//                        } else {
//                            notEligibleView.alpha = 0.0
//                            self.isUserInteractionEnabled = true
//                        }
//                    }
//                }
//            }
//        } else {
//            notEligibleView.alpha = 0.0
//            self.isUserInteractionEnabled = true
//        }
//    }
    
//    func checkOfferForEligibility(offer: OfferDO) {
//        if let getEligibilityMatrixResponse = GetEligibilityMatrixResponse.sharedInstance(), let notEligibleObject = getEligibilityMatrixResponse.notEligibleObject {
//            if offer.recommendationModelType == .food {
//                notEligibleView.alpha = notEligibleObject.foodOrder ? 1.0 : 0.0
//                self.isUserInteractionEnabled = !notEligibleObject.foodOrder
//            } else {
//                if notEligibleObject.cinema, let isCinema = offer.cinemaOfferFlag, isCinema {
//                    notEligibleView.alpha = 1.0
//                    self.isUserInteractionEnabled = false
//                } else if let offerType = offer.offerType, offerType.lowercased().contains("etisalat"), !(getEligibilityMatrixResponse.isEtisalatUser) {
//                    notEligibleView.alpha = 1.0
//                    self.isUserInteractionEnabled = false
//                } else {
//                    notEligibleView.alpha = 0.0
//                    self.isUserInteractionEnabled = true
//                }
//            }
//        } else {
//            notEligibleView.alpha = 0.0
//            self.isUserInteractionEnabled = true
//        }
//    }
    
    func configureCell(with nearbyOffer: OfferDO) {
        cuisinesLabelTopToPartnerImage.isActive = true
        cuisinesLabelTopToRatingView.isActive = false
        
        self.offerData = nearbyOffer
//        if offerCellType == .home {
//            checkDealForEligability(offer: nearbyOffer)
//        } else {
//            checkOfferForEligibility(offer: nearbyOffer)
//        }
        
        favoriteView.isHidden = (offerCellType == .collectionDetails) || (offerCellType == .categoryDetails) ? false : true
        restaurantStatusView.isHidden = true
        ratingView.isHidden = true
        closingTimeView.isHidden = true
        restaurantDistanceView.isHidden = true
        partnerImageView.isHidden = false
        notEligibleView.isHidden = true
        
        ribbonImageView.isHidden = !nearbyOffer.isFeatured
        offerViewTrailingSpaceFromRibbon.priority = nearbyOffer.isFeatured ? .defaultHigh : .defaultLow
        offerViewTrailingSpaceFromFavView.priority = nearbyOffer.isFeatured ? .defaultLow : .defaultHigh
        
        setPointsIcon(with: nearbyOffer.smileyPointsUrl.asStringOrEmpty())
        
        setFavouriteIcon(isRestaurant: false)
        
        restaurantTitleLabel.text = nearbyOffer.offerTitle.asStringOrEmpty()
        
        if let partnerName = nearbyOffer.partnerName {
            cuisinesLabel.text = partnerName
        }

        restaurantImageView.setImageWithUrlString(nearbyOffer.imageURL.asStringOrEmpty(),defaultImage: "offerDefaultPlaceholder")
        
        locationImageView.image = UIImage(named: "timeIcon")
        
        if let offerDistance = Double(nearbyOffer.merchantDistance.asStringOrEmpty()), offerDistance > 0 {
            if offerDistance > 1000.0 {
                let formattedDistance = String(format: "%.2f", offerDistance / 1000) + " " + "KiloMeter".localizedString
                if AppCommonMethods.languageIsArabic() {
                    locationLabel.text =  "away".localizedString + " " + formattedDistance
                } else {
                    locationLabel.text = formattedDistance + " " + "away".localizedString
                }
            }
            else {
                let formattedDistance = String(offerDistance) + "meter".localizedString
                
                if AppCommonMethods.languageIsArabic() {
                    locationLabel.text =  "away".localizedString + " " + formattedDistance
                } else {
                    locationLabel.text = formattedDistance + " " + "away".localizedString
                }
            }
        } else {
            locationView.isHidden = true
        }
        
        if let points = nearbyOffer.pointsValue, points != "0", let price = nearbyOffer.dirhamValue, price != "0" {
            offerPointsLabel.text = "\(points) \("PTS".localizedString)"
            offerPriceLabel.text = "\(price) \("AED".localizedString)"
            offerOrSeparatorLabel.text = "or".localizedString
            offerOrSeparatorLabel.isHidden = false
            offerPriceLabel.isHidden = false
        } else {
            lottieAnimationView.isHidden = true
            offerPointsLabel.text = "Free".localizedString
            offerOrSeparatorLabel.isHidden = true
            offerPriceLabel.isHidden = true
        }
        
        
        partnerImageView.setImageWithUrlString(nearbyOffer.partnerImage.asStringOrEmpty(),defaultImage: "partnerDefaultPlaceholder")
        
        updateOfferView(for: nearbyOffer)
        
        switch nearbyOffer.recommendationModelType {

        case .offer:
            minimumOrderStackView.isHidden = true
            smileyPointsView.isHidden = false
            
        case .food:
            minimumOrderStackView.isHidden = false
            smileyPointsView.isHidden = true
            
            if nearbyOffer.offerType == "DELIVERY" {
                if let minimumOrderPrice = nearbyOffer.minimumOrder, minimumOrderPrice > 0.0, let deliveryChargesPrice = nearbyOffer.deliveryCharges, deliveryChargesPrice > 0.0 {
                    minimumOrderPriceLabel.text = "\(minimumOrderPrice) \("AED".localizedString)"
                    minimumOrderPriceLabel.isHidden = false
                    minimumOrderTitleLabel.isHidden = false
                    
                    minimumOrderSeparatorView.isHidden = false
                    
                    deliveryChargesPriceLabel.text = "\(deliveryChargesPrice) \("AED".localizedString)"
                    deliveryChargesPriceLabel.isHidden = false
                    deliveryChargesTitleLabel.isHidden = false
                    
                    minimumOrderTitleLabel.text = "RestaurantMinOrder".localizedString
                    deliveryChargesTitleLabel.text = "DeliveryCharges".localizedString
                } else if let minimumOrderPrice = nearbyOffer.minimumOrder, minimumOrderPrice > 0.0 {
                    minimumOrderPriceLabel.isHidden = false
                    minimumOrderTitleLabel.isHidden = false
                    minimumOrderSeparatorView.isHidden = true
                    deliveryChargesPriceLabel.isHidden = true
                    deliveryChargesTitleLabel.isHidden = true
                    
                    minimumOrderPriceLabel.text = "\(minimumOrderPrice) \("AED".localizedString)"
                    minimumOrderTitleLabel.text = "RestaurantMinOrder".localizedString
                } else if let deliveryChargesPrice = nearbyOffer.deliveryCharges, deliveryChargesPrice > 0.0 {
                    minimumOrderPriceLabel.isHidden = true
                    minimumOrderTitleLabel.isHidden = true
                    minimumOrderSeparatorView.isHidden = true
                    deliveryChargesPriceLabel.isHidden = false
                    deliveryChargesTitleLabel.isHidden = false
                    
                    deliveryChargesPriceLabel.text = "\(deliveryChargesPrice) \("AED".localizedString)"
                    deliveryChargesTitleLabel.text = "DeliveryCharges".localizedString
                } else {
                    minimumOrderPriceLabel.isHidden = true
                    minimumOrderTitleLabel.isHidden = true
                    minimumOrderSeparatorView.isHidden = true
                    deliveryChargesPriceLabel.isHidden = true
                    deliveryChargesTitleLabel.isHidden = true
                }
            }
        case .none:
            return
        }
    }
    
    private func updateOfferView(for restaurant: Restaurant) {
        if let bogoOffer = restaurant.isBogo, let restaurantStatus = restaurant.restaurantStatus, bogoOffer, restaurantStatus {
            offerView.isHidden = false
            offerLabel.text = "bogoTabbarTitle".localizedString.uppercased()
            offerView.backgroundColor = .appRevampPurpleBGColor
        } else if let offerTag = restaurant.offerDiscountText, let status = restaurant.restaurantStatus, status {
            offerView.isHidden = false
            offerView.backgroundColor = .appRevampPurpleBGColor
            offerLabel.text = offerTag
        } else {
            offerView.isHidden = true
            offerLabel.text = ""
        }
    }
    
    private func updateOfferView(for offer: OfferDO) {
        switch offer.recommendationModelType {
        case .food:
            if let offerPromotionText = offer.offerPromotionText, !offerPromotionText.isEmpty {
                offerLabel.text = offerPromotionText
                offerView.isHidden = false
            } else {
                offerView.isHidden = true
            }
            
        case .offer:
            if let voucherPromotionText = offer.voucherPromoText, !voucherPromotionText.isEmpty {
                offerLabel.text = voucherPromotionText
                offerView.isHidden = false
            } else {
                if let offerType = offer.offerType {
                    offerLabel.text = !AppCommonMethods.languageIsArabic() ? offerType : offer.offerTypeAr.asStringOrEmpty()
                    offerView.isHidden = false
                } else {
//                    offerLabel.text = "Cash voucher".localizedString
                    offerView.isHidden = true
                }
            }
            
        case .none:
            offerView.isHidden = true
        }
    }

    private func updateUIWithOpenRestaurant(restaurant: Restaurant) {
        enableCell(true)
        closingTimeView.isHidden = true

        restaurantDistanceLabel.textColor = .appRevampLocationTextColor
        locationLabel.textColor = .appRevampLocationTextColor
        locationImageView.isHidden = false

        handleStateForOrderType(restaurant: restaurant)
    }

    private func updateUIWithWillOpenRestaurant(restaurant: Restaurant) {
        enableCell(false)

        restaurantStatusImageView.image = UIImage(named: "opensAtIcon")
        restaurantStatusLabel.text = restaurant.restaurantStatusMessage.asStringOrEmpty()
        
        closingTimeView.isHidden = true
        
        restaurantDistanceView.isHidden = true
        restaurantDistanceImageView.image = UIImage(named: "recentLocation")
        restaurantDistanceImageView.isHidden = false
        restaurantDistanceLabel.textColor = .appRevampLocationTextColor
        
        handleStateForOrderType(restaurant: restaurant)
    }

    private func updateUIWithWillCloseRestaurant(restaurant: Restaurant) {
        enableCell(true)
        
        closingTimeView.isHidden = false
        closingTimeLabel.text = restaurant.restaurantStatusMessage.asStringOrEmpty()

        restaurantDistanceView.isHidden = true
        restaurantDistanceImageView.isHidden = true
        restaurantDistanceLabel.textColor = .appRevampLocationTextColor
        
        handleStateForOrderType(restaurant: restaurant)
    }

    private func updateUIWithClosedRestaurant(restaurant: Restaurant) {
        enableCell(false)

        closingTimeView.isHidden = true

        restaurantDistanceView.isHidden = true
        restaurantDistanceImageView.isHidden = false
        restaurantDistanceLabel.textColor = .appRevampLocationTextColor
        restaurantDistanceImageView.image = UIImage(named: "closed")
        
        handleStateForOrderType(restaurant: restaurant)
    }

    private func updateUIWithTemporaryClosedRestaurant(restaurant: Restaurant) {
        enableCell(false)
//        locationView.isHidden = true
        
        closingTimeView.isHidden = true

        restaurantStatusImageView.image = UIImage(named: "temporarilyClosedIcon")
        restaurantStatusLabel.text = restaurant.restaurantStatusMessage.asStringOrEmpty()
        
        restaurantDistanceView.isHidden = true
        restaurantDistanceImageView.isHidden = false
        restaurantDistanceLabel.textColor = .appRevampLocationTextColor
        restaurantDistanceImageView.image = UIImage(named: "closed")
        
        handleStateForOrderType(restaurant: restaurant)
    }

    private func enableCell(_ enable: Bool) {
        dimmedView.alpha = enable ? 1.0 : 0.5
    }
    
    private func handleStateForOrderType(restaurant: Restaurant) {
        if restaurant.restaurantOrderType == .isDelivery || restaurant.restaurantOrderType == .isDeliveryAndPickup {
            restaurantDistanceImageView.image = UIImage(assetIdentifier: .pin)
            restaurantDistanceView.isHidden = true
            minimumOrderStackView.isHidden = false
            locationImageView.image = UIImage(named: "timeIcon")

            if let delivery = restaurant.deliveryTimeRange, !delivery.isEmpty {
                locationLabel.text = String(format: "MinsDeliveryKey".localizedString, "\(delivery)")
                locationView.isHidden = false
            } else {
                locationView.isHidden = true
            }
        } else if restaurant.restaurantOrderType == .isPickup {
            // Pickonly
            minimumOrderStackView.isHidden = true
            restaurantDistanceView.isHidden = false
            restaurantDistanceImageView.isHidden = false
            restaurantDistanceImageView.image = UIImage(named: "bag-icon")
            locationView.isHidden = false
            
            locationLabel.text = restaurant.location.asStringOrEmpty()
            locationImageView.image = UIImage(named: "map-witth-pin")
            
            if let distance = restaurant.restaurantDistance, distance > 0 {
                if distance < 1 {
                    let distance = floor(distance * 1000)
                    let restaurantDistance = String(format: "%.2f", distance) + " " + "meter".localizedString
                    if AppCommonMethods.languageIsArabic() {
                        restaurantDistanceLabel.text =  "away".localizedString + " " + restaurantDistance
                    } else {
                        restaurantDistanceLabel.text = restaurantDistance + " " + "away".localizedString
                    }
                } else {
                    let restaurantDistance = "\(distance)" + " " + "KiloMeter".localizedString

                    if AppCommonMethods.languageIsArabic() {
                        restaurantDistanceLabel.text =  "away".localizedString + " " + restaurantDistance
                    } else {
                        restaurantDistanceLabel.text = restaurantDistance + " " + "away".localizedString
                    }
                }
            } else {
                let restaurantDistance = String(format: "%.f", 0.0) + " " + "meter".localizedString
                if AppCommonMethods.languageIsArabic() {
                    restaurantDistanceLabel.text =  "away".localizedString + " " + restaurantDistance
                } else {
                    restaurantDistanceLabel.text = restaurantDistance + " " + "away".localizedString
                }
            }

            if let isVirtualRestaurant = restaurant.isVirtualRestaurant, !isVirtualRestaurant {
                restaurantDistanceView.isHidden = false
                locationView.isHidden = false
            } else {
                restaurantDistanceView.isHidden = true
                locationView.isHidden = true
            }
        } else {
            restaurantDistanceView.isHidden = true
            closingTimeView.isHidden = true
            
            locationImageView.image = UIImage(named: "timeIcon")

            if let delivery = restaurant.deliveryTimeRange, !delivery.isEmpty {
                locationLabel.text = String(format: "MinsDeliveryKey".localizedString, "\(delivery)")
                locationView.isHidden = false
            } else {
                locationView.isHidden = true
            }
        }
    }
    
    func setPointsIcon(with iconURL: String?) {
        if let iconJsonAnimationUrl = iconURL, !iconJsonAnimationUrl.isEmpty {
            lottieAnimationView.isHidden = false
            pointsIcon.isHidden = true
            lottieAnimationView.subviews.forEach({ $0.removeFromSuperview() })
            LottieAnimationManager.showAnimationFromUrl(FromUrl: iconJsonAnimationUrl, animationBackgroundView: self.lottieAnimationView, removeFromSuper: false, loopMode: .playOnce, shouldAnimate: false) { _ in }
            
        } else {
            pointsIcon.isHidden = false
            lottieAnimationView.isHidden = true
        }
    }
}
