import Foundation

//Adicionando Circulo (bola)
let ball = OvalShape(width: 40, height: 40)


//Adicionando um funil
let funnelPoints = [
Point(x: 0, y: 50),
Point(x: 80, y: 50),
Point(x: 60, y: 0),
Point(x: 20, y: 0)
]

let funnel = PolygonShape(points: funnelPoints)

//REFATORACAO
//Adicionando varias barreiras
var barriers: [Shape] = []

//Adicionando varios alvos
var targets: [Shape] = []


/*
The setup() function is called once when the app launches. Without it, your app won't compile.
Use it to set up and start your app.

You can create as many other functions as you want, and declare variables and constants,
at the top level of the file (outside any function). You can't write any other kind of code,
for example if statements and for loops, at the top level; they have to be written inside
of a function.
*/

fileprivate func setupBall() {
    //Adicionando o circulo na cena
    ball.position = Point(x: 250, y: 400)
    scene.add(ball)
    //Faz com que a bola caia
    ball.hasPhysics = true
    ball.fillColor = .orange
    ball.onCollision = ballCollided(with:)
    ball.isDraggable = false
    scene.trackShape(ball)
    ball.onExitedScene = ballExitedScene
    ball.bounciness = 0.6
    //callback
    ball.onTapped = resetGame
}

fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    let barrierPoints = [
    Point(x: 0, y: 0),
    Point(x: 0, y: height),
    Point(x: width, y: height),
    Point(x: width, y: 0)
    ]
    
    let barrier = PolygonShape(points: barrierPoints)
    
    barriers.append(barrier)
    
    //Adicionando uma barreira na cena
    barrier.position = position
    barrier.hasPhysics = true
    scene.add(barrier)
    barrier.isImmobile = true
    barrier.angle = angle
    barrier.fillColor = .brown
}

fileprivate func setupFunnel() {
    //Adicionando o funil na cena
    funnel.position = Point(x: 200, y: scene.height - 25)
    scene.add(funnel)
    funnel.fillColor = .gray
    //callback
    funnel.onTapped = dropBall
    funnel.isDraggable = false
}

fileprivate func addTarget(at position: Point) {
    
    let targetPoints = [
    Point(x: 10, y: 0),
    Point(x: 0, y: 10),
    Point(x: 10, y: 20),
    Point(x: 20, y: 10),
    ]
    
    let target = PolygonShape(points: targetPoints)
    targets.append(target)
    
    //Adicionando os alvos na cena
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    scene.add(target)
    target.name = "target"
   // target.isDraggable = false
}


func setup() {
    
    setupBall()
    
    addBarrier(at: Point(x: 200, y: 150), width: 80, height: 25, angle: 0.1)
    addBarrier(at: Point(x: 100, y: 150), width: 30, height: 15, angle: -0.2)
    addBarrier(at: Point(x: 300, y: 150), width: 100, height: 25, angle: 03)
    
    setupFunnel()
    
    addTarget(at: Point(x: 150, y: 400))
    addTarget(at: Point(x: 111, y: 474))
    addTarget(at: Point(x: 256, y: 280))
    addTarget(at: Point(x: 151, y: 242))
    addTarget(at: Point(x: 165, y: 40))
    
    resetGame()
    
    scene.onShapeMoved = printPosition(of:)
    
}


//Funcao para reposicionar a bola
//Libera a bola movendo-a para a posicao do funil
func dropBall() {
    ball.position = funnel.position
    ball.stopAllMotion()
    
    for barrier in barriers {
        barrier.isDraggable = false
    }
    
    for target in targets {
        target.fillColor = .yellow
    }
}


//Funcao para processa colisoes entre a bola e os alvos
func ballCollided(with otherShape: Shape) {
    if otherShape.name != "target" {
        return
    }
    
    otherShape.fillColor = .green
}

//Funcao para quando a bola sair de cena
func ballExitedScene() {
    var hitTargets = 0
    for target in targets {
        if target.fillColor == .green {
            hitTargets += 1
        }
    }
    if hitTargets == targets.count {
        print("Won game!")
        scene.presentAlert(text: "Você ganhou!", completion: alertDismissed)
    }
    
    for barrier in barriers {
        barrier.isDraggable = true
    }
    
}

//Funcao para reiniciar o jogo removendo a bola abaixo da cena, que desbloqueara as barreiras
func resetGame() {
    ball.position = Point(x: 0, y: -80)
}

func printPosition(of shape: Shape) {
    print(shape.position)
}

func alertDismissed() {
    
}