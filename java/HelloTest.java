package com.example.hello;
import org.junit.Test;
import static org.junit.Assert.assertEquals;
public final class HelloTest {
  @Test public void greetingIsCorrect() {
    assertEquals("Hello from Java + Bazel!", Hello.greeting());
  }
}
