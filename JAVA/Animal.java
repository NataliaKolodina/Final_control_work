import java.util.ArrayList;
import java.util.List;


abstract class Animal {
    private String name;
    private List<String> commands;

    public Animal(String name) {
        this.name = name;
        this.commands = new ArrayList<>();
    }

    public String getName() {
        return name;
    }

    public List<String> getCommands() {
        return commands;
    }

    public void learnCommand(String command) {
        commands.add(command);
    }

    public abstract void makeSound();
}

class Dog extends Animal {
    public Dog(String name) {
        super(name);
    }

    @Override
    public void makeSound() {
        System.out.println("Гав-гав!");
    }
}

class Cat extends Animal {
    public Cat(String name) {
        super(name);
    }

    @Override
    public void makeSound() {
        System.out.println("Мяу-мяу!");
    }
}

class Hamster extends Animal {
    public Hamster(String name) {
        super(name);
    }

    @Override
    public void makeSound() {
        System.out.println("Фиу-фиу!");
    }
}

    class Horse extends Animal {
        public Horse(String name) {
            super(name);
        }
    
        @Override
        public void makeSound() {
            System.out.println("Иго-го!");
        }
}

class Camel extends Animal {
    public Camel(String name) {
        super(name);
    }

    @Override
    public void makeSound() {
        System.out.println("Иго-го!");
    }
}

class Donkey extends Animal {
    public Donkey(String name) {
        super(name);
    }

    @Override
    public void makeSound() {
        System.out.println("Иго-го!");
    }
}



class Counter implements AutoCloseable {
    private int count = 0;
    private boolean isOpen = true;

    public void add() {
        if (!isOpen) {
            throw new IllegalStateException("Ресурс должен быть открыт");
        }
        count++;
    }

    public int getCount() {
        return count;
    }

    @Override
    public void close() {
        isOpen = false; 
    }
}
