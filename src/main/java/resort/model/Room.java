package resort.model;

public class Room {
    private int roomID;
    private String roomType;
    private String roomStatus;
    private double roomPrice;
    private int staffID;

    // Constructor
    public Room(int roomID, String roomType, String roomStatus, double roomPrice, int staffID) {
        this.roomID = roomID;
        this.roomType = roomType;
        this.roomStatus = roomStatus;
        this.roomPrice = roomPrice;
        this.staffID = staffID;
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

    public String getRoomStatus() {
        return roomStatus;
    }

    public void setRoomStatus(String roomStatus) {
        this.roomStatus = roomStatus;
    }

    public double getRoomPrice() {
        return roomPrice;
    }

    public void setRoomPrice(double roomPrice) {
        this.roomPrice = roomPrice;
    }

    public int getStaffID() {
        return staffID;
    }

    public void setStaffID(int staffID) {
        this.staffID = staffID;
    }
}
