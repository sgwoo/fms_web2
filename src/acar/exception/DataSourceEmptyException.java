package acar.exception;


public class DataSourceEmptyException extends Exception {
  
  public DataSourceEmptyException() {
    super();
  }

  public DataSourceEmptyException(String msg) {
    super(msg);
  }
}
