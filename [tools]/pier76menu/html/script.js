let vehiclesData = [];

// Fonction pour gérer l'ouverture/fermeture des sections accordéon
function toggleSection(sectionId) {
    const section = document.getElementById(sectionId);
    const header = section.previousElementSibling;
    
    if (section.classList.contains('collapsed')) {
        section.classList.remove('collapsed');
        header.classList.remove('collapsed');
    } else {
        section.classList.add('collapsed');
        header.classList.add('collapsed');
    }
}

window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'toggle') {
        if (data.show) {
            vehiclesData = data.vehicles;
            showMainMenu();
            document.body.classList.remove('camera-mode');
        } else {
            hideAll();
            document.body.classList.remove('camera-mode');
        }
    }
    
    if (data.action === 'updateSettings') {
        renderSettings(data.settings);
    }
    
    if (data.action === 'updateModkit') {
        renderModkit(data.mods);
    }
    
    if (data.action === 'updateAnimations') {
        renderAnimations(data.doors);
    }
    
    if (data.action === 'updateVehicleState') {
        updateVehicleState(data.state);
    }
    
    if (data.action === 'reloadSettings') {
        // Recharger les réglages après réinitialisation
        setTimeout(() => {
            showSettings();
        }, 100);
    }
    
    if (data.action === 'cameraMode') {
        if (data.enabled) {
            document.body.classList.add('camera-mode');
        } else {
            document.body.classList.remove('camera-mode');
        }
    }
});

let cameraMode = false;

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeMenu();
    }
    
    // Touche X pour basculer le mode caméra
    if (event.key === 'x' || event.key === 'X') {
        const settingsVisible = !document.getElementById('settingsMenu').classList.contains('hidden');
        const modkitVisible = !document.getElementById('modkitMenu').classList.contains('hidden');
        
        if (settingsVisible || modkitVisible) {
            console.log('[Pier76Menu] Touche X détectée');
            cameraMode = !cameraMode;
            
            if (cameraMode) {
                document.body.classList.add('camera-mode');
                console.log('[Pier76Menu] Mode caméra activé');
            } else {
                document.body.classList.remove('camera-mode');
                console.log('[Pier76Menu] Mode caméra désactivé');
            }
            
            // Notifier Lua
            fetch(`https://${GetParentResourceName()}/toggleCamera`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ enabled: cameraMode })
            });
        }
    }
});

function hideAll() {
    document.getElementById('mainMenu').classList.add('hidden');
    document.getElementById('vehiclesMenu').classList.add('hidden');
    document.getElementById('settingsMenu').classList.add('hidden');
    document.getElementById('modkitMenu').classList.add('hidden');
    document.querySelector('.camera-hint').style.display = 'none';
}

function showMainMenu() {
    hideAll();
    cameraMode = false;
    document.body.classList.remove('camera-mode');
    document.getElementById('mainMenu').classList.remove('hidden');
}

function showVehicles() {
    hideAll();
    document.getElementById('vehiclesMenu').classList.remove('hidden');
    renderTable();
    document.getElementById('searchInput').value = '';
}

function showSettings() {
    hideAll();
    document.getElementById('settingsMenu').classList.remove('hidden');
    document.querySelector('.camera-hint').style.display = 'block';
    fetch(`https://${GetParentResourceName()}/loadSettings`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function showModkit() {
    hideAll();
    document.getElementById('modkitMenu').classList.remove('hidden');
    document.querySelector('.camera-hint').style.display = 'block';
    fetch(`https://${GetParentResourceName()}/loadModkit`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function backToMain() {
    showMainMenu();
}

function closeMenu() {
    hideAll();
    cameraMode = false;
    document.body.classList.remove('camera-mode');
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function deleteVehicle() {
    fetch(`https://${GetParentResourceName()}/delete`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function repairVehicle() {
    fetch(`https://${GetParentResourceName()}/repair`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function spawnVehicle(model) {
    fetch(`https://${GetParentResourceName()}/spawn`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ model: model })
    });
}

function renderTable(searchTerm = '') {
    const tbody = document.getElementById('tableBody');
    tbody.innerHTML = '';
    
    vehiclesData.forEach(category => {
        category.vehicles.forEach(vehicle => {
            if (searchTerm === '' || 
                vehicle.name.toLowerCase().includes(searchTerm) || 
                vehicle.model.toLowerCase().includes(searchTerm) ||
                category.category.toLowerCase().includes(searchTerm)) {
                
                const row = document.createElement('tr');
                row.onclick = () => spawnVehicle(vehicle.model);
                
                row.innerHTML = `
                    <td>${category.category}</td>
                    <td>${vehicle.name}</td>
                    <td>${vehicle.model}</td>
                `;
                
                tbody.appendChild(row);
            }
        });
    });
}

function renderSettings(settings) {
    const container = document.getElementById('settingsList');
    if (!settings || settings.length === 0) {
        container.innerHTML = '<p>Aucun véhicule. Montez dans un véhicule pour modifier le handling.</p>';
        return;
    }
    
    container.innerHTML = settings.map(setting => {
        const inputType = setting.isNumber ? 'number' : 'text';
        const value = setting.isNumber ? setting.value.toFixed(6) : setting.value;
        const defaultVal = setting.isNumber && setting.default ? setting.default.toFixed(6) : setting.default;
        
        return `
            <div class="setting-item">
                <label>${setting.tag}</label>
                <div class="setting-controls">
                    <input type="${inputType}" 
                           id="input_${setting.tag}"
                           value="${value}"
                           data-default="${defaultVal || value}"
                           step="any"
                           onchange="applySetting('${setting.tag}', this.value)">
                    <button class="default-btn" onclick="resetSingleSetting('${setting.tag}')">Défaut</button>
                </div>
            </div>
        `;
    }).join('');
}

function resetSingleSetting(tag) {
    const input = document.getElementById('input_' + tag);
    const defaultValue = input.getAttribute('data-default');
    input.value = defaultValue;
    applySetting(tag, defaultValue);
}

// Animations véhicule
function toggleDoor(doorIndex) {
    fetch(`https://${GetParentResourceName()}/toggleDoor`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ door: doorIndex })
    });
}

function closeAllDoors() {
    fetch(`https://${GetParentResourceName()}/closeAllDoors`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

// Fonctions véhicule
function toggleEngine() {
    fetch(`https://${GetParentResourceName()}/toggleEngine`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function toggleLights() {
    fetch(`https://${GetParentResourceName()}/toggleLights`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function toggleBrakeLight() {
    fetch(`https://${GetParentResourceName()}/toggleBrakeLight`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}


function toggleHorn() {
    fetch(`https://${GetParentResourceName()}/toggleHorn`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function setNight() {
    fetch(`https://${GetParentResourceName()}/setTime`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ hour: 0, minute: 0 })
    });
}

function setDay() {
    fetch(`https://${GetParentResourceName()}/setTime`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ hour: 12, minute: 0 })
    });
}

function toggleIndicator(type) {
    fetch(`https://${GetParentResourceName()}/toggleIndicator`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ type: type })
    });
}

// Mettre à jour l'état des boutons
function updateVehicleState(state) {
    const engineBtn = document.getElementById('engineBtn');
    const lightsBtn = document.getElementById('lightsBtn');
    const brakeLightBtn = document.getElementById('brakeLightBtn');
    const indicatorLeftBtn = document.getElementById('indicatorLeftBtn');
    const indicatorRightBtn = document.getElementById('indicatorRightBtn');
    const indicatorBothBtn = document.getElementById('indicatorBothBtn');
    const hornBtn = document.getElementById('hornBtn');
    
    if (engineBtn) {
        engineBtn.textContent = 'Moteur: ' + (state.engine ? 'ON' : 'OFF');
        engineBtn.style.background = state.engine ? '#ccffcc' : 'white';
    }
    
    if (lightsBtn) {
        lightsBtn.textContent = 'Lumières: ' + (state.lights ? 'ON' : 'OFF');
        lightsBtn.style.background = state.lights ? '#ccffcc' : 'white';
    }
    
    if (brakeLightBtn) {
        brakeLightBtn.textContent = 'Feux stop: ' + (state.brakeLight ? 'ON' : 'OFF');
        brakeLightBtn.style.background = state.brakeLight ? '#ffcccc' : 'white';
    }
    
    if (indicatorLeftBtn) {
        indicatorLeftBtn.textContent = 'Clignotant G: ' + (state.indicatorLeft ? 'ON' : 'OFF');
        indicatorLeftBtn.style.background = state.indicatorLeft ? '#fff4cc' : 'white';
    }
    
    if (indicatorRightBtn) {
        indicatorRightBtn.textContent = 'Clignotant D: ' + (state.indicatorRight ? 'ON' : 'OFF');
        indicatorRightBtn.style.background = state.indicatorRight ? '#fff4cc' : 'white';
    }
    
    if (indicatorBothBtn) {
        indicatorBothBtn.textContent = 'Warning: ' + (state.indicatorBoth ? 'ON' : 'OFF');
        indicatorBothBtn.style.background = state.indicatorBoth ? '#ffcccc' : 'white';
    }
    
    if (hornBtn) {
        hornBtn.textContent = 'Klaxon: ' + (state.horn ? 'ON' : 'OFF');
        hornBtn.style.background = state.horn ? '#cce5ff' : 'white';
    }
    
}

// Afficher les animations disponibles
function renderAnimations(doors) {
    const container = document.getElementById('animationsList');
    if (!doors || doors.length === 0) {
        container.innerHTML = '<p>Aucune animation disponible</p>';
        return;
    }
    
    container.innerHTML = doors.map(door => `
        <button onclick="toggleDoor(${door.index})">${door.label}</button>
    `).join('');
}

function renderModkit(mods) {
    if (!mods || mods.length === 0) {
        document.getElementById('exteriorList').innerHTML = '<p>Aucun mod disponible</p>';
        document.getElementById('interiorList').innerHTML = '<p>Aucun mod disponible</p>';
        document.getElementById('propertiesList').innerHTML = '<p>Aucun mod disponible</p>';
        return;
    }
    
    // Séparer les mods par catégorie
    const exteriorMods = mods.filter(mod => mod.category === 'exterior');
    const interiorMods = mods.filter(mod => mod.category === 'interior');
    const propertiesMods = mods.filter(mod => mod.category === 'properties');
    
    // Fonction helper pour générer le HTML des mods
    const generateModHTML = (modsList) => {
        if (modsList.length === 0) {
            return '<p>Aucun mod disponible</p>';
        }
        
        return modsList.map(mod => {
            const currentOption = mod.options.find(opt => opt.current);
            const currentLabel = currentOption ? ` <span style="color: #4CAF50;">(${currentOption.label})</span>` : '';
            
            return `
                <div class="mod-item">
                    <label>${mod.label}${currentLabel}</label>
                    <select onchange="applyMod('${mod.type}', this.value)">
                        ${mod.options.map(opt => `
                            <option value="${opt.value}" ${opt.current ? 'selected' : ''}>${opt.label}</option>
                        `).join('')}
                    </select>
                </div>
            `;
        }).join('');
    };
    
    // Remplir chaque section
    document.getElementById('exteriorList').innerHTML = generateModHTML(exteriorMods);
    document.getElementById('interiorList').innerHTML = generateModHTML(interiorMods);
    document.getElementById('propertiesList').innerHTML = generateModHTML(propertiesMods);
}

function applySetting(type, value) {
    fetch(`https://${GetParentResourceName()}/applySetting`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ type: type, value: parseFloat(value) })
    });
}

function resetHandling() {
    fetch(`https://${GetParentResourceName()}/resetHandling`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function applyMod(type, value) {
    fetch(`https://${GetParentResourceName()}/applyMod`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ type: type, value: parseInt(value) })
    });
}

function GetParentResourceName() {
    if (window.location.hostname === '') {
        return 'pier76menu';
    }
    const hostname = window.location.hostname;
    if (hostname.startsWith('cfx-nui-')) {
        return hostname.replace('cfx-nui-', '');
    }
    return hostname;
}
