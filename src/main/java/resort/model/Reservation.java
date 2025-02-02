package resort.model;

import java.sql.Date;

public class Reservation {
    private int reservationID;
    private Date reservationDate;
    private Date checkInDate;
    private Date checkOutDate;
    private int totalAdult;
    private int totalKids;
    private int roomID;
    private String roomType;
    private int customerID;
    private String customerName;
    private double totalPayment;
    private int serviceID;

    public Reservation(int reservationID, Date reservationDate, Date checkInDate, Date checkOutDate, int totalAdult, int totalKids,
                       int roomID, String roomType, int customerID, String customerName, double totalPayment, int serviceID) {
        this.reservationID = reservationID;
        this.reservationDate = reservationDate;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.totalAdult = totalAdult;
        this.totalKids = totalKids;
        this.roomID = roomID;
        this.roomType = roomType;
        this.customerID = customerID;
        this.customerName = customerName;
        this.totalPayment = totalPayment;
        this.serviceID = serviceID;
    }

    public int getReservationID() { return reservationID; }
    public Date getReservationDate() { return reservationDate; }
    public Date getCheckInDate() { return checkInDate; }
    public Date getCheckOutDate() { return checkOutDate; }
    public int getTotalAdult() { return totalAdult; }
    public int getTotalKids() { return totalKids; }
    public int getRoomID() { return roomID; }
    public String getRoomType() { return roomType; }
    public int getCustomerID() { return customerID; }
    public String getCustomerName() { return customerName; }
    public double getTotalPayment() { return totalPayment; }
    public int getServiceID() { return serviceID; }
}
