package resort.model;

import java.sql.Date;

public class Booking {
    private int bookingID;
    private String roomType;
    private Date checkInDate;
    private Date checkOutDate;
    private double totalPrice;
    private String status;

    public Booking(int bookingID, String roomType, Date checkInDate, Date checkOutDate, double totalPrice, String status) {
        this.bookingID = bookingID;
        this.roomType = roomType;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.totalPrice = totalPrice;
        this.status = status;
    }

    public int getBookingID() { return bookingID; }
    public String getRoomType() { return roomType; }
    public Date getCheckInDate() { return checkInDate; }
    public Date getCheckOutDate() { return checkOutDate; }
    public double getTotalPrice() { return totalPrice; }
    public String getStatus() { return status; }
}
