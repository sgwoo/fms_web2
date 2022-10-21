package acar.exception;

public class UnknownDataException extends DatabaseException {

  public UnknownDataException() {
    super();
  }

  public UnknownDataException(String msg) {
    super(msg); 
  }
}