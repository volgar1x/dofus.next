import React from 'react';
import UserForm from './users/form';
import Header from './header';
import Navbar from './navbar';

class Component extends React.Component {
    render() {
        return (
            <div>
                <Navbar/>

                <div className="container">
                    <div className="row">
                        <Header/>
                    </div>

                    <div className="row">
                        <UserForm/>
                    </div>
                </div>
            </div>
        );
    }
}

React.render(<Component/>, document.getElementById("app"));
