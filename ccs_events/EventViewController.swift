//
//  EventViewController.swift
//  ccs_events
//
//  Created by Amir Nazari on 9/19/16.
//  Copyright © 2016 Amir Nazari. All rights reserved.
//

import UIKit

let toEventDetail = "toEventDetail"

class EventViewController: UIViewController {

    @IBOutlet weak var eventTableView: UITableView!
    
    var savedEvents : [Event] = []
    var selectedEvent : Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedEvents.append(Event(eventName: "Obra Escolar", eventDate: "30/10/2016", eventLocation: "Auditorio Principal", eventTime: "14:00-18:00", eventDescription: "CCS será la presentación de la \"Pesadilla antes de Navidad\". La clase de cuarto grado estará poniendo un gran espectáculo! Por favor asegúrese de llegar temprano como asientos será \"primero que llega\". Salir y mostrar su apoyo!", eventImage: #imageLiteral(resourceName: "NightmareBeforeChristmasWallpaper1024")))
        
        savedEvents.append(Event(eventName: "Junta General de Padres", eventDate: "15/12/2016", eventLocation: "Auditorio Principal", eventTime: "14:00-18:00", eventDescription: "CCS tendrá una reunión para discutir los planes del año próximo. Este será un evento opcional para los padres, pero, es muy recomendable que asista. Esta reunión ayudará a prepararse mejor para el próximo año escolar de su hijo.", eventImage: #imageLiteral(resourceName: "IMG_1122")))
        
        savedEvents.append(Event(eventName: "¡Fuegos artificiales!", eventDate: "15/12/2016", eventLocation: "Parque Central", eventTime: "18:00-20:00", eventDescription: "Vamos a tener un fuego artificial asombrosa espectacular. Por favor, siéntase libre de traer a toda su familia a Central Park durante el tiempo de su vida!", eventImage: #imageLiteral(resourceName: "sporting-event-limo-service----")))
        
        eventTableView.register(UINib.init(nibName: "eventCellTableViewCell", bundle: nil), forCellReuseIdentifier: "cellId")
        eventTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let eventDetailVC = segue.destination as? EventDetailViewController {
            eventDetailVC.passedEvent = selectedEvent
        }
    }
}

extension EventViewController : UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Required Methods
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as? eventCellTableViewCell else {
            return UITableViewCell()
        }
        
        let elEvent = savedEvents[indexPath.row]
        
        cell.eventTitle.text = elEvent.eventName
        cell.eventImage.image = elEvent.eventImage
        cell.eventDescription.text = elEvent.eventDescription
        
        return cell
        
    }

    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedEvents.count
    }
    
    //MARK: Optional Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEvent = savedEvents[indexPath.row]
        performSegue(withIdentifier: toEventDetail, sender: self)
    }
}
