// Interface Definition
interface IStudent {
    studentId: number;
    studentName: string;
    course: string;
    email?: string;   // Optional property
}

// Student Object 1
let student1: IStudent = {
    studentId: 101,
    studentName: "Dhruval Gamit",
    course: "Angular",
    email: "dhruval@example.com"
};

// Student Object 2
let student2: IStudent = {
    studentId: 102,
    studentName: "Rahul Patel",
    course: "TypeScript"
};

// Display Student 1 Details
console.log("Student 1 Details");
console.log("Student ID:", student1.studentId);
console.log("Student Name:", student1.studentName);
console.log("Course:", student1.course);
console.log("Email:", student1.email);

console.log("-----------------------");

// Display Student 2 Details
console.log("Student 2 Details");
console.log("Student ID:", student2.studentId);
console.log("Student Name:", student2.studentName);
console.log("Course:", student2.course);
console.log("Email:", student2.email);