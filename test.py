from unittest import TestCase

import ex6


class Swigtest(TestCase):
    def test_is_class(self):
        s = ex6
        assert True

    def test_is_SS(self):
        s = ex6.SS()
        self.assertIsInstance(s, ex6.SS)

    def test_Sum_Method(self):
        s = ex6.SS()
        self.assertEqual(s.Sum(1, 2), 3)
        self.assertEqual(s.Sum(5, 5), 10)

        # These should not work
        # C++ Expects an int - not float
        self.assertRaises(TypeError, s.Sum, **{"a": 5.9, "b": 5.9})
        self.assertRaises(TypeError, s.Sum, **{"a": 5, "b": 5.9})
        self.assertRaises(TypeError, s.Sum, **{"a": 5.9, "b": 5})


    def test_Sum_from_c_Method(self):
        s = ex6.SS()
        self.assertEqual(s.Sum_from_c(1, 2), 3)
        self.assertEqual(s.Sum_from_c(5, 5), 10)
        # These should not work
        # C++ Expects an int - not float
        self.assertRaises(TypeError, s.Sum_from_c, **{"a": 5.9, "b": 5.9})
        self.assertRaises(TypeError, s.Sum_from_c, **{"a": 5, "b": 5.9})
        self.assertRaises(TypeError, s.Sum_from_c, **{"a": 5.9, "b": 5})

