//: Playground - noun: a place where people can play

import maths

let a = Vector([1,4,5,6])
let b = Vector([1,4,5,6])
print(a.Magnitude())
print(Vector.Dot(a,b))

let c = Vector([5,1,0])
let c2 = Vector([5,1,0,1])
let m = Matrix( [Vector([1,0,0]), Vector([0,1,0]), Vector([0,0,1]), Vector([10,5,8])] )
let m2 = Matrix( [Vector([1,0,0,0]), Vector([0,1,0,0]), Vector([0,0,1,0]), Vector([0,0,0,1])] )
print(m*c)
print(c2*m)
print(Matrix([c2])*m)
print(m2*m)

