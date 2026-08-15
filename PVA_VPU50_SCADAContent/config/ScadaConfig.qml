import QtQuick

QtObject {
    id: scadaConfigRoot

    // =========================================================================
    // 1. SYSTEM, MACHINE & BATCH METADATA (ISA-88 / FDA 21 CFR Part 11 / GAMP 5)
    // =========================================================================
    readonly property string systemName: "PVA Systems VPU-50 Industrial SCADA"
    readonly property string machineName: "VPU 50"
    readonly property string defaultBatchId: "B1"
    readonly property string defaultProductName: "Carbopol 980 Pharma Gel"
    readonly property string defaultRecipeName: "UNIMIX_BATCH_01"
    readonly property string defaultBatchVolume: "500 L"
    readonly property string complianceStandard: "FDA 21 CFR Part 11 & ISPE GAMP 5"
    readonly property string isa88Model: "ISA-88 Batch Control Architecture"
    readonly property string softwareVersion: "v2.6.4-GAMP5"
    readonly property string defaultUserId: "operator"

    // =========================================================================
    // 2. HARDWARE VALVE DEFINITIONS (Solenoids & Manual Butterfly)
    // =========================================================================
    readonly property var valveList: [
        { tag: "V101", name: "Main Vessel Discharge Valve", isSolenoid: true, type: "solenoid" },
        { tag: "V102", name: "External Circulation Line Return Valve", isSolenoid: true, type: "solenoid" },
        { tag: "V103", name: "Recirculation Divert Valve", isSolenoid: true, type: "solenoid" },
        { tag: "V201", name: "CIP Rinse Water Valve", isSolenoid: true, type: "solenoid" },
        { tag: "V202", name: "CIP Drain Discharge Valve", isSolenoid: true, type: "solenoid" },
        { tag: "V203", name: "CIP Air Drying Valve", isSolenoid: true, type: "solenoid" },
        { tag: "V301", name: "Liquid Port Charging Butterfly Valve", isSolenoid: false, type: "manual_butterfly" },
        { tag: "V302", name: "Solids Powder Funnel Butterfly Valve", isSolenoid: false, type: "manual_butterfly" },
        { tag: "V303", name: "Bottom Suction Butterfly Valve", isSolenoid: false, type: "manual_butterfly" }
    ]

    // =========================================================================
    // 3. OPERATION PRESETS & INTERLOCK MATRICES (Recirculation & Suction)
    // =========================================================================
    readonly property var operationPresets: {
        "discharge_product": {
            name: "Discharge Product",
            instruction: "Product Discharge requires opening V101 & V102 solenoid valves, and manually setting V303 Butterfly Valve to OPEN position.",
            expected: { V101: "OPEN", V102: "OPEN", V103: "CLOSED", V201: "CLOSED", V202: "CLOSED", V203: "CLOSED", V301: "CLOSED", V302: "CLOSED", V303: "OPEN" }
        },
        "discharge_circulation_pipe": {
            name: "Discharge Circulation Pipe",
            instruction: "Discharge Circulation Pipe requires opening V101 & V102 solenoid valves, and closing all manual charging ports.",
            expected: { V101: "OPEN", V102: "OPEN", V103: "CLOSED", V201: "CLOSED", V202: "CLOSED", V203: "CLOSED", V301: "CLOSED", V302: "CLOSED", V303: "CLOSED" }
        },
        "recirculation": {
            name: "External Circulation",
            instruction: "External Circulation requires opening V102 & V103 solenoid valves, and closing all manual charging ports.",
            expected: { V101: "CLOSED", V102: "OPEN", V103: "OPEN", V201: "CLOSED", V202: "CLOSED", V203: "CLOSED", V301: "CLOSED", V302: "CLOSED", V303: "CLOSED" }
        },
        "cip_discharge": {
            name: "CIP Discharge",
            instruction: "CIP Drain Discharge requires opening V202 Drain Discharge solenoid valve.",
            expected: { V101: "CLOSED", V102: "CLOSED", V103: "CLOSED", V201: "CLOSED", V202: "OPEN", V203: "CLOSED", V301: "CLOSED", V302: "CLOSED", V303: "CLOSED" }
        },
        "cip_drying": {
            name: "CIP Drying",
            instruction: "CIP Air Drying requires opening V203 Air Drying solenoid valve.",
            expected: { V101: "CLOSED", V102: "CLOSED", V103: "CLOSED", V201: "CLOSED", V202: "CLOSED", V203: "OPEN", V301: "CLOSED", V302: "CLOSED", V303: "CLOSED" }
        },
        "cip_rinse": {
            name: "CIP Rinse Water",
            instruction: "CIP Water Rinse requires opening V201 Rinse & V202 Drain solenoid valves.",
            expected: { V101: "CLOSED", V102: "CLOSED", V103: "CLOSED", V201: "OPEN", V202: "OPEN", V203: "CLOSED", V301: "CLOSED", V302: "CLOSED", V303: "CLOSED" }
        },
        "suction_liquids": {
            name: "Suction Liquids",
            instruction: "Liquid Port Charging requires manually turning V301 Butterfly Valve to OPEN position.",
            expected: { V101: "CLOSED", V102: "CLOSED", V103: "CLOSED", V201: "CLOSED", V202: "CLOSED", V203: "CLOSED", V301: "OPEN", V302: "CLOSED", V303: "CLOSED" }
        },
        "suction_solids": {
            name: "Suction Solids",
            instruction: "Solids Powder Funnel Charging requires manually turning V302 Butterfly Valve to OPEN position.",
            expected: { V101: "CLOSED", V102: "CLOSED", V103: "CLOSED", V201: "CLOSED", V202: "CLOSED", V203: "CLOSED", V301: "CLOSED", V302: "OPEN", V303: "CLOSED" }
        },
        "suction_bottom": {
            name: "Suction Bottom",
            instruction: "Bottom Port Suction requires manually turning V303 Butterfly Valve to OPEN position.",
            expected: { V101: "CLOSED", V102: "CLOSED", V103: "CLOSED", V201: "CLOSED", V202: "CLOSED", V203: "CLOSED", V301: "CLOSED", V302: "CLOSED", V303: "OPEN" }
        }
    }

    // Preset Normalizer Function
    function getPreset(key) {
        var normKey = String(key || "").toLowerCase();
        if (normKey.indexOf("ext_") === 0) normKey = normKey.substring(4);

        if (normKey === "discharge_circulation" || normKey === "discharge circulation" || normKey === "discharge circulation pipe") {
            normKey = "discharge_circulation_pipe";
        } else if (normKey === "discharge_product" || normKey === "discharge product") {
            normKey = "discharge_product";
        } else if (normKey === "cip_rinse" || normKey === "cip rinse") {
            normKey = "cip_rinse";
        } else if (normKey === "cip_discharge" || normKey === "cip discharge") {
            normKey = "cip_discharge";
        } else if (normKey === "cip_drying" || normKey === "cip drying") {
            normKey = "cip_drying";
        } else if (normKey === "recirculation" || normKey === "external_circulation" || normKey === "external circulation") {
            normKey = "recirculation";
        } else if (normKey === "suction_liquids" || normKey === "suction liquids") {
            normKey = "suction_liquids";
        } else if (normKey === "suction_solids" || normKey === "suction solids") {
            normKey = "suction_solids";
        } else if (normKey === "suction_bottom" || normKey === "suction bottom") {
            normKey = "suction_bottom";
        }

        return operationPresets[normKey] || operationPresets["discharge_circulation_pipe"];
    }

    // =========================================================================
    // 4. USER AUTHENTICATION & RBAC HIERARCHY (21 CFR Part 11)
    // =========================================================================
    readonly property var userList: [
        {
            id: "operator",
            name: "Line Operator",
            role: "Operator (Level 1)",
            level: 1,
            pin: "1234",
            description: "Standard production operation, alarm acknowledgement, process start/stop."
        },
        {
            id: "supervisor",
            name: "Production Supervisor",
            role: "Supervisor (Level 2)",
            level: 2,
            pin: "2345",
            description: "Recipe parameter adjustment, batch phase verification, alarm limit overrides."
        },
        {
            id: "qa_officer",
            name: "Florian Rismondo",
            role: "QA Officer (21 CFR Part 11)",
            level: 3,
            pin: "3456",
            description: "Electronic Batch Record sign-off, audit trail verification, batch release."
        },
        {
            id: "engineer",
            name: "Service Engineer",
            role: "Maintenance (Level 4)",
            level: 4,
            pin: "4567",
            description: "Hardware I/O diagnostics, motor VFD calibration, forced valve overrides."
        },
        {
            id: "admin",
            name: "System Administrator",
            role: "Administrator (Level 5)",
            level: 5,
            pin: "9999",
            description: "Full unrestricted system access, user management, security audit log export."
        }
    ]

    function getUser(userId) {
        for (var i = 0; i < userList.length; i++) {
            if (userList[i].id === userId) return userList[i];
        }
        return userList[0]; // Fallback to operator
    }

    function verifyCredentials(userId, pin) {
        var user = getUser(userId);
        return (user && user.pin === pin);
    }

    // =========================================================================
    // 5. MOTOR & EQUIPMENT SPECIFICATIONS
    // =========================================================================
    readonly property var motorSpecs: {
        "stirrer": {
            name: "Agitator Stirrer (1M1501)",
            peakPowerKw: 8.0,
            peakCurrentA: 25.0,
            minSpeedRpm: 30.0,
            maxSpeedRpm: 220.0,
            defaultSpeedRpm: 40.0
        },
        "homogenizer": {
            name: "High-Shear Homogenizer (1M2003)",
            peakPowerKw: 20.0,
            peakCurrentA: 38.0,
            minSpeedRpm: 500.0,
            maxSpeedRpm: 8000.0,
            defaultSpeedRpm: 2500.0
        },
        "vacuum": {
            name: "Vacuum Pump System (1P1001)",
            minPressureMbar: -1000.0,
            maxPressureMbar: 0.0,
            vacuumPresetMbar: -400.0,
            materialLoadingPresetMbar: -850.0,
            allowedDeviationMbar: 5.0
        }
    }

    // =========================================================================
    // 6. PROCESS ROW VISIBILITY MATRIX
    // =========================================================================
    readonly property var rowVisibility: {
        "row1_agitator": true,
        "row2_homogenizer": true,
        "row3_recirculation": true,
        "row4_vacuum": true,
        "row5_suction_ports": false,
        "row6_heating_cooling": true
    }
}
