import React from 'react';
import Header from '../components/header/Header.js';
import './aboutpage.css'; // Importing CSS for styling

function AboutPage() {
    const teamMembers = [
        { name: 'David Urrego', role: 'Frontend (Web)' },
        { name: 'Hussen Premier', role: 'Database' },
        { name: 'Jack Gao', role: 'Frontend' },
        { name: 'Luckner Ablard', role: 'Frontend (Mobile)' },
        { name: 'Moses Daniel Cohen', role: 'Frontend (Web)' },
        { name: 'Patrick Rizkalla', role: 'API' },
        { name: 'Raul Graterol', role: 'Frontend (Mobile)' },
        { name: 'Ryan Rahrooh', role: 'Project Manager' }
    ];

    const goHome = () => {
        window.location.href = "/"; // Navigate to the home page
    };

    return (
        <div>
            <Header />
            <div className='about-page'>
                <h1>About Us</h1>
                <div className="team-members">
                    {teamMembers.map((member, index) => (
                        <div key={index} className="member">
                            <h2>{member.name}</h2>
                            <p>{member.role}</p>
                        </div>
                    ))}
                </div>
                <button onClick={goHome} className="home-button">
                    Home
                </button>
            </div>
        </div>
    );
}

export default AboutPage;
