import QtQuick

Item {
    id: rootIcon
    width: 32
    height: 32

    property string iconName: ""
    property color iconColor: "#ffffff"
    property string iconSource: ""

    function resolveSource(name) {
        if (iconSource !== "") return iconSource;
        if (!name || name === "") return "";

        var map = {
            // Equipment Main Icons
            "agitator": "../../assets/icons/modes/agitator/stirrer_agitator.svg",
            "stirrer": "../../assets/icons/modes/agitator/stirrer_agitator.svg",
            "stirrer_agitator": "../../assets/icons/modes/agitator/stirrer_agitator.svg",
            "disperser": "../../assets/icons/modes/homogenizer/homogenizer.svg",
            "homo": "../../assets/icons/modes/homogenizer/homogenizer.svg",
            "homogenizer": "../../assets/icons/modes/homogenizer/homogenizer.svg",
            "recirc": "../../assets/icons/modes/plant/external_circulation.svg",
            "circulation": "../../assets/icons/modes/plant/external_circulation.svg",
            "external_circulation": "../../assets/icons/modes/plant/external_circulation.svg",
            "vacuum": "../../assets/icons/modes/plant/vacuum_gauge.svg",
            "vacuum_gauge": "../../assets/icons/modes/plant/vacuum_gauge.svg",
            "suction": "../../assets/icons/modes/suction/suction.svg",
            "heating": "../../assets/icons/modes/plant/heating_jacket.svg",
            "heating_jacket": "../../assets/icons/modes/plant/heating_jacket.svg",
            "thermometer": "../../assets/icons/modes/plant/heating_jacket.svg",

            // Mode Tiles
            "agitator_cw": "../../assets/icons/modes/agitator/agitator_cw.svg",
            "agitator_ccw": "../../assets/icons/modes/agitator/agitator_ccw.svg",
            "agitator_reversing": "../../assets/icons/modes/agitator/agitator_reversing.svg",
            "homo_permanent": "../../assets/icons/modes/homogenizer/homo_permanent.svg",
            "homo_interval": "../../assets/icons/modes/homogenizer/homo_interval.svg",
            "suction_liquids": "../../assets/icons/modes/suction/suction_liquids_tile.svg",
            "suction_liquids_tile": "../../assets/icons/modes/suction/suction_liquids_tile.svg",
            "suction_solids": "../../assets/icons/modes/suction/suction_solids_tile.svg",
            "suction_solids_tile": "../../assets/icons/modes/suction/suction_solids_tile.svg",
            "suction_bottom": "../../assets/icons/modes/suction/suction_bottom_tile.svg",
            "suction_bottom_tile": "../../assets/icons/modes/suction/suction_bottom_tile.svg",

            // Navigation Icons
            "dashboard": "../../assets/icons/nav/status_stack.svg",
            "nav_dashboard": "../../assets/icons/nav/status_stack.svg",
            "status_stack": "../../assets/icons/nav/status_stack.svg",
            "ctrl": "../../assets/icons/nav/status_stack.svg",
            "control": "../../assets/icons/nav/status_stack.svg",

            "pid": "../../assets/icons/nav/pid_vessel.svg",
            "nav_pid": "../../assets/icons/nav/pid_vessel.svg",
            "pid_vessel": "../../assets/icons/nav/pid_vessel.svg",

            "trends": "../../assets/icons/nav/trends_chart.svg",
            "nav_trends": "../../assets/icons/nav/trends_chart.svg",
            "trends_chart": "../../assets/icons/nav/trends_chart.svg",
            "trend": "../../assets/icons/nav/trends_chart.svg",

            "alarm": "../../assets/icons/nav/alarms_bell.svg",
            "alarms": "../../assets/icons/nav/alarms_bell.svg",
            "nav_alarms": "../../assets/icons/nav/alarms_bell.svg",
            "alarms_bell": "../../assets/icons/nav/alarms_bell.svg",
            "alm": "../../assets/icons/nav/alarms_bell.svg",

            "recipes": "../../assets/icons/nav/recipes_checklist.svg",
            "nav_recipes": "../../assets/icons/nav/recipes_checklist.svg",
            "recipes_checklist": "../../assets/icons/nav/recipes_checklist.svg",
            "rcp": "../../assets/icons/nav/recipes_checklist.svg",

            "audit": "../../assets/icons/nav/docs_report.svg",
            "nav_audit": "../../assets/icons/nav/docs_report.svg",
            "reports": "../../assets/icons/nav/docs_report.svg",
            "nav_reports": "../../assets/icons/nav/docs_report.svg",
            "docs_report": "../../assets/icons/nav/docs_report.svg",
            "ebr": "../../assets/icons/nav/docs_report.svg",

            "playback": "../../assets/icons/nav/logs_order.svg",
            "nav_playback": "../../assets/icons/nav/logs_order.svg",
            "logs": "../../assets/icons/nav/logs_order.svg",
            "nav_logs": "../../assets/icons/nav/logs_order.svg",
            "logs_order": "../../assets/icons/nav/logs_order.svg",
            "log": "../../assets/icons/nav/logs_order.svg",

            "maintenance": "../../assets/icons/nav/tools_maintenance.svg",
            "nav_maintenance": "../../assets/icons/nav/tools_maintenance.svg",
            "tools_maintenance": "../../assets/icons/nav/tools_maintenance.svg",
            "tools": "../../assets/icons/nav/tools_maintenance.svg",
            "diag": "../../assets/icons/nav/tools_maintenance.svg",

            // Control Buttons
            "start": "../../assets/icons/controls/start.svg",
            "start_dark": "../../assets/icons/controls/start_dark.svg",
            "pause": "../../assets/icons/controls/pause.svg",
            "pause_dark": "../../assets/icons/controls/pause_dark.svg",
            "stop": "../../assets/icons/controls/stop.svg",
            "clock": "../../assets/icons/controls/clock.svg",

            // Header Elements
            "user": "../../assets/icons/header/user.svg",
            "lightbulb": "../../assets/icons/header/lightbulb.svg",
            "alarm_bell": "../../assets/icons/header/alarm_bell.svg",
            "logo": "../../assets/icons/header/favicon.svg",
            "favicon": "../../assets/icons/header/favicon.svg",
            "ekato": "../../assets/icons/header/favicon.svg"
        };

        if (map.hasOwnProperty(name)) {
            return map[name];
        }
        return "";
    }

    Image {
        id: imgIcon
        anchors.fill: parent
        anchors.margins: 1
        visible: source.toString() !== ""
        source: rootIcon.resolveSource(rootIcon.iconName)
        fillMode: Image.PreserveAspectFit
        mipmap: true
        smooth: true
        sourceSize.width: 128
        sourceSize.height: 128
    }
}
