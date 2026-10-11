package com.example.hello;
public final class Hello {
  private Hello() {}
  public static String greeting() { return "Hello from Java + Bazel!"; }
  public static void main(String[] args) { System.out.println(greeting()); }
}
