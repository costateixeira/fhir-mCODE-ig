<div xmlns="http://www.w3.org/1999/xhtml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://hl7.org/fhir ../../input-cache/schemas-r5/fhir-single.xsd">

<h3><a name="Implementation"></a>Implementation Notes</h3>
<p>This page contains miscellaneous information on modeling and FHIR implementation. The content is primarily directed at informaticists and implementers of mCODE. The following topics are addressed: </p>

<ul>
    <li><a href="#Terminology">Terminology Preferences</a></li>
    <li><a href="#Patient">Patient</a></li>
    <li><a href="#BodyLocations">Body Locations</a></li>
    <li><a href="#VitalSigns">Vital Sign Profiles</a></li>
    <li><a href="#LaboratoryProfiles">Laboratory Profiles</a></li>
    <li><a href="#RepresentingProvenance">Representing Provenance of mCODE Information</a></li>
</ul>

<h4><a name="Terminology"></a>Terminology Preferences</h4>

<p>This implementation guide supplies terminology bindings drawn primarily from LOINC for "observables", and SNOMED-CT for values, results and findings. When appropriate codes are not available in the preferred vocabulary, alternative vocabularies are used, in the following order of preference: SNOMED-CT (if the element is an observable), NCI Thesaurus and Metathesaurus, and local codes. </p>

<p>The specification of SNOMED US Edition is handled within the FHIR <b>CodeableConcept.version</b> attribute:</p>
<p><code>{version: "http://snomed.info/sct/731000124108"}</code></p>
<p>where 731000124108 is the SNOMED namespace assigned to the National Library of Medicine (NLM), who manages the SNOMED US Edition.</p>

<p>Value sets from the FHIR specification and US Core were reused to the extent possible. New value sets where created only when no known existing value sets were deemed to be fit for purpose, or when existing value sets were needed to be extended.</p>

<p>mCODE genomics-related elements in the GenomicsReport and GeneticVariant profiles will support the acceptable code systems stated in the <a href="http://hl7.org/fhir/uv/genomics-reporting/codings.html" target="_blank">HL7 Clinical Genomics Reporting FHIR IG, STU1 Release</a>.</p>

<h4><a name="Patient"></a>Patient</h4>
<p>FHIR (and mCODE) allows multiple addresses for a patient. The zip code reported in mCODE should be the one specified by Address.use of "home" and Address.type of "physical".</p>

<h4><a name="BodyLocations"></a>Body Locations</h4>
<p>A single code is often insufficient to precisely determine a body site for the purpose of describing where a tumor is located, where a surgery is targeted, or where a radiation treatment is focused. For example, in breast cancer, the location of a tumor can be described in terms of the radial position (clock face direction) and distance relative to the left or right nipple.</p>
<p>In FHIR, Condition, Procedure, and other resources represent body sites using a single code. In addition, FHIR provides a standard extension, <a href="http://hl7.org/fhir/StructureDefinition/bodySite" target="_blank">BodyStructure Reference</a> that can be used when a single code is insufficient. However, this approach has not been adopted, for the following reasons:</p>
<ul>
    <li>The bodySite attribute is a terminology concept, but BodyStructure is a resource, representing a body site on a specific patient. Concepts and instances are not analogous and cannot be arbitrarily swapped.</li>
    <li>Even if the difference between a terminology concept and an patient-specific resource is overlooked, the BodyStructure resource is insufficient for mCODE's purposes.</li>
</ul>
<p>Instead, mCODE uses an approach that defines body sites conceptually, and has the required specificity, by introducing a laterality extension:</p>
<ul>
    <li><a href="StructureDefinition-mcode-laterality.html">Laterality</a> - the side of the body the body location, if needed to distinguish from a similar location on the other side of the body</li>
</ul>

<h4><a name="VitalSigns"></a>Vital Sign Profiles</h4>
<p>The vital signs height, weight, and blood pressure are part of the mCODE data set. However, vital sign profiles are not defined in mCODE. Instead, mCODE uses the <a href="http://hl7.org/fhir/R4/observation-vitalsigns.html" target="_blank">FHIR vital sign profiles</a>, which are incorporated by reference into <a href="http://hl7.org/fhir/us/core/index.html" target="_blank">US Core v3</a>.</p>
 <p>If and when detailed vital signs profiles are standardized in a widely-accepted FHIR IG, mCODE may switch over to those profiles.</p>

<h4><a name="LaboratoryProfiles"></a>Laboratory Profiles</h4>

<p>Complete Blood Count (CBC) and Comprehensive Metabolic Panel (CMP) are part of the mCODE data set. Reporting these results must conform to the <a href="http://hl7.org/fhir/us/core/StructureDefinition-us-core-observation-lab.html">US Core Laboratory Result Profile</a>. Several examples of laboratory result reporting are given in the <a href="http://hl7.org/fhir/us/core/index.html">US Core IG</a>. For example, see this <a href="http://hl7.org/fhir/us/core/Observation-erythrocytes.html">erythrocytes laboratory reporting example</a>.</p>

<p>In practice, there are different variations on these panels, as exemplified by <a href="https://search.loinc.org/searchLOINC/search.zul?query=CBC">this list of various CBCs</a>. The individual LOINC codes of interest to mCODE are any that are reported as part of the CBC and CMP panels, which include, but are not limited to:</p>

<ul>
    <li><b>CBC:</b> 20570-8, 26453-1, 718-7, 26515-7, 28539-5, 28540-3, 28542-9, 30384-2, 30385-9, 30428-7, 26464-8, 30180-4, 26444-0, 34911-8, 34910-0, 26446-5, 30376-8, 26450-7, 26449-9, 34913-4, 34912-6, 30395-8, 30394-1, 35058-7, 30397-4, 26463-0, 26462-2, 26471-3, 30406-3, 34922-5, 35050-4, 26478-8, 26474-7, 30413-9, 30412-1, 13046-8, 26477-0, 30420-4, 35082-7, 34921-7, 35039-7, 30423-8, 30422-0, 34915-9, 34914-2, 28541-1, 30433-7, 34923-3, 35029-8, 26485-3, 26484-6, 30441-0, 30440-2, 34925-8, 34924-1, 30445-1, 30444-4, 26498-6, 30446-9, 26511-6, 26499-4, 26508-2, 26507-4, 30450-1, 30449-3, 30451-9,6505-8, 34917-5, 34916-7, 13047-6, 30458-4, 34999-3, 35003-3, 30465-9, 30464-2, 30466-7, 34926-6, 26524-9, 26523-1, 34919-1, 34918-3, 34992-8, 34993-6, 33255-1
    </li>
    <li><b>CMP:</b> 2345-7, 3094-0, 2160-0, 3097-3, 33914-3, 50044-7, 48642-3, 48643-1, 17861-6, 2885-2, 1751-7, 10834-0, 1759-0, 1975-2, 6768-6, 1742-6, 1920-8, 2951-2, 2823-3, 2075-0, 1963-8, 2028-9, 33037-3</li>
</ul>

<h4><a name="RepresentingProvenance"></a>Representing Provenance of mCODE Information</h4>
<p>
Provenance information includes the "who, what, when, where, why" associated with collection, transfer, and updating of clinical information. As a FHIR application, mCODE relies FHIR's native mechanisms for recording and tracking provenance. As such, mCODE shares all the capabilities and limitations of FHIR provenance tracking. The user should refer to the <a href="https://www.hl7.org/fhir/provenance.html">FHIR specification</a> for more information. Only a brief summary is presented here.</p>
<p>FHIR provenance tracking has three parts:</p>
<ul>
    <li>All FHIR resources contain a <a href="https://www.hl7.org/fhir/resource.html#Meta">metadata element</a> that specifies a serially-updated version of the resource, a timestamp of the most recent update to the resource, a URI representing the source system of the resource, URLs of the profiles the resource claims to conform to, and security labels and tags.</li>
    <li>In addition, each resource contains elements that represent information about how the resource was obtained, and who or what the information applies to. These attributes vary from resource to resource, and may include information such as the subject of care, the author of the information, performer of an action, the date/time of the action, etc.</li>
    <li>Finally, FHIR provides a <a href="https://www.hl7.org/fhir/provenance.html">Provenance Resource</a> that can be used where additional information is required, or explicit record or provenance is desired.</li>
</ul>
<p>In summary, mCODE defers to these FHIR mechanisms for recording and tracking provenance.</p>