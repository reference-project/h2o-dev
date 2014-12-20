package water.exceptions;

import water.util.IcedHashMap;

public class H2OIllegalValueException extends H2ORuntimeException {
  public H2OIllegalValueException(String field, Object value) {
    super("Illegal value for field: " + field + ": " + value.toString(),
          "Illegal value for field: " + field + ": " + value.toString() + " of class: " + value.getClass());
    this.values = new IcedHashMap<String, Object>();
    this.values.put("field", field);
    this.values.put("value", value);

  }

  public H2OIllegalValueException(String field, String object, Object value) {
    super("Illegal value for field: " + field + " of object: " + object + ": " + value.toString(),
          "Illegal value for field: " + field + " of object: " + object + ": " + value.toString() + " of class: " + value.getClass());

    this.values = new IcedHashMap<String, Object>();
    this.values.put("field", field);
    this.values.put("object", object);
    this.values.put("value", value);
  }
}