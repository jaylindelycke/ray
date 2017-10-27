//
//  SceneViewController.swift
//  ray
//
//  Created by Jay Lindelycke on 01/09/16.
//  Copyright © 2016 Jay Lindelycke. All rights reserved.
//

import UIKit

class SceneViewController: UIViewController {
	var backgroundColor: Color!
	var refractionIndex: Double!
	var light: Plane!
	var camera: Camera!
	var shapes: [Shape] = []

	override func viewDidLoad() {
        super.viewDidLoad()

		backgroundColor = Color(red: 0.05, green: 0.05, blue: 0.05)
		refractionIndex = 1 //Air

		setupLight()

		camera = Camera(sceneDelegate: self)

		setupShapes()

        //TODO
        //Rotate camera up a bit
		//rotate camera by transforming the origin and all pixelRays, how?
        //Change shape sizes to match image
    }

	override func viewDidLayoutSubviews() {
		self.view.addSubview(camera.viewport)
	}

	private func setupLight() {
		let center = Point(x: -200, y: 350, z: 200 - 475)
		light = Plane(
			center: center,
			normal: center.vector(to: Point(x: 0, y: 0, z: 0)).normalized(),
			material: Material(color: Color(red: 255, green: 0, blue: 0))
		)
		//shapes.append(light) //TODO add light to shapes so it can be intersected and visible. But must make a rectangle, so the light plane doent cover whole background
	}

	private func setupShapes() {
		// Spheres
		shapes.append(Sphere(
			center: Point(x: -175, y: 0, z: -125 - 475), radius: 37,
			material: Material(
				color: Color(red: 0.5, green: 0.0, blue: 1.0),
				shininess: 0.4,
				reflectivity: 0.2),
			cameraOrigin: camera.origin))

		shapes.append(Sphere(
			center: Point(x: -125, y: 0, z: -25 - 475), radius: 37,
			material: Material(
				color: Color(red: 1.0, green: 0.0, blue: 0.0),
				shininess: 0.4,
				reflectivity: 0.2),
			cameraOrigin: camera.origin))

		shapes.append(Sphere(
			center: Point(x: -125, y: 0, z: +125 - 475), radius: 37,
			material: Material(
				color: Color(red: 0.0, green: 0.0, blue: 1.0),
				shininess: 0.4,
				reflectivity: 0.2),
			cameraOrigin: camera.origin))

		shapes.append(Sphere(
			center: Point(x: -75, y: 0, z: -75 - 475), radius: 37,
			material: Material(
				color: Color(red: 0.0, green: 1.0, blue: 0.0),
				shininess: 0.4,
				reflectivity: 0.2),
			cameraOrigin: camera.origin, id: "greenBall"))

		shapes.append(Sphere(
			center: Point(x: -25, y: 0, z: +25 - 475), radius: 37,
			material: Material(
				color: Color(red: 1.0, green: 1.0, blue: 1.0),
				shininess: 0.0,
				reflectivity: 0.0,
				opacity: 0.0, refractionIndex: 1.52),
			cameraOrigin: camera.origin, id: "glassBall"))

		shapes.append(Sphere(
			center: Point(x: +25, y: 0, z: -175 - 475), radius: 37,
			material: Material(
				color: Color(red: 0.0, green: 0.0, blue: 1.0),
				shininess: 0.4,
				reflectivity: 0.2),
			cameraOrigin: camera.origin, id: "blueBall"))

		shapes.append(Sphere(
			center: Point(x: +75, y: 0, z: +125 - 475), radius: 37,
			material: Material(
				color: Color(red: 0.5, green: 0.0, blue: 1.0),
				shininess: 0.4,
				reflectivity: 0.2),
			cameraOrigin: camera.origin))

		shapes.append(Sphere(
			center: Point(x: +125, y: 0, z: -25 - 475), radius: 37,
			material: Material(
				color: Color(red: 1.0, green: 0.0, blue: 0.0),
				shininess: 0.4,
				reflectivity: 0.2),
			cameraOrigin: camera.origin))

		shapes.append(Sphere(
			center: Point(x: +175, y: 0, z: +125 - 475), radius: 37,
			material: Material(
				color: Color(red: 0.0, green: 1.0, blue: 0.0),
				shininess: 0.4,
				reflectivity: 0.2),
			cameraOrigin: camera.origin))

		// Plane
		shapes.append(Plane(
			center: Point(x: 0, y: -37, z: 100),
			normal: Point(x: 0, y: 1, z: 0),
			material: Material(
				color: Color(red: 0.0, green: 0.5, blue: 0.5),
				shininess: 0.4,
				reflectivity: 0.2)))
	}

}
