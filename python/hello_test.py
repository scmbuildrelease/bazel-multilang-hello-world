import unittest
from hello import greeting

class HelloTest(unittest.TestCase):
    def test_greeting(self):
        self.assertEqual(greeting(), "Hello from Python + Bazel!")

if __name__ == "__main__":
    unittest.main()
