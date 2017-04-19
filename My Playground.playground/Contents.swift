//: Playground - noun: a place where people can play

import maths


let matrix = Matrix([Vector([2,4,10]),Vector([4,10,28]),Vector([10,28,82])])
//print(matrix.determinant())
//print(matrix.adjoint())
//print(matrix * matrix.inverse())

let polyFit = PolynomialFit(points: [Vector2d(x:0,y:1), Vector2d(x:1,y:6), Vector2d(x:2,y:17), Vector2d(x:3,y:34), Vector2d(x:4,y:57)])
let v = polyFit.solve(order:4)
var output = "\(String(format:"%0.2f", v[0])) + "
for i in 1..<v.count-1 {
    output += "\(String(format:"%0.2f", v[i]))*x^\(i) + "
}
output += "\(String(format:"%0.2f", v[v.count-1]))*x^\(v.count-1)"
print(output)
print("\(Float(v[0])) + \(Float(v[1]))x + \(Float(v[2]))x^2 +\(Float(v[3]))x^3")


 