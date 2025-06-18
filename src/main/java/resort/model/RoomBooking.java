package resort.model;

public class RoomBooking {
    private int roomID;
    private String roomType;
    private double price;
    private int quantity;

    // Constructor to initialize RoomBooking
    public RoomBooking(int roomID, String roomType, double price, int quantity) {
        this.roomID = roomID;
        this.roomType = roomType;
        this.price = price;
        this.quantity = quantity;
    }

    // Getters
    public int getRoomID() {
        return roomID;
    }

    public String getRoomType() {
        return roomType;
    }

    public double getPrice() {
        return price;
    }

    public int getQuantity() {
        return quantity;
    }

    // Setters (Optional, only if needed)
    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
