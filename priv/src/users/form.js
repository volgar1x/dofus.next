import React from 'react/addons';
import {Map, List} from 'immutable';
import cx from 'classnames';
import validate from '../forms/validate';

class Form extends React.Component {
    static childContextTypes = {errors: React.PropTypes.any};

    getChildContext() {
        return {errors: this.state.errors};
    }

    constructor(props) {
        super(props);

        this.state = {
            errors: Map()
        };
    }

    render() {
        return (
            <form className="form-horizontal" onSubmit={this.onSubmit.bind(this)}>
                {React.addons.cloneWithProps(this.props.children)}
            </form>
        );
    }

    onSubmit(e) {
        e.preventDefault();

        var data = {};
        for (let ele of e.target.elements) {
            if ("INPUT" === ele.nodeName && "submit" === ele.type) {
                continue;
            }
            data[ele.name] = ele.value;
        }

        var errors = validate.data(this.props.validate);
        
        if (!errors.isEmpty()) {
            this.props.onSubmit(data);
        }
    }
}

class InputWidget extends React.Component {
    render() {
        var className = cx("form-control", this.props.className);

        return (
            <input type={this.props.type}
                   label={this.props.label}
                   placeholder={this.props.placeholder}
                   id={this.props.id}
                   className={className}
                   name={this.props.name}
                   />
        );
    }
}

class EmailWidget extends React.Component {
    render() {
        var className = cx("form-control", this.props.className);

        return (
            <div className="input-group">
                <span className="input-group-addon">@</span>
                <input type={this.props.type}
                       label={this.props.label}
                       placeholder={this.props.placeholder}
                       id={this.props.name}
                       className={className}
                       name={this.props.name}
                       />
            </div>
        );
    }

}

class Field extends React.Component {
    static contextTypes = {errors: React.PropTypes.any};

    render() {
        var widget;
        if ("email" === this.props.type) {
            widget = (<EmailWidget name={this.props.name}/>);
        } else {
            widget = (<InputWidget type={this.props.type} name={this.props.name}/>);
        }

        var errors = this.context.errors.get(this.props.name, false);

        var helpBlocks = errors && errors.map(err => <span className="help-block">{err}</span>);

        var classNames = cx("form-group", {
            "has-success": errors && !errors.size,
            "has-error": errors && errors.size
        });

        return (
            <div className={classNames}>
                <label htmlFor={this.props.name} className="col-sm-2 control-label">{this.props.label}</label>
                <div className="col-sm-10">
                    {widget}
                    {helpBlocks}
                </div>
            </div>
        );
    }
}

class Actions extends React.Component {
    render() {
        return (
            <div className="form-group">
                <div className="col-sm-offset-2 col-sm-10">
                {this.props.children}
                </div>
            </div>
        );
    }
}

class SubmitAction extends React.Component {
    render() {
        return (<input type="submit" className="btn btn-primary" value={this.props.label}/>);
    }
}

export default class UserForm extends React.Component {
    static validations = List([
        validate.presence('email'),
        validate.presence('name'),
        validate.presence('pass1'),
        validate.presence('pass2'),
        validate.presence('nick'),
        validate.presence('question'),
        validate.same('pass1', 'pass2')
    ]);

    render() {
        return (
            <Form onSubmit={this.onSubmit.bind(this)} validate={UserForm.validations}>
                <Field type="email"    label="Your Email"              name="email"/>
                <Field type="text"     label="Account Name"            name="name"/>
                <Field type="password" label="Password"                name="pass1"/>
                <Field type="password" label="Password (confirmation)" name="pass2"/>
                <Field type="text"     label="Your Nickname"           name="nick"/>
                <Field type="text"     label="Secret Question"         name="question"/>
                <Actions>
                    <SubmitAction label="Create Account"/>
                </Actions>
            </Form>
        );
    }

    onSubmit(data) {
        console.log(data);
    }
}

