package com.fepoc.vf;

import java.util.List;

import com.fepoc.vf.metadata.edit.BaseEditFunction;

/**
 * 
 * @author cw22is2
 *
 * @param <E>
 * @see com.fepoc.vf.metadata.edit.Compatibility
 * @see com.fepoc.vf.metadata.edit.PlanSpecific
 * @see com.fepoc.vf.metadata.edit.Validity
 * @see com.fepoc.vf.metadata.edit.WorkflowEditResponse
 */
public class ValidationResponse<E extends BaseEditFunction> {
	private List<E> responses;
	
	
	public List<E> getResponses(){
		return responses;
	}
	

}
