"""Unit tests: python3 -m unittest discover -s tests

Covers the pure logic. The recorded human review is replayed separately by
`set-theme selftest`, which is the test that guards the thresholds.
"""

import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from settheme.color import Color
from settheme.overrides import Overrides
from settheme.selection import Reason, is_usable_seed, select


class TestColor(unittest.TestCase):
    def test_parses_with_and_without_hash(self):
        self.assertEqual(Color.from_hex("284827").hex, "#284827")
        self.assertEqual(Color.from_hex("#284827").hex, "#284827")

    def test_hsl_matches_known_values(self):
        c = Color.from_hex("#0f1517")          # the near-black that started this
        self.assertAlmostEqual(c.hue, 195, delta=1)
        self.assertAlmostEqual(c.lightness, 0.075, places=2)
        self.assertAlmostEqual(c.saturation, 0.21, places=2)

    def test_low_saturation_reads_as_grey_not_a_hue(self):
        self.assertEqual(Color.from_hex("#66767c").hue_name, "grey")   # S=0.097
        self.assertEqual(Color.from_hex("#284827").hue_name, "green")

    def test_grey_cutoff_is_a_narrow_boundary(self):
        # #85839a is S=0.102 -- just above the cutoff, so it still names a hue.
        # Naming is descriptive only; selection never branches on hue_name.
        self.assertEqual(Color.from_hex("#85839a").hue_name, "blue")

    def test_rejects_malformed_input(self):
        for bad in ("#abc", "", "ggggggg", "#12345"):
            with self.assertRaises(ValueError):
                Color.from_hex(bad)


class TestUsability(unittest.TestCase):
    def test_near_black_is_unusable_however_saturated_its_hue_computes(self):
        self.assertFalse(is_usable_seed(Color.from_hex("#0f1517")))

    def test_near_grey_is_unusable(self):
        self.assertFalse(is_usable_seed(Color.from_hex("#85839a")))

    def test_dark_but_saturated_is_usable(self):
        # japan-city-night's deep blue: sets the lower bound on MIN_LIGHTNESS
        self.assertTrue(is_usable_seed(Color.from_hex("#033454")))

    def test_muted_but_light_enough_is_usable(self):
        # minecraft-forest-house's misty blue: sets the bound on MIN_SATURATION
        self.assertTrue(is_usable_seed(Color.from_hex("#404755")))


class TestSelection(unittest.TestCase):
    def _colors(self, *hexes):
        return [Color.from_hex(h) for h in hexes]

    def test_prefers_dominant_when_usable(self):
        result = select(self._colors("#275c94", "#e38d8f"))
        self.assertEqual(result.index, 0)
        self.assertIs(result.reason, Reason.DOMINANT)

    def test_skips_unusable_dominant(self):
        result = select(self._colors("#0f1517", "#111b1b", "#284827"))
        self.assertEqual(result.index, 2)
        self.assertIs(result.reason, Reason.SKIPPED_UNUSABLE)

    def test_falls_back_to_dominant_when_nothing_qualifies(self):
        result = select(self._colors("#0f1517", "#101010"))
        self.assertEqual(result.index, 0)
        self.assertIs(result.reason, Reason.NO_USABLE_CANDIDATE)

    def test_pin_wins_over_heuristic(self):
        result = select(self._colors("#70bdd9", "#eed774"), pinned_index=1,
                        pinned_note="the train")
        self.assertEqual(result.index, 1)
        self.assertIs(result.reason, Reason.PINNED)
        self.assertIn("the train", result.explain())

    def test_pin_can_select_an_unusable_candidate(self):
        # An explicit pin is a human decision; the floors must not veto it.
        result = select(self._colors("#275c94", "#0f1517"), pinned_index=1)
        self.assertEqual(result.index, 1)

    def test_out_of_range_pin_is_an_error_not_a_silent_fallback(self):
        with self.assertRaises(IndexError):
            select(self._colors("#275c94"), pinned_index=9)

    def test_empty_candidates_is_an_error(self):
        with self.assertRaises(ValueError):
            select([])


class TestOverrides(unittest.TestCase):
    def setUp(self):
        self.path = Path(tempfile.mkdtemp()) / "overrides.toml"

    def test_missing_file_loads_as_empty(self):
        self.assertEqual(len(Overrides.load(self.path)), 0)

    def test_round_trip_preserves_notes_and_quoting(self):
        o = Overrides.load(self.path)
        o.set("a.jpg", 1, 'the train\'s "yellow"')
        o.save()
        self.assertEqual(Overrides.load(self.path).get("a.jpg").note,
                         'the train\'s "yellow"')

    def test_unset_reports_whether_it_removed_anything(self):
        o = Overrides.load(self.path)
        o.set("a.jpg", 1)
        self.assertTrue(o.unset("a.jpg"))
        self.assertFalse(o.unset("a.jpg"))

    def test_rejects_malformed_entries(self):
        self.path.write_text('["a.jpg"]\nindex = -1\n')
        with self.assertRaises(ValueError):
            Overrides.load(self.path)
        self.path.write_text('"a.jpg" = 1\n')
        with self.assertRaises(ValueError):
            Overrides.load(self.path)


if __name__ == "__main__":
    unittest.main()
