/**
 * result_display.jsx: append form submission result.
 *
 * @ResultDisplay, must be capitalized in order for reactjs to render it as a
 *     component. Otherwise, the variable is rendered as a dom node.
 *
 * Note: this script implements jsx (reactjs) syntax.
 */

var ResultDisplay = React.createClass({
  // triggered when 'state properties' change
    render: function(){
        var serverObject = this.props.formResult;
        var displayResult = false;

        if (serverObject && serverObject.result && serverObject.result.result) {
            var result = serverObject.result.result;
            displayResult = true;
        }

        if (displayResult) {
            return(
                <fieldset className='fieldset-prediction-result'>
                    <legend>Prediction Result</legend>
                    <p className='result'>{result}</p>
                </fieldset>
            );
        }
        else {
            return(<span />);
        }
    }
});

// indicate which class can be exported, and instantiated via 'require'
export default ResultDisplay