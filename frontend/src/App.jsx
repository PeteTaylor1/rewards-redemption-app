import { useState, useEffect } from 'react'
import './App.css'

const API_BASE = 'http://localhost:3000/api'
const DEMO_USER_ID = 1

async function api(path, options = {}) {
  const res = await fetch(`${API_BASE}${path}`, {
    headers: { 'Content-Type': 'application/json', ...options.headers },
    ...options
  })
  const data = await res.json().catch(() => ({}))
  if (!res.ok) throw new Error(data.error || res.statusText || 'Request failed')
  return data
}

function App() {
  const [user, setUser] = useState(null)
  const [rewards, setRewards] = useState([])
  const [redemptions, setRedemptions] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [redeeming, setRedeeming] = useState(null)
  const [message, setMessage] = useState(null)

  const fetchAll = async () => {
    setLoading(true)
    setError(null)
    try {
      const [userData, rewardsData, redemptionsData] = await Promise.all([
        api(`/users/${DEMO_USER_ID}`),
        api('/rewards'),
        api('/redemptions')
      ])
      setUser(userData)
      setRewards(rewardsData)
      setRedemptions(redemptionsData)
    } catch (err) {
      setError(err.message || 'Failed to load data')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    fetchAll()
  }, [])

  const handleRedeem = async (rewardId) => {
    setRedeeming(rewardId)
    setMessage(null)
    setError(null)
    try {
      const res = await api('/redemptions', {
        method: 'POST',
        body: JSON.stringify({ reward_id: rewardId })
      })
      setMessage(`Successfully redeemed "${res.reward_name}"! Remaining balance: ${res.remaining_balance} points.`)
      await fetchAll()
    } catch (err) {
      setError(err.message || 'Redemption failed')
    } finally {
      setRedeeming(null)
    }
  }

  if (loading) {
    return (
      <div className="app">
        <div className="loading">Loading rewards...</div>
      </div>
    )
  }

  return (
    <div className="app">
      <header className="header">
        <h1>Rewards Redemption</h1>
        {user && (
          <div className="balance-card">
            <span className="label">Points Balance</span>
            <span className="points">{user.points_balance.toLocaleString()}</span>
            <span className="user-name">{user.name}</span>
          </div>
        )}
      </header>

      {error && <div className="alert alert-error">{error}</div>}
      {message && <div className="alert alert-success">{message}</div>}

      <main className="main">
        <section className="section">
          <h2>Available Rewards</h2>
          <div className="rewards-grid">
            {rewards.map((reward) => {
              const canAfford = user && user.points_balance >= reward.points_cost
              return (
                <div key={reward.id} className={`reward-card ${!canAfford ? 'unaffordable' : ''}`}>
                  <h3>{reward.name}</h3>
                  <p className="description">{reward.description}</p>
                  <div className="reward-footer">
                    <span className="cost">{reward.points_cost} pts</span>
                    <button
                      onClick={() => handleRedeem(reward.id)}
                      disabled={!canAfford || redeeming === reward.id}
                      className="btn-redeem"
                    >
                      {redeeming === reward.id ? 'Redeeming...' : canAfford ? 'Redeem' : 'Not enough points'}
                    </button>
                  </div>
                </div>
              )
            })}
          </div>
        </section>

        <section className="section">
          <h2>Redemption History</h2>
          {redemptions.length === 0 ? (
            <p className="empty">No redemptions yet. Redeem a reward to see history here.</p>
          ) : (
            <ul className="history-list">
              {redemptions.map((r) => (
                <li key={r.id}>
                  <span className="history-name">{r.reward_name}</span>
                  <span className="history-points">-{r.points_spent} pts</span>
                  <span className="history-date">
                    {new Date(r.redeemed_at).toLocaleString()}
                  </span>
                </li>
              ))}
            </ul>
          )}
        </section>
      </main>

      <footer className="footer">
        <p>Thanx-style take-home challenge · React + Rails + MySQL</p>
      </footer>
    </div>
  )
}

export default App
