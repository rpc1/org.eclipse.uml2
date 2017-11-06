/*
 * Copyright (c) 2005, 2014 IBM Corporation, CEA, and others.
 * All rights reserved.   This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *   IBM - initial API and implementation
 *   Kenn Hussey (CEA) - 327039, 351774, 418466
 *
 */
package org.eclipse.uml2.uml.tests;

import junit.textui.TestRunner;

import org.eclipse.uml2.uml.AddStructuralFeatureValueAction;
import org.eclipse.uml2.uml.UMLFactory;

/**
 * <!-- begin-user-doc -->
 * A test case for the model object '<em><b>Add Structural Feature Value Action</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following operations are tested:
 * <ul>
 *   <li>{@link org.eclipse.uml2.uml.AddStructuralFeatureValueAction#validateRequiredValue(org.eclipse.emf.common.util.DiagnosticChain, java.util.Map) <em>Validate Required Value</em>}</li>
 *   <li>{@link org.eclipse.uml2.uml.AddStructuralFeatureValueAction#validateInsertAtPin(org.eclipse.emf.common.util.DiagnosticChain, java.util.Map) <em>Validate Insert At Pin</em>}</li>
 * </ul>
 * </p>
 * @generated
 */
public class AddStructuralFeatureValueActionTest
		extends WriteStructuralFeatureActionTest {

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public static void main(String[] args) {
		TestRunner.run(AddStructuralFeatureValueActionTest.class);
	}

	/**
	 * Constructs a new Add Structural Feature Value Action test case with the given name.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public AddStructuralFeatureValueActionTest(String name) {
		super(name);
	}

	/**
	 * Returns the fixture for this Add Structural Feature Value Action test case.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected AddStructuralFeatureValueAction getFixture() {
		return (AddStructuralFeatureValueAction) fixture;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see junit.framework.TestCase#setUp()
	 * @generated
	 */
	@Override
	protected void setUp()
			throws Exception {
		setFixture(UMLFactory.eINSTANCE.createAddStructuralFeatureValueAction());
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see junit.framework.TestCase#tearDown()
	 * @generated
	 */
	@Override
	protected void tearDown()
			throws Exception {
		setFixture(null);
	}

	/**
	 * Tests the '{@link org.eclipse.uml2.uml.AddStructuralFeatureValueAction#validateRequiredValue(org.eclipse.emf.common.util.DiagnosticChain, java.util.Map) <em>Validate Required Value</em>}' operation.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see org.eclipse.uml2.uml.AddStructuralFeatureValueAction#validateRequiredValue(org.eclipse.emf.common.util.DiagnosticChain, java.util.Map)
	 * @generated
	 */
	public void testValidateRequiredValue__DiagnosticChain_Map() {
		// TODO: implement this feature getter test method
		// Ensure that you remove @generated or mark it @generated NOT
	}

	/**
	 * Tests the '{@link org.eclipse.uml2.uml.AddStructuralFeatureValueAction#validateInsertAtPin(org.eclipse.emf.common.util.DiagnosticChain, java.util.Map) <em>Validate Insert At Pin</em>}' operation.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see org.eclipse.uml2.uml.AddStructuralFeatureValueAction#validateInsertAtPin(org.eclipse.emf.common.util.DiagnosticChain, java.util.Map)
	 * @generated
	 */
	public void testValidateInsertAtPin__DiagnosticChain_Map() {
		// TODO: implement this feature getter test method
		// Ensure that you remove @generated or mark it @generated NOT
	}

} //AddStructuralFeatureValueActionTest
