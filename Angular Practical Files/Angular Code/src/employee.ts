// Employee Class
class Employee {
    id: number;
    name: string;
    salary: number;

    // Constructor
    constructor(id: number, name: string, salary: number) {
        this.id = id;
        this.name = name;
        this.salary = salary;
    }

    // Method to Display Employee Details
    displayEmployee(): void {
        console.log("Employee ID:", this.id);
        console.log("Employee Name:", this.name);
        console.log("Salary:", this.salary);
        console.log("-------------------------");
    }
}

// Create Employee Objects
let emp1 = new Employee(101, "Dhruval Gamit", 50000);
let emp2 = new Employee(102, "Rahul Patel", 60000);

// Display Employee Details
console.log("Employee 1 Details");
emp1.displayEmployee();

console.log("Employee 2 Details");
emp2.displayEmployee();