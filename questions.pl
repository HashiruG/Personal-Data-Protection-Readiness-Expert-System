:- discontiguous question/3.

question(household_purpose,
  'Is the personal data processed by an individual purely for personal, domestic or household purposes (for example, a personal contact list)?',
  's.2(3)(a)').

question(personal_data,
  'Does the processing involve personal data, that is, information that can identify a person directly or indirectly (for example a name, identification number, location data or online identifier)?',
  's.2(3)(b); s.56 "personal data"').

question(processing_in_sl,
  'Does the processing of personal data take place wholly or partly within Sri Lanka?',
  's.2(1)(a)').

question(domiciled_in_sl,
  'Is the controller or processor domiciled or ordinarily resident in Sri Lanka?',
  's.2(1)(b)(i)').

question(established_in_sl,
  'Is the controller or processor incorporated or established under any written law of Sri Lanka?',
  's.2(1)(b)(ii)').

question(offers_to_sl,
  'Does the controller or processor offer goods or services to data subjects in Sri Lanka, including with specific targeting of data subjects in Sri Lanka?',
  's.2(1)(b)(iii)').

question(monitors_sl,
  'Does the controller or processor specifically monitor the behaviour of data subjects in Sri Lanka, including profiling with the intention of making decisions about them?',
  's.2(1)(b)(iv)').

question(consent_given,
  'Have the data subjects given consent to the processing of their personal data?',
  'Sch. I(a)').

question(contract_necessary,
  'Is the processing necessary for the performance of a contract to which the data subject is a party, or to take steps at their request before entering into a contract?',
  'Sch. I(b)').

question(legal_obligation,
  'Is the processing necessary for compliance with a legal obligation to which the controller or processor is subject under any written law?',
  'Sch. I(c)').

question(vital_emergency,
  'Is the processing necessary to respond to an emergency that threatens the life, health or safety of the data subject or another natural person?',
  'Sch. I(d)').

question(public_interest_task,
  'Is the processing necessary for a task carried out in the public interest, or in the exercise of powers, functions or duties conferred on the controller or processor by written law?',
  'Sch. I(e), (g)').

question(legitimate_interests,
  'Is the processing necessary for the legitimate interests pursued by the controller or by a third party (for example fraud prevention or network and information security)?',
  'Sch. I(f), (h)').

question(interests_overridden,
  'Are those legitimate interests overridden by the interests of the data subject which require protection of personal data, in particular where the data subject is a child?',
  'Sch. I(f)').

question(racial_ethnic_origin,
  'Does the personal data reveal racial or ethnic origin?',
  's.56 "special categories of personal data"').

question(political_opinions,
  'Does the personal data reveal political opinions?',
  's.56 "special categories of personal data"').

question(religious_beliefs,
  'Does the personal data reveal religious or philosophical beliefs?',
  's.56 "special categories of personal data"').

question(genetic_data,
  'Is genetic data processed?',
  's.56 "special categories of personal data"').

question(biometric_data,
  'Is biometric data processed for the purpose of uniquely identifying a natural person (for example fingerprints or facial recognition)?',
  's.56 "special categories of personal data"').

question(health_data,
  'Is data concerning health processed (for example medical or injury records)?',
  's.56 "special categories of personal data"').

question(sex_life,
  'Is data concerning a person''s sex life or sexual orientation processed?',
  's.56 "special categories of personal data"').

question(criminal_data,
  'Is personal data relating to offences, criminal proceedings or convictions processed?',
  's.56 "special categories of personal data"').

question(child_data,
  'Is personal data relating to a child (a natural person below the age of sixteen years) processed?',
  's.56 "special categories of personal data", "child"').

question(special_consent,
  'Have the data subjects given consent to the processing of this special category data for one or more purposes specified by the controller at the time of processing?',
  'Sch. II(a)').

question(written_law_prohibits,
  'Does any other written law prohibit the processing of this data notwithstanding the consent of the data subject?',
  'Sch. II(a)').

question(parental_consent,
  'Where the data relates to a child, has consent been given by the parent or legal guardian of the child?',
  'Sch. II(a)').

question(employment_social_security,
  'Is the processing necessary for obligations or rights in the field of employment, social security (including pension) or public health, in so far as it is provided for in a written law providing appropriate safeguards?',
  'Sch. II(b)').

question(emergency_incapable,
  'Is the processing necessary to respond to an emergency that threatens the life, health or safety of the data subject or another natural person, where the data subject is physically or legally incapable of giving consent?',
  'Sch. II(c)').

question(manifestly_public,
  'Does the processing relate to personal data which is manifestly made public by the data subject?',
  'Sch. II(d)').

question(legal_claims,
  'Is the processing necessary for the establishment, exercise or defence of legal claims before a court, tribunal or similar forum, or whenever courts are acting in their judicial capacity?',
  'Sch. II(e)').

question(written_law_public_interest,
  'Is the processing necessary for a purpose provided for in any written law, or for the public interest (as defined in Schedule I(g)), necessary and proportionate, with suitable and specific safeguards?',
  'Sch. II(f)').

question(health_professional,
  'Is the processing necessary for preventive or occupational medicine, medical diagnosis, care or treatment, or management of health-care services, and carried out by a health professional licensed or authorised under written law in Sri Lanka?',
  'Sch. II(g)').

question(archiving_research,
  'Is the processing necessary for archiving in the public interest, scientific or historical research, or statistical purposes in accordance with law, proportionate and with suitable and specific safeguards?',
  'Sch. II(h)').

question(can_demonstrate_consent,
  'Can the controller demonstrate that each data subject has consented to the processing (for example, through consent records)?',
  'Sch. III(a)').

question(consent_in_written_declaration,
  'Is consent given in a written declaration which also concerns other matters (for example, a membership form or terms and conditions)?',
  'Sch. III(b)').

question(consent_request_distinguishable,
  'Is the request for consent clearly distinguishable from the other matters, in an intelligible and easily accessible form, using clear and plain language?',
  'Sch. III(b)').

question(consent_bundled,
  'Is the performance of a contract or provision of a service made conditional on consent to processing of personal data that is not necessary for that contract or service?',
  'Sch. III(c)').

question(withdrawal_informed,
  'Before giving consent, are data subjects informed that consent can be withdrawn at any time?',
  'Sch. III(d)').

question(ministry_or_department,
  'Is the processing carried out by a Ministry or government department (other than the judiciary acting in its judicial capacity)?',
  's.20(1)(a), as amended').

question(core_systematic_monitoring,
  'Do the core activities of the controller or processor consist of operations which, by their nature, scope or purposes, require regular and systematic monitoring of data subjects?',
  's.20(1)(b)(i)').

question(core_special_category,
  'Do the core activities of the controller or processor consist of processing special categories of personal data?',
  's.20(1)(b)(ii)').

question(risk_of_harm,
  'Do the core activities consist of processing which results in a risk of harm affecting the rights of data subjects, based on the nature of the processing and its impact on them?',
  's.20(1)(b)(iii), as amended').

question(extensive_evaluation,
  'Does the intended processing involve a systematic and extensive evaluation of personal data or special categories of personal data, including profiling (for example, credit scoring)?',
  's.24(1)(a)').

question(public_monitoring,
  'Does the intended processing involve systematic monitoring of publicly accessible areas or telecommunication networks (for example, CCTV covering public spaces)?',
  's.24(1)(b)').
