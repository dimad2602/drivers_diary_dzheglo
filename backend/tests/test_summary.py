import datetime as dt
import random

import pytest

from app.domain.summary import calculate_summary
from app.schemas.payment import PaymentMethod
from tests.factories import make_trip

DAY = dt.date(2026, 10, 1)


def test_summary_for_example_from_assignment():
    trips = [
        make_trip("t1", amount=2400, payment=PaymentMethod.CARD, commission=360),
        make_trip("t2", amount=1500, payment=PaymentMethod.CASH, commission=225),
    ]

    summary = calculate_summary(DAY, trips)

    assert summary.date == DAY
    assert summary.trips_count == 2
    assert summary.revenue == 3900
    assert summary.commission == 585
    assert summary.net == 3315
    assert summary.by_payment.card.model_dump() == {
        "trips_count": 1,
        "revenue": 2400,
        "commission": 360,
        "net": 2040,
    }
    assert summary.by_payment.cash.model_dump() == {
        "trips_count": 1,
        "revenue": 1500,
        "commission": 225,
        "net": 1275,
    }


def test_empty_day_has_zeroes_and_both_payment_buckets():
    summary = calculate_summary(DAY, [])

    assert summary.trips_count == 0
    assert summary.revenue == summary.commission == summary.net == 0
    assert summary.by_payment.cash.trips_count == 0
    assert summary.by_payment.card.trips_count == 0
    assert summary.by_payment.cash.net == 0
    assert summary.by_payment.card.net == 0


@pytest.mark.parametrize("method", list(PaymentMethod))
def test_single_payment_method_leaves_other_bucket_empty(method):
    other = PaymentMethod.CARD if method is PaymentMethod.CASH else PaymentMethod.CASH
    trips = [
        make_trip("a", amount=1000, payment=method, commission=100),
        make_trip("b", amount=500, payment=method, commission=50),
    ]

    summary = calculate_summary(DAY, trips)

    used = getattr(summary.by_payment, method.value)
    unused = getattr(summary.by_payment, other.value)
    assert (used.trips_count, used.revenue, used.commission, used.net) == (2, 1500, 150, 1350)
    assert (unused.trips_count, unused.revenue, unused.commission, unused.net) == (0, 0, 0, 0)
    assert summary.net == 1350


def test_zero_commission_means_net_equals_revenue():
    summary = calculate_summary(DAY, [make_trip("a", amount=700, commission=0)])

    assert summary.revenue == 700
    assert summary.net == 700


def test_commission_equal_to_amount_gives_zero_net():
    summary = calculate_summary(DAY, [make_trip("a", amount=700, commission=700)])

    assert summary.net == 0


def test_accepts_any_iterable():
    trips = (make_trip(f"t{i}", amount=100, commission=10) for i in range(3))

    summary = calculate_summary(DAY, trips)

    assert summary.trips_count == 3
    assert summary.revenue == 300


def test_totals_are_consistent_with_breakdown_for_random_trips():
    rng = random.Random(42)
    trips = []
    for i in range(200):
        amount = rng.randint(100, 20_000)
        trips.append(
            make_trip(
                f"t{i}",
                amount=amount,
                payment=rng.choice(list(PaymentMethod)),
                commission=rng.randint(0, amount),
            )
        )

    summary = calculate_summary(DAY, trips)

    cash, card = summary.by_payment.cash, summary.by_payment.card
    assert summary.trips_count == len(trips) == cash.trips_count + card.trips_count
    assert summary.revenue == sum(t.amount for t in trips) == cash.revenue + card.revenue
    assert summary.commission == sum(t.commission for t in trips)
    assert summary.net == summary.revenue - summary.commission == cash.net + card.net
