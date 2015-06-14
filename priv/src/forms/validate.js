import {Map} from 'immutable';

export default function validate(data, validator) {
    return validator.flatten()
    .reduce((acc, validator) => validator(data, acc), Map())
    ;
}

validate.presence = function(field) {
    return function(data, err) {
        if (!data[field].length) {
            return err.set(field, "Must be present");
        }
        return err;
    };
}

validate.same = function(field1, field2) {
    return function(data, err) {
        if (data[field1] !== field[field2]) {
            return err.set(field1, "Must equal " + field2)
                      .set(field2, "Must equal " + field1);
        }
        return err;
    };
}

