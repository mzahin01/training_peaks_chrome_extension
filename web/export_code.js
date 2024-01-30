function sessionTitle() {
    const titleContainer = document.querySelector('.titleContainer .input-wrapper .workoutTitle');
    if (!titleContainer) {
        console.error('Title container not found');
        return;
    }
    return titleContainer.value;
}

function sessionDescription() {
    const descriptionSection = document.querySelector('#descriptionPrintable')
    if (!descriptionSection) {
        console.error('Description not found');
        return;
    }
    return descriptionSection.textContent.trim()
}

function sessionPreActivityComments() {
    const preActivityComments = document.querySelector('#preActivityCommentsInput')
    if (!preActivityComments) {
        console.error('Pre Activity not found');
        return ""
    }
    return preActivityComments.textContent.trim()
}

function convertToJSON() {
    const stepList = document.querySelector('.stepList');
    if (!stepList) {
        console.error('Step list not found');
        return;
    }

    function parseStep(step) {
        const stepData = {
            type: step.classList.contains('active') ? 'active' : (step.classList.contains('warmUp') ? 'warmUp' : (step.classList.contains('coolDown') ? 'coolDown' : 'rest')),
            name: step.querySelector('.stepName').textContent.trim(),
            lengthAndIntensity: step.querySelector('.lengthAndIntensity').textContent.trim(),
        };

        const zoneLabelElement = step.querySelector('.zoneLabel');
        if (zoneLabelElement) {
            stepData.zoneLabel = zoneLabelElement.textContent.trim();
        }

        const secondaryTargetRangeElement = step.querySelector('.secondaryTargetRange');
        if (secondaryTargetRangeElement) {
            stepData.secondaryTargetRange = secondaryTargetRangeElement.textContent.trim();
        }

        return stepData;
    }

    return Array.from(stepList.children).map(section => {
        let sectionType = section.querySelector('.stepName')?.textContent.trim() || '';
        let type = 'BASIC';
        let steps;

        if (sectionType.toLowerCase().startsWith('ramp')) {
            type = 'RAMP';
        }

        // Check if section is a "Repetition" or "Ramp" type
        if (section.classList.contains('repetition') || type === 'RAMP') {
            steps = Array.from(section.querySelectorAll('.repetitionSteps .step, .step')).map(parseStep);
        } else {
            // For single steps like 'warmUp', 'active','rest', 'coolDown'
            steps = [parseStep(section)];
        }

        return {
            section: sectionType,
            type: type,
            steps: steps
        };
    });
}

var jsonResult = convertToJSON();
var description = sessionDescription()
var title = sessionTitle()
var preActivityComments = sessionPreActivityComments()
console.log(title)
console.log(description)
console.log(jsonResult); // Log the JSON to the console
var output = {
    title: title,
    description: description,
    structure: jsonResult,
    ftp: 220,
    comment_pre_activity: preActivityComments,
    activity_type: "CYCLING"
}
console.log(output);
var json = JSON.stringify(output);
json;