import QtQuick
import QtQuick3D

Node {
    id: node

    // Pharmaceutical Polished 316L Stainless Steel PBR Material
    // Balanced natural metallic tone with soft specular glint
    PrincipledMaterial {
        id: stainlessSteelMat
        baseColor: "#cbd5e1"
        metalness: 0.85
        roughness: 0.20
        specularAmount: 1.0
        specularTint: 0.25
        clearcoatAmount: 0.35
        clearcoatRoughnessAmount: 0.15
        emissiveFactor: Qt.vector3d(0.06, 0.07, 0.09)
        cullMode: Material.BackFaceCulling
    }

    // Industrial PTFE Scraper Blade Material (Vibrant Pharmaceutical Blue)
    PrincipledMaterial {
        id: scraperWiperMat
        baseColor: "#0284c7"
        metalness: 0.2
        roughness: 0.3
        specularAmount: 0.8
        emissiveFactor: Qt.vector3d(0.05, 0.08, 0.12)
        cullMode: Material.BackFaceCulling
    }

    // Nodes:
    Node {
        id: root
        objectName: "ROOT"

        Model {
            id: body2086
            objectName: "body2086"
            position: Qt.vector3d(0, 0, 0)
            source: "meshes/body2086_mesh.mesh"
            materials: [
                stainlessSteelMat
            ]
        }

        Model {
            id: body12948
            objectName: "body12948"
            position: Qt.vector3d(0, 0, 0)
            source: "meshes/body12948_mesh.mesh"
            materials: [
                stainlessSteelMat
            ]
        }
    }
}
