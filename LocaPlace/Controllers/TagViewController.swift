//
//  TagViewController.swift
//  LocaPlace
//
//  Created by KODDER on 09.09.2023.
//

import UIKit
import CoreLocation

class TagViewController: UIViewController {
    
    // MARK: - UI
    private let messageLabel = UILabel(text: "MessageLabel")
    private let latitudeNameLabel = UILabel(text: "Latitude:")
    private let latitudeLabel = UILabel(text: "Latitude goes here")
    private let longitudeNameLabel = UILabel(text: "Longitude:")
    private let longitudeLabel = UILabel(text: "Longitude goes here")
    private let addressLabel = UILabel(text: "Address goes here")
    
    private var latitudeStackView = UIStackView()
    private var longitudeStackView = UIStackView()
    
    private lazy var tagButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tag Location", for: .normal)
        button.addTarget(self, action: #selector(tagButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemFill
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var getButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get my location", for: .normal)
        button.addTarget(self, action: #selector(getButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemFill
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: Error?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        updateLabels()
    }
    
    // MARK: - Helper Methods
    func updateLabels() {
        var statusMessage: String
        if let location = location {
            latitudeLabel.text = String(format: "%.8f",
                                        location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f",
                                         location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain &&
                    error.code == CLError.denied.rawValue {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to Start"
            }
            messageLabel.text = statusMessage
        }
    }
    
    func startLocationManager() {
        if !updatingLocation {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.startUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    
    @objc private func tagButtonTapped() {
        print(#function)
    }
    
    @objc private func getButtonTapped() {
        
        let authStatus = locationManager.authorizationStatus
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert("Location Services Disabled",
                                            message: "Please enable location services for this app in Settings.")
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        startLocationManager()
        updateLabels()
    }
}

// MARK: - CLLocationManagerDelegate

extension TagViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("*** didFailWithError \(error.localizedDescription)")
        
        guard (error as NSError).code == CLError.locationUnknown.rawValue else { return }
        lastLocationError = error
        startLocationManager()
        updateLabels()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            print("*** didUpdateLocations \(newLocation)")
            location = newLocation
            lastLocationError = nil
            updateLabels()
        }
    }
}

// MARK: - Setup View and Constraints

extension TagViewController {
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(messageLabel)
        
        latitudeStackView = UIStackView(arrangedSubviews: [latitudeNameLabel, latitudeLabel],
                                        axis: .horizontal, spacing: 40)
        
        longitudeStackView = UIStackView(arrangedSubviews: [longitudeNameLabel, longitudeLabel],
                                         axis: .horizontal, spacing: 40)
        view.addSubview(latitudeStackView)
        view.addSubview(longitudeStackView)
        
        addressLabel.numberOfLines = 3
        view.addSubview(addressLabel)
        
        view.addSubview(tagButton)
        view.addSubview(getButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            latitudeStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 40),
            latitudeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            latitudeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            longitudeStackView.topAnchor.constraint(equalTo: latitudeStackView.bottomAnchor, constant: 20),
            longitudeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            longitudeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addressLabel.topAnchor.constraint(equalTo: longitudeStackView.bottomAnchor, constant: 30),
            addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tagButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tagButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            tagButton.heightAnchor.constraint(equalToConstant: 40),
            tagButton.widthAnchor.constraint(equalToConstant: 140),
            
            getButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130),
            getButton.heightAnchor.constraint(equalToConstant: 40),
            getButton.widthAnchor.constraint(equalToConstant: 140),
        ])
    }
}
