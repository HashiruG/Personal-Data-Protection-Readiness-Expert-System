:- discontiguous question/3, question_help/3.

question(household_purpose,
  'Is the data used only by a private individual for personal or family purposes?',
  's.2(3)(a)').
question_help(household_purpose,
  'e.g. a personal phone contact list or family photos',
  'Is the personal data processed by an individual purely for personal, domestic or household purposes?').

question(personal_data,
  'Does the organisation handle any information that can identify a person?',
  's.2(3)(b); s.56 "personal data"').
question_help(personal_data,
  'e.g. names, ID numbers, phone numbers, locations or online account IDs',
  'Does the processing involve personal data, that is, information that can identify a person directly or indirectly by reference to an identifier or to factors specific to that person?').

question(processing_in_sl,
  'Is any of the data collected, stored or used in Sri Lanka?',
  's.2(1)(a)').
question_help(processing_in_sl,
  'answer yes even if only part of the handling happens in Sri Lanka',
  'Does the processing of personal data take place wholly or partly within Sri Lanka?').

question(domiciled_in_sl,
  'Is the person or organisation in charge of the data normally based in Sri Lanka?',
  's.2(1)(b)(i)').
question_help(domiciled_in_sl,
  'e.g. a sole trader who lives in Colombo',
  'Is the controller or processor domiciled or ordinarily resident in Sri Lanka?').

question(established_in_sl,
  'Is the organisation registered or set up under Sri Lankan law?',
  's.2(1)(b)(ii)').
question_help(established_in_sl,
  'e.g. a company registered in Sri Lanka, or a statutory body',
  'Is the controller or processor incorporated or established under any written law of Sri Lanka?').

question(offers_to_sl,
  'Does the organisation offer goods or services to people in Sri Lanka?',
  's.2(1)(b)(iii)').
question_help(offers_to_sl,
  'e.g. a foreign online shop that delivers to Sri Lanka or shows prices in rupees',
  'Does the controller or processor offer goods or services to data subjects in Sri Lanka, including with specific targeting of data subjects in Sri Lanka?').

question(monitors_sl,
  'Does the organisation track the behaviour of people in Sri Lanka to make decisions about them?',
  's.2(1)(b)(iv)').
question_help(monitors_sl,
  'e.g. tracking browsing or app use to target adverts or decide prices',
  'Does the controller or processor specifically monitor the behaviour of data subjects in Sri Lanka, including profiling with the intention of making decisions about them?').

question(consent_given,
  'Have people agreed to their data being used?',
  'Sch. I(a)').
question_help(consent_given,
  'e.g. by signing a form or ticking an "I agree" box',
  'Have the data subjects given consent to the processing of their personal data?').

question(contract_necessary,
  'Is the data needed to provide a service or contract that the person has signed up for or asked for?',
  'Sch. I(b)').
question_help(contract_necessary,
  'e.g. a delivery address needed to send an order',
  'Is the processing necessary for the performance of a contract to which the data subject is a party, or to take steps at their request before entering into a contract?').

question(legal_obligation,
  'Does a law require the organisation to use the data?',
  'Sch. I(c)').
question_help(legal_obligation,
  'e.g. keeping employee records for tax or EPF',
  'Is the processing necessary for compliance with a legal obligation to which the controller or processor is subject under any written law?').

question(vital_emergency,
  'Is the data needed to deal with an emergency that threatens someone''s life, health or safety?',
  'Sch. I(d)').
question_help(vital_emergency,
  'e.g. giving medical details to an ambulance crew',
  'Is the processing necessary to respond to an emergency that threatens the life, health or safety of the data subject or another natural person?').

question(public_interest_task,
  'Is the data needed for a task in the public interest, or for duties given to the organisation by law?',
  'Sch. I(e), (g)').
question_help(public_interest_task,
  'e.g. a government agency issuing licences, or public health work',
  'Is the processing necessary for a task carried out in the public interest, or in the exercise of powers, functions or duties conferred on the controller or processor by written law?').

question(legitimate_interests,
  'Does the organisation need the data for a genuine purpose of its own?',
  'Sch. I(f), (h)').
question_help(legitimate_interests,
  'e.g. preventing fraud or keeping IT systems secure',
  'Is the processing necessary for the legitimate interests pursued by the controller or by a third party?').

question(interests_overridden,
  'Would that purpose be outweighed by the people''s right to have their data protected?',
  'Sch. I(f)').
question_help(interests_overridden,
  'take particular care if the people are children',
  'Are those legitimate interests overridden by the interests of the data subject which require protection of personal data, in particular where the data subject is a child?').

question(racial_ethnic_origin,
  'Does the data show a person''s race or ethnicity?',
  's.56 "special categories of personal data"').
question_help(racial_ethnic_origin,
  '',
  'Does the personal data reveal racial or ethnic origin?').

question(political_opinions,
  'Does the data show a person''s political opinions?',
  's.56 "special categories of personal data"').
question_help(political_opinions,
  '',
  'Does the personal data reveal political opinions?').

question(religious_beliefs,
  'Does the data show a person''s religion or beliefs?',
  's.56 "special categories of personal data"').
question_help(religious_beliefs,
  '',
  'Does the personal data reveal religious or philosophical beliefs?').

question(genetic_data,
  'Is genetic (DNA) data used?',
  's.56 "special categories of personal data"').
question_help(genetic_data,
  'e.g. DNA test results',
  'Is genetic data processed?').

question(biometric_data,
  'Are fingerprints, face scans or other body features used to identify people?',
  's.56 "special categories of personal data"').
question_help(biometric_data,
  'e.g. fingerprint entry or face recognition',
  'Is biometric data processed for the purpose of uniquely identifying a natural person?').

question(health_data,
  'Is any health information used?',
  's.56 "special categories of personal data"').
question_help(health_data,
  'e.g. medical records, injuries or disabilities',
  'Is data concerning health processed?').

question(sex_life,
  'Is information about a person''s sex life or sexual orientation used?',
  's.56 "special categories of personal data"').
question_help(sex_life,
  '',
  'Is data concerning a person''s sex life or sexual orientation processed?').

question(criminal_data,
  'Is information about crimes, criminal cases or convictions used?',
  's.56 "special categories of personal data"').
question_help(criminal_data,
  'e.g. police clearance reports',
  'Is personal data relating to offences, criminal proceedings or convictions processed?').

question(child_data,
  'Is data about children (under 16 years old) used?',
  's.56 "special categories of personal data", "child"').
question_help(child_data,
  'e.g. members, students or customers younger than 16',
  'Is personal data relating to a child (a natural person below the age of sixteen years) processed?').

question(special_consent,
  'Have people agreed to this sensitive data being used for purposes the organisation told them about?',
  'Sch. II(a)').
question_help(special_consent,
  'the purposes must be stated at the time the data is used',
  'Have the data subjects given consent to the processing of this special category data for one or more purposes specified by the controller at the time of processing?').

question(written_law_prohibits,
  'Does any other law forbid using this data, even with the person''s agreement?',
  'Sch. II(a)').
question_help(written_law_prohibits,
  '',
  'Does any other written law prohibit the processing of this data notwithstanding the consent of the data subject?').

question(parental_consent,
  'For children''s data, has a parent or legal guardian given consent?',
  'Sch. II(a)').
question_help(parental_consent,
  'a child''s own agreement is not enough',
  'Where the data relates to a child, has consent been given by the parent or legal guardian of the child?').

question(employment_social_security,
  'Is the sensitive data needed to meet duties under employment, social security or public health laws that include safeguards?',
  'Sch. II(b)').
question_help(employment_social_security,
  'e.g. sick-leave records, pension schemes or disease control',
  'Is the processing necessary for obligations or rights in the field of employment, social security (including pension) or public health, in so far as it is provided for in a written law providing appropriate safeguards?').

question(emergency_incapable,
  'Is the sensitive data needed in an emergency where the person is unable to give consent?',
  'Sch. II(c)').
question_help(emergency_incapable,
  'e.g. treating an unconscious patient',
  'Is the processing necessary to respond to an emergency that threatens the life, health or safety of the data subject or another natural person, where the data subject is physically or legally incapable of giving consent?').

question(manifestly_public,
  'Has the person clearly made this data public themselves?',
  'Sch. II(d)').
question_help(manifestly_public,
  'e.g. a politician publicly announcing their party membership',
  'Does the processing relate to personal data which is manifestly made public by the data subject?').

question(legal_claims,
  'Is the sensitive data needed for a court case or legal claim?',
  'Sch. II(e)').
question_help(legal_claims,
  'this includes use by a court acting in its judicial role',
  'Is the processing necessary for the establishment, exercise or defence of legal claims before a court, tribunal or similar forum, or whenever courts are acting in their judicial capacity?').

question(written_law_public_interest,
  'Is the sensitive data needed for a purpose set out in law or for the public interest, used only as far as necessary and with safeguards?',
  'Sch. II(f)').
question_help(written_law_public_interest,
  'e.g. controlling the spread of an infectious disease',
  'Is the processing necessary for a purpose provided for in any written law, or for the public interest (as defined in Schedule I(g)), necessary and proportionate, with suitable and specific safeguards?').

question(health_professional,
  'Is the sensitive data used for medical care, diagnosis or health services by a licensed health professional?',
  'Sch. II(g)').
question_help(health_professional,
  'e.g. a registered doctor keeping patient records',
  'Is the processing necessary for preventive or occupational medicine, medical diagnosis, care or treatment, or management of health-care services, and carried out by a health professional licensed or authorised under written law in Sri Lanka?').

question(archiving_research,
  'Is the sensitive data used for research, statistics or public-interest archives, in line with the law and with safeguards?',
  'Sch. II(h)').
question_help(archiving_research,
  'e.g. an approved university research study',
  'Is the processing necessary for archiving in the public interest, scientific or historical research, or statistical purposes in accordance with law, proportionate and with suitable and specific safeguards?').

question(can_demonstrate_consent,
  'Can the organisation prove that each person gave consent?',
  'Sch. III(a)').
question_help(can_demonstrate_consent,
  'e.g. signed forms or saved records of online consent',
  'Can the controller demonstrate that each data subject has consented to the processing?').

question(consent_in_written_declaration,
  'Is consent asked for inside a form or document that also covers other things?',
  'Sch. III(b)').
question_help(consent_in_written_declaration,
  'e.g. an "I agree" box on a membership form or in terms and conditions',
  'Is consent given in a written declaration which also concerns other matters?').

question(consent_request_distinguishable,
  'Is the consent request clearly separate from the rest, easy to find, and in plain, simple language?',
  'Sch. III(b)').
question_help(consent_request_distinguishable,
  '',
  'Is the request for consent clearly distinguishable from the other matters, in an intelligible and easily accessible form, using clear and plain language?').

question(consent_bundled,
  'Does the organisation refuse its service unless people agree to uses of their data that the service does not need?',
  'Sch. III(c)').
question_help(consent_bundled,
  'e.g. refusing membership unless fingerprints are given, when a membership card would work',
  'Is the performance of a contract or provision of a service made conditional on consent to processing of personal data that is not necessary for that contract or service?').

question(withdrawal_informed,
  'Are people told, before they agree, that they can withdraw their consent at any time?',
  'Sch. III(d)').
question_help(withdrawal_informed,
  '',
  'Before giving consent, are data subjects informed that consent can be withdrawn at any time?').

question(ministry_or_department,
  'Is the organisation a government Ministry or government department?',
  's.20(1)(a), as amended').
question_help(ministry_or_department,
  'answer no for public corporations, state-owned companies, and courts acting in their judicial role',
  'Is the processing carried out by a Ministry or government department (other than the judiciary acting in its judicial capacity)?').

question(core_systematic_monitoring,
  'Is regularly monitoring people a main part of what the organisation does?',
  's.20(1)(b)(i)').
question_help(core_systematic_monitoring,
  'e.g. a security company, a fitness-tracking app or a credit bureau',
  'Do the core activities of the controller or processor consist of operations which, by their nature, scope or purposes, require regular and systematic monitoring of data subjects?').

question(core_special_category,
  'Is handling sensitive data a main part of what the organisation does?',
  's.20(1)(b)(ii)').
question_help(core_special_category,
  'e.g. a hospital, a laboratory, or a gym that uses fingerprint entry',
  'Do the core activities of the controller or processor consist of processing special categories of personal data?').

question(risk_of_harm,
  'Could the organisation''s main use of data cause harm to people''s rights?',
  's.20(1)(b)(iii), as amended').
question_help(risk_of_harm,
  'consider the kind of data used and its effect on the people concerned',
  'Do the core activities consist of processing which results in a risk of harm affecting the rights of data subjects, based on the nature of the processing and its impact on them?').

question(extensive_evaluation,
  'Will the organisation analyse people''s data in a systematic and extensive way, such as profiling?',
  's.24(1)(a)').
question_help(extensive_evaluation,
  'e.g. credit scoring or automated screening of job applicants',
  'Does the intended processing involve a systematic and extensive evaluation of personal data or special categories of personal data, including profiling?').

question(public_monitoring,
  'Will the organisation systematically monitor public places or telecommunication networks?',
  's.24(1)(b)').
question_help(public_monitoring,
  'e.g. CCTV covering a public road, or monitoring phone or internet traffic',
  'Does the intended processing involve systematic monitoring of publicly accessible areas or telecommunication networks?').
