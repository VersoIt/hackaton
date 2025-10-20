import { useState } from 'react'
import './App.css'

function App() {
    const [count, setCount] = useState(0);

    // Эта часть - самая важная. Она должна возвращать HTML-разметку.
    return (
        <div className="card">
            <h1>ТЕСТ: ВСЁ РАБОТАЕТ!</h1>
            <p>Счетчик: {count}</p>
            <button onClick={() => setCount(count + 1)}>
                Нажми меня
            </button>
        </div>
    );
}

export default App;