/**
 * supply_dataset_file.jsx: file upload fieldset.
 *
 * @SupplyDatasetFile, must be capitalized in order for reactjs to render it as
 *     a component. Otherwise, the variable is rendered as a dom node.
 *
 * Note: this script implements jsx (reactjs) syntax.
 */

var SupplyDatasetFile = React.createClass({
  // initial 'state properties'
    getInitialState: function() {
        return {
            value: null
        };
     },
  // update 'state properties': allow parent component(s) to access properties
     validStringEntered: function(event){
        if (typeof event.target.value === 'string' && String(event.target.value).length > 0) {
            this.props.onChange({display_submit: true});
        }
        else {
            this.props.onChange({display_submit: false});
        }
     },
  // triggered when 'state properties' change
     render: function(){
        return(
            <div>
                <fieldset className='fieldset-supply-dataset'>
                    <legend>Supply Dataset</legend>
                    <input type='file' name='svm_dataset[]' className='svm-dataset-file' onChange={this.validStringEntered} value={this.state.value} />
                    <input type='button' value='Add more' className='add-element svm-dataset-file-add' />
                    <input type='button' value='Remove' className='remove-element svm-dataset-file-remove' />
                    <p className='form-note'>*<span className='bold'>Note:</span> Uploaded file(s) must be formatted as <span className='italic'>csv</span>, <span className='italic'>json</span>, or <span className='italic'>xml</span> format.</p>
                </fieldset>
            </div>
        );
     }
});

// indicate which class can be exported, and instantiated via 'require'
export default SupplyDatasetFile