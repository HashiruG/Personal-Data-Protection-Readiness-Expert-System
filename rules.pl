:- discontiguous rule/6.

module(m1, 'Application of the Act (s.2)').
module(m2, 'Lawful basis for processing (s.5(a), Schedule I)').
module(m3, 'Special categories of personal data (s.5(b), Schedule II)').
module(m4, 'Conditions for valid consent (s.5(c), Schedule III)').
module(m5, 'Data Protection Officer (s.20(1), as amended)').
module(m6, 'Personal data protection impact assessment (s.24(1))').

rule(r1, m1, [processing_in_sl], applies,
     'Processing takes place wholly or partly within Sri Lanka',
     's.2(1)(a)').

rule(r2, m1, [domiciled_in_sl], applies,
     'The controller or processor is domiciled or ordinarily resident in Sri Lanka',
     's.2(1)(b)(i)').

rule(r3, m1, [established_in_sl], applies,
     'The controller or processor is incorporated or established under a written law of Sri Lanka',
     's.2(1)(b)(ii)').

rule(r4, m1, [offers_to_sl], applies,
     'The controller or processor offers goods or services to data subjects in Sri Lanka',
     's.2(1)(b)(iii)').

rule(r5, m1, [monitors_sl], applies,
     'The controller or processor specifically monitors the behaviour of data subjects in Sri Lanka',
     's.2(1)(b)(iv)').

rule(r6, m1, [household_purpose], not_applies,
     'Personal data is processed purely for personal, domestic or household purposes by an individual; the Act does not apply',
     's.2(3)(a)').

rule(r7, m1, [no(personal_data)], not_applies,
     'The data is not personal data; the Act does not apply',
     's.2(3)(b)').

rule(r8, m2, [consent_given], basis,
     'Lawful basis: the data subject has given consent (Schedule III conditions must also be met)',
     'Sch. I(a)').

rule(r9, m2, [contract_necessary], basis,
     'Lawful basis: processing is necessary for a contract with the data subject',
     'Sch. I(b)').

rule(r10, m2, [legal_obligation], basis,
     'Lawful basis: processing is necessary to comply with a legal obligation under written law',
     'Sch. I(c)').

rule(r11, m2, [vital_emergency], basis,
     'Lawful basis: processing is necessary to respond to an emergency threatening life, health or safety',
     'Sch. I(d)').

rule(r12, m2, [public_interest_task], basis,
     'Lawful basis: processing is necessary for a task in the public interest or for powers or duties under written law',
     'Sch. I(e)').

rule(r13, m2, [legitimate_interests, no(interests_overridden)], basis,
     'Lawful basis: processing is necessary for legitimate interests that are not overridden by the data subject''s interests',
     'Sch. I(f)').

rule(r14, m2, [none_fired([r8, r9, r10, r11, r12, r13])], issue,
     'No condition in Schedule I is met; the processing is not lawful',
     's.5(a)').

rule(r15, m3,
     [any([racial_ethnic_origin, political_opinions, religious_beliefs,
           genetic_data, biometric_data, health_data, sex_life,
           criminal_data, child_data])],
     finding,
     'Special categories of personal data are processed',
     's.56').

rule(r16, m3,
     [fired(r15), special_consent, no(written_law_prohibits),
      any([no(child_data), parental_consent])],
     condition,
     'Schedule II condition met: consent for purposes specified by the controller (for a child, consent of the parent or legal guardian)',
     'Sch. II(a)').

rule(r17, m3, [fired(r15), employment_social_security], condition,
     'Schedule II condition met: employment, social security or public health obligations under written law with safeguards',
     'Sch. II(b)').

rule(r18, m3, [fired(r15), emergency_incapable], condition,
     'Schedule II condition met: emergency where the data subject is physically or legally incapable of giving consent',
     'Sch. II(c)').

rule(r19, m3, [fired(r15), manifestly_public], condition,
     'Schedule II condition met: the data was manifestly made public by the data subject',
     'Sch. II(d)').

rule(r20, m3, [fired(r15), legal_claims], condition,
     'Schedule II condition met: legal claims, or courts acting in their judicial capacity',
     'Sch. II(e)').

rule(r21, m3, [fired(r15), written_law_public_interest], condition,
     'Schedule II condition met: purpose under written law or public interest, necessary, proportionate and safeguarded',
     'Sch. II(f)').

rule(r22, m3, [fired(r15), health_professional], condition,
     'Schedule II condition met: medical purposes by a licensed or authorised health professional',
     'Sch. II(g)').

rule(r23, m3, [fired(r15), archiving_research], condition,
     'Schedule II condition met: archiving, scientific or historical research or statistics in accordance with law',
     'Sch. II(h)').

rule(r24, m3,
     [fired(r15),
      none_fired([r16, r17, r18, r19, r20, r21, r22, r23])],
     issue,
     'No condition in Schedule II is met; processing of special categories of personal data is not lawful',
     's.5(b)').

rule(r25, m4, [no(can_demonstrate_consent)], issue,
     'The controller cannot demonstrate that the data subject consented',
     'Sch. III(a)').

rule(r26, m4,
     [consent_in_written_declaration, no(consent_request_distinguishable)],
     issue,
     'The consent request is not clearly distinguishable from the other matters in the written declaration, or is not in clear and plain language',
     'Sch. III(b)').

rule(r27, m4, [consent_bundled], issue,
     'The service or contract is conditional on consent to processing that is not necessary for it; consent may not be freely given',
     'Sch. III(c)').

rule(r28, m4, [no(withdrawal_informed)], issue,
     'Data subjects are not informed before consenting that consent can be withdrawn at any time',
     'Sch. III(d)').

rule(r29, m5, [ministry_or_department], required,
     'A Data Protection Officer must be designated or appointed (processing by a Ministry or government department)',
     's.20(1)(a), as amended').

rule(r30, m5, [core_systematic_monitoring], may_require,
     'A Data Protection Officer may be required: core activities require regular and systematic monitoring of data subjects (scale to be prescribed)',
     's.20(1)(b)(i)').

rule(r31, m5, [fired(r15), core_special_category], may_require,
     'A Data Protection Officer may be required: core activities consist of processing special categories of personal data (scale to be prescribed)',
     's.20(1)(b)(ii)').

rule(r32, m5, [risk_of_harm], may_require,
     'A Data Protection Officer may be required: processing results in a risk of harm to data subjects'' rights (categories to be determined by Authority guidelines)',
     's.20(1)(b)(iii), as amended').

rule(r33, m6, [extensive_evaluation], required,
     'A personal data protection impact assessment must be carried out before processing (systematic and extensive evaluation, including profiling)',
     's.24(1)(a)').

rule(r34, m6, [public_monitoring], required,
     'A personal data protection impact assessment must be carried out before processing (systematic monitoring of publicly accessible areas or telecommunication networks)',
     's.24(1)(b)').
