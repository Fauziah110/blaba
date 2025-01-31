package resort.model;

public class Service {
    private int serviceId;
    private String serviceType;
    private double serviceCharge;
    private int roomId; // Assuming roomId is an integer, adjust as needed

    // Constructors
    public Service() {}

    public Service(int serviceId, String serviceType, double serviceCharge, int roomId) {
        this.serviceId = serviceId;
        this.serviceType = serviceType;
        this.serviceCharge = serviceCharge;
        this.roomId = roomId;
    }

    // Getters and Setters
    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public double getServiceCharge() {
        return serviceCharge;
    }

    public void setServiceCharge(double serviceCharge) {
        this.serviceCharge = serviceCharge;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }
}
