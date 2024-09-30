import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class PetRegistry {
    public static void main(String[] args) {
        List<Animal> pets = new ArrayList<>();
        try (Counter counter = new Counter(); Scanner scanner = new Scanner(System.in)) {
            boolean running = true;

            while (running) {
                System.out.println("1. Завести новое животное");
                System.out.println("2. Показать список животных");
                System.out.println("3. Обучить животное новой команде");
                System.out.println("4. Выйти");

                int choice = scanner.nextInt();
                scanner.nextLine(); 

                switch (choice) {
                    case 1:
                        System.out.println("Введите имя животного:");
                        String name = scanner.nextLine();
                        System.out.println("Введите тип животного (dog/cat/hamster/horse/camel/donkey):");
                        String type = scanner.nextLine().toLowerCase();

                        Animal animal;
                        if (type.equals("dog")) {
                            animal = new Dog(name);
                        } else if (type.equals("cat")) {
                            animal = new Cat(name);
                        } else if (type.equals("hamster")) {
                            animal = new Hamster(name);
                        } else if (type.equals("horse")) {
                            animal = new Horse(name);
                        } else if (type.equals("camel")) {
                            animal = new Camel(name);
                        } else if (type.equals("donkey")) {
                            animal = new Donkey(name);
                        } else {
                            System.out.println("Неизвестный тип животного.");
                            continue;
                        }

                        pets.add(animal);
                        counter.add(); 
                        System.out.println("Животное добавлено!");
                        break;
                    case 2:
                        System.out.println("Список животных:");
                        for (Animal pet : pets) {
                            System.out.println("Имя: " + pet.getName() + ", Команда: " + pet.getCommands());
                        }
                        break;

                    case 3:
                        System.out.println("Введите имя животного для обучения:");
                        String animalName = scanner.nextLine();
                        for (Animal pet : pets) {
                            if (pet.getName().equals(animalName)) {
                                System.out.println("Введите новую команду:");
                                String command = scanner.nextLine();
                                pet.learnCommand(command);
                                System.out.println(pet.getName() + " научился команде: " + command);
                                break;
                            }
                        }
                        break;
                    case 4:
                        running = false;
                        break;
                    default:
                        System.out.println("Некорректный ввод. Попробуйте еще раз.");
                        break;
                }
            }
        } catch (Exception e) {
            System.out.println("Произошла ошибка: " + e.getMessage());
        }
    }
}
