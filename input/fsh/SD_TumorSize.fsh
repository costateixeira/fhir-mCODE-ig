Profile: TumorSize
Parent:  Observation
Id: mcode-tumor-size
Title: "Tumor Size"
Description:  "Records the dimensions of a tumor"
* ^status = #draft
* ^experimental = true

// LOINC code indicatign this is a tumor size
* code = LNC#21889-1 //"Size Tumor"
* code MS

* subject ^short = "The patient whose tumor was measured."
* subject ^definition = "The patient whose tumor was measured. SHALL be a `Patient` resource conforming to `CancerPatient`."
* subject 1..1 MS
* subject only Reference(CancerPatient)

// TODO: Set rule such that either specimen OR focus must be non-null, but one MUST be null
* focus 0..1
* focus only Reference(Tumor)
* focus ^short = "Use ONLY when tumor HAS NOT been removed from the body"
* focus ^definition = "Reference to a BodyStructure resource conforming to Tumor."
* focus ^comment = "Use **only** when the tumor **has not** been removed from the body.
                    If the tumor has been removed, use `specimen` instead and leave `focus` empty."
* focus MS

* specimen ^short = "Use ONLY when tumor HAS been removed from the body"
* specimen ^definition = "Reference to a BodyStructure resource conforming to Tumor."
* specimen ^comment = "Use **only** when the tumor **has** been removed from the body.
                       If the tumor has been not removed, use `focus` instead and leave `specimen` empty."
* specimen MS

* method from TumorSizeMethodVS (extensible)
* method ^short = "Method for measuring the tumor"
* method ^definition = "Method for measuring the tumor"
* method ^comment = "Tumors are typically measured via gross pathology after excision, or via diagnostic
                     imaging or physical exam prior to removal. `TumorSizeMethodVS` provides LOINC codes
                     for these measurement methods.

                     Therefore, if `specimen` is set, `method` is expected to be a \"gross pathology\" code.
                     If `focus` is set, `method` is expected to be a type of diagnostic imaging or physical exam.
                     "
* method MS

// Store tumor size in component with 3 valueCodableConcepts for each tumor dimension
* component MS
* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component ^slicing.description = "Slice based on the component.code pattern"
// Require 1 dimension; the other 2 are optional
* component contains
    tumorLongestDimension 1..1 MS and
    tumorOtherDimensions 0..2 MS

* component[tumorLongestDimension] ^short = "Longest tumor dimension (cm or mm)"
* component[tumorLongestDimension] ^definition = "The longest tumor dimension in cm or mm."
* component[tumorLongestDimension].code = LNC#33728-7 // "Size.maximum dimension in Tumor"
* component[tumorLongestDimension].value[x] only Quantity
* component[tumorLongestDimension].valueQuantity from TumorSizeUnitsVS (required)

* component[tumorOtherDimensions] ^short = "2nd or 3rd tumor dimension (cm or mm)"
* component[tumorOtherDimensions] ^definition = "The second or third tumor dimension in cm or mm."
* component[tumorOtherDimensions] ^comment = "Additional tumor dimensions should be ordered from largest to smallest."
* component[tumorOtherDimensions].code = LNC#33729-5 // "Size additional dimension in Tumor"
* component[tumorOtherDimensions].value[x] only Quantity
* component[tumorOtherDimensions].valueQuantity from TumorSizeUnitsVS (required)




Profile: Tumor
Parent:  BodyStructure
Id: mcode-tumor
Title: "Tumor"
Description:  "Identifies a tumor. Whenever possible, a single resource conforming to this
               profile will be used to track a tumor over time (as opposed to creating new
               Tumor-conforming BodyStructure resources each time that tumor is measured).
              "
* ^status = #draft
* ^experimental = true
// The purpose of this profile is to uniquely identify a tumor, so it follows that there must be at least one identifier value provided
* identifier 1.. MS
* identifier ^short = "Stable identifier of this specific tumor"
* identifier ^definition = "Stable identifier of this specific tumor, should be unique within the referenced `CancerPatient`."
* identifier ^comment = "If applicable, this should correspond to the physical tag inserted into the tumor during a procedure
                         that is used for tracking the tumor by radiology and pathology.
                        "
// This VS is used to define the morphology of primary and secondary cancer; rule set here for consistency with these profiles.
* morphology from HistologyMorphologyBehaviorVS (extensible)
* morphology MS
// This VS is used for the primary/secondary cancer conditions; rule set here for consistency with these profiles.
* location from CancerBodyLocationVS (extensible)
* location 1..1 MS // Tumor is meaningless without a location; parent profile is 0..1
* patient only Reference(CancerPatient)



// Based on UnitsOfLengthVS, but limited to just mm and cm. In theory we could just use UnitsOfLengthVS if we don't care about restricting to just cm/mm.
ValueSet:        TumorSizeUnitsVS
Id:              mcode-tumor-size-units-vs
Title:           "Units of tumor size value set"
Description:     "Acceptable units for measuring tumor size"
* UCUM#mm        "Millimeter"
* UCUM#cm        "Centimeter"
* ^status = #draft
* ^experimental = true


ValueSet:        TumorSizeMethodVS
Id:              mcode-tumor-size-method-vs
Title:           "Methods for measuring tumor size"
Description:     "Methods for measuring tumor size"
* LNC#24419-4 "Pathology report gross observation"
* LNC#29544-4 "Physical findings"
* LNC#18748-4 "Diagnostic imaging study"
* ^status = #draft
* ^experimental = true