using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

public static class GeodesicPoints
{
    public static List<Vector3> GenPoints(int subdivides, float radius) {
        const float x = 0.525731112119133606f;
        const float z = 0.850650808352039932f;

        var vertices = new List<Vector3>(new Vector3[] {
            new(-x, 0.0f, z), new(x, 0.0f, z), new(-x, 0.0f, -z), new(x, 0.0f, -z),
            new(0.0f, z, x ), new(0.0f, z, -x), new(0.0f, -z, x), new(0.0f, -z, -x),
            new(z, x, 0.0f ), new(-z, x, 0.0f), new(z, -x, 0.0f), new(-z, -x, 0.0f),
        });

        var indices = new List<int>(new[] {
            1,  4,  0,  4, 9, 0, 4,  5, 9, 8, 5,  4,  1, 8, 4,
            1, 10,  8, 10, 3, 8, 8,  3, 5, 3, 2,  5,  3, 7, 2,
            3, 10,  7, 10, 6, 7, 6, 11, 7, 6, 0, 11,  6, 1, 0,
           10,  1,  6, 11, 0, 9, 2, 11, 9, 5, 2,  9, 11, 2, 7
        });

        // Make sure there is a vertex per index
        var flatVertices= new List<Vector3>();
        var flatIndices = new List<int>();
        for (var i = 0; i < indices.Count; i++)
        {
            flatVertices.Add(vertices[indices[i]]);
            flatIndices.Add(i);
        }
        vertices = flatVertices;
        indices = flatIndices;

        // Subdivide
        for (var i = 0; i < subdivides; i++)
        {
            SubdivideSphere(ref vertices, ref indices);
        }

        // Scale
        for (var i = 0; i < vertices.Count; i++)
        {
            vertices[i] *= radius;
        }

        
        return vertices.Distinct().ToList();;
    }

    private static void SubdivideSphere(ref List<Vector3> vertices, ref List<int> indices)
    {

        var newIndices = new List<int>();

        var triCount = indices.Count / 3;
        for (var tri = 0; tri < triCount; tri++)
        {
            // Get vertices of triangle we will be subdividing
            var oldVertIndex = (tri * 3);
            var idxA = indices[oldVertIndex + 0];
            var idxB = indices[oldVertIndex + 1];
            var idxC = indices[oldVertIndex + 2];
            var vA = vertices[idxA];
            var vB = vertices[idxB];
            var vC = vertices[idxC];

            // Find new vertices
            var vAB = vA.Lerp(vB, 0.5f);
            vAB = vAB.Normalized();
            var vBC = vB.Lerp(vC, 0.5f);
            vBC = vBC.Normalized();
            var vAC = vA.Lerp(vC, 0.5f);
            vAC = vAC.Normalized();

            // Add new vertices to vertices list
            var newVertIndex = vertices.Count;
            vertices.Add(vAB);
            vertices.Add(vBC);
            vertices.Add(vAC);

            // Add new indices
            newIndices.Add(newVertIndex + 0); // Middle Triangle
            newIndices.Add(newVertIndex + 1);
            newIndices.Add(newVertIndex + 2);

            newIndices.Add(newVertIndex + 2); // A triangle
            newIndices.Add(idxA);
            newIndices.Add(newVertIndex + 0);

            newIndices.Add(newVertIndex + 0); // B triangle
            newIndices.Add(idxB);
            newIndices.Add(newVertIndex + 1);

            newIndices.Add(newVertIndex + 1); // C triangle
            newIndices.Add(idxC);
            newIndices.Add(newVertIndex + 2);
        }

        indices = newIndices;
    }
}
