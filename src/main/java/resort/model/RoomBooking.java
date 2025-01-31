package resort.model;

public class RoomBooking {
    private int roomID;
    private String roomType;
    private int quantity;
    private double price;

    // Constructor
    public RoomBooking(int roomID, String roomType, int quantity, double price) {
        this.roomID = roomID;
        this.roomType = roomType;
        this.quantity = quantity;
        this.price = price;
    }

    // Getters and Setters
    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}
