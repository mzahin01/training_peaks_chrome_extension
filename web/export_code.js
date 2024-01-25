function convertToJSON() {
    const stepList = document.querySelector('.stepList');
    if (!stepList) {
        console.error('Step list not found');
        return;
    }

    const sections = stepList.children;
    const result = [];

    for (const section of sections) {
        const sectionData = {
            section: section.querySelector('.stepName').textContent.trim(),
            steps: [],
        };

        if (section.classList.contains('repetition')) {
            const repetitionSteps = section.querySelector('.repetitionSteps');
            const steps = repetitionSteps ? repetitionSteps.querySelectorAll('.step') : [];

            for (const step of steps) {
                const stepData = {
                    type: step.classList.contains('active') ? 'active' : 'rest',
                    name: step.querySelector('.stepName').textContent.trim(),
                    duration: step.querySelector('.lengthAndIntensity').textContent.trim(),
                };

                const intensityElement = step.querySelector('.secondaryTargetRange');
                if (intensityElement) {
                    stepData.intensity = intensityElement.textContent.trim();
                }

                sectionData.steps.push(stepData);
            }
        } else {
            const stepData = {
                type: section.classList.contains('warmUp') ? 'warmUp' : 'coolDown',
                name: section.querySelector('.stepName').textContent.trim(),
                duration: section.querySelector('.lengthAndIntensity').textContent.trim(),
            };

            const intensityElement = section.querySelector('.secondaryTargetRange');
            if (intensityElement) {
                stepData.intensity = intensityElement.textContent.trim();
            }

            sectionData.steps.push(stepData);
        }

        result.push(sectionData);
    }
    return result;
}


function downloadJSON(data, filename) {
    const jsonBlob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(jsonBlob);
    link.download = filename;
    link.click();
}

var jsonResult = convertToJSON();
console.log(jsonResult);
var json = JSON.stringify(jsonResult);
json;