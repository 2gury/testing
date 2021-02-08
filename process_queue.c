#include <linux/module.h>
#include <linux/init.h>
#include <linux/errno.h>
#include <linux/fs.h>
#include <linux/time.h>
#include <linux/proc_fs.h>
#include <linux/kernel.h>
#include <linux/list.h>
#include <linux/slab.h>
#include <linux/x.h>

MODULE_AUTHOR("Anton Timonin");
MODULE_DESCRIPTION("Process Queue Module");
MODULE_LICENSE("GPL");

/*Макросы*/
#define ALL_REG_PIDS	-100
#define	INVALID_PID		-1

/*Состояния процессов*/
enum process_state {
	
	eCreated		=	0, /*Процесс сощдан*/
	eRunning		=	1, /*Процесс выполняется*/
	eWaiting		=	2, /*Процесс в состоянии ожидания*/
	eBlocked		=	3, /*Процесс заблокирован*/
	eTerminated		=	4  /*Процесс завершен*/
};


/*Состояние задач*/
enum task_status_code {

	eTaskStatusExist 		= 	0,	/*Задача все еще в ОС*/
	eTaskStatusTerminated 	=  -1   /*Задача выполнена*/
};

/*Структура  для процесса*/
struct proc {
	int pid; 					/*Идентификатор процесса*/
	enum process_state state;	/*Состояние процесса*/
	struct list_head list;		/*Указатель списка для создания списка процессов*/
}top;

/*Семафор для очереди процессов*/
static struct semaphore mutex;

/*Прототипы функций для функций очереди задач*/
enum task_status_code task_status_change(int pid, enum process_state eState);
enum task_status_code is_task_exists(int pid);

/*Прототипы функций для функций очереди процессов*/
int init_process_queue(void);
int release_process_queue(void);
int add_process_to_queue(int pid);
int remove_process_from_queue(int pid);
int print_process_queue(void);
int change_process_state_in_queue(int pid, int changeState);
int get_first_process_in_queue(void);
int remove_terminated_processes_from_queue(void);

/*Функция инициализации очереди процессов*/
int init_process_queue(void) {

	printk(KERN_INFO "Initializing the Process Queue...\n");
	/*Генерация начала очереди и инциализация пустой очереди*/
	INIT_LIST_HEAD(&top.list);
	return 0;
}

/*Функция для освобождения очереди процессов*/
int release_process_queue(void) {
		 	
	struct proc *tmp, *node;
	printk(KERN_INFO "Releasing Process Queue...\n");
	
    /*Идем по списку процессов и освбождаем каждый из узлов*/
	list_for_each_entry_safe(node, tmp, &(top.list), list) {
	
        /*Удаление указателя узла на список*/
		list_del(&node->list);
		/*Освобождение памяти узла*/
		kfree(node);
	}

    return 0;
}

/*Функция для добавления процесса в очередь процессов*/
int add_process_to_queue(int pid) {
			
    /*Выделение  информации для нового процесса*/
	struct proc *new_process = kmalloc(sizeof(struct proc), GFP_KERNEL);
	
    /*Проверка на корректность освобождения памяти*/
	if(!new_process) {

		printk(KERN_ALERT "Process Queue ERROR:kmalloc function failed from add_process_to_queue function.");
		return -ENOMEM;
	}
    /*Инициализация структуры нового процесса*/
	new_process->pid = pid;
	new_process->state = eWaiting;
    
    /*Смена статуса задачи в состояние ожидания*/
	task_status_change(new_process->pid, new_process-> state);

    /*Проверка доступности семафора (если не доступен, то процесс будет помещен в очередь ожидания семафора). Блокирует семафор для осуществления определенных действий. Обеспечивает безопасный доступ к критической секции*/
	if(down_interruptible(&mutex)){
		printk(KERN_ALERT "Process Queue ERROR:Mutual Exclusive position access failed from add function");
		return -ERESTARTSYS;
	}

	/*Инициализация списка процессов*/
	INIT_LIST_HEAD(&new_process->list);
	/*Установка нового списка процессов в конец списка процессов*/
	list_add_tail(&(new_process->list), &(top.list));
	
	/*Освобождение критической секции для других процессов/потоков*/
	up(&mutex);

	printk(KERN_INFO "Adding the given Process %d to the  Process Queue...\n", pid);
    
	return 0;
}

/*Функция для удаления процесса из очереди процессов*/
int remove_process_from_queue(int pid) {
		 	
	struct proc *tmp, *node;
	
    /*Проверка доступности семафора (если не доступен, то процесс будет помещен в очередь ожидания семафора). Блокирует семафор для осуществления определенных действий. Обеспечивает безопасный доступ к критической секции*/
	if(down_interruptible(&mutex)){
		printk(KERN_ALERT "Process Queue ERROR:Mutual Exclusive position access failed from remove function");
		return -ERESTARTSYS;
	}
    
    /*Проход по очереди процессов для поиска соответсвующего процесса*/
	list_for_each_entry_safe(node, tmp, &(top.list), list) {
	
		/*Проверка на совпадение текущего идентификатора с разыскиваемым*/
		if(node->pid == pid) {
			printk(KERN_INFO "Removing the given Process %d from the  Process Queue...\n", pid);
            /*Удаление указателя узла на список*/
            list_del(&node->list);
            /*Освобождение памяти узла*/
            kfree(node);
		}
	}
	
    /*Освобождение критической секции для других процессов/потоков*/
	up(&mutex);
	return 0;
}

/*Функция для удаления всех завершенных процессов из очереди процессов*/
int remove_terminated_processes_from_queue(void) {
		 	
	struct proc *tmp, *node;
    
    /*Проверка доступности семафора (если не доступен, то процесс будет помещен в очередь ожидания семафора). Блокирует семафор для осуществления определенных действий. Обеспечивает безопасный доступ к критической секции*/
	if(down_interruptible(&mutex)){
		printk(KERN_ALERT "Process Queue ERROR:Mutual Exclusive position access failed from remove function");
		return -ERESTARTSYS;
	}
    
    /*Проход по очереди процессов чтобы убрать все завершенные процессы*/
	list_for_each_entry_safe(node, tmp, &(top.list), list) {
	
        /*Проверка на то, завершен ли процесс или нет*/
		if(node->state == eTerminated) {
			printk(KERN_INFO "Removing the terminated Process %d from the  Process Queue...\n", node->pid);
            /*Удаление указателя узла на список*/
			list_del(&node->list);
            /*Освобождение памяти узла*/
			kfree(node);
		}
	}
	
    /*Освобождение критической секции для других процессов/потоков*/
	up(&mutex);
	return 0;
}

/*Функция для смены состояния процесса в очереди процессов*/
int change_process_state_in_queue(int pid, int changeState) {
		 	
	struct proc *tmp, *node;

	/*enum для вызова функции task_status_change*/
	enum process_state ret_process_change_status;

    /*Проверка доступности семафора (если не доступен, то процесс будет помещен в очередь ожидания семафора). Блокирует семафор для осуществления определенных действий. Обеспечивает безопасный доступ к критической секции*/
	if(down_interruptible(&mutex)){
		printk(KERN_ALERT "Process Queue ERROR:Mutual Exclusive position access failed from change process state function");
		return -ERESTARTSYS;
	}
    
    /*Проверка на то, все ли зарегистрированные PID изменены для состояния*/
	if(pid == ALL_REG_PIDS) {
        /*Проход по очереди процессов и установка предоставленного статуса*/
		list_for_each_entry_safe(node, tmp, &(top.list), list) {
	
			printk(KERN_INFO "Updating the process state the Process %d in  Process Queue...\n", node->pid);
			/*Обновление статуса на предоставленный*/
			node->state = changeState;
            /*Проверка на то, завершени ли процесс или нет*/
			if(task_status_change(node->pid, node->state)==eTaskStatusTerminated) {
                /*Изменение состояния на завершенное. В последствии будет обработано remove_all_terminated_processes*/
				node->state = eTerminated;
			}
		}
	}
	else {
        /*Проход по очереди процессов и обновление предоставленного статуса*/
		list_for_each_entry_safe(node, tmp, &(top.list), list) {
		
            /*Проверка на то, нужный это процесс или нет*/
			if(node->pid == pid) {
				
				printk(KERN_INFO "Updating the process state the Process %d in  Process Queue...\n", pid);
                /*Обновление статуса на предоставленный*/
				node->state = changeState;
                /*Проверка на то, существует ли процесс или нет*/
				if(task_status_change(node->pid, node->state)==eTaskStatusTerminated) {
                    /*Изменение состояние процесса на завершенное. В последствии будет обработано remove_all_terminated_processes*/
					node->state = eTerminated;
                    /*Возвращаемое значение обновляется, чтобы уведомить о том, что нужный процесс завершен*/
					ret_process_change_status = eTerminated;
				}
			}
			else {
				/*Проверка на то, существует ли задача, связанная с итерационным узлом*/
				if(is_task_exists(node->pid)==eTaskStatusTerminated) {
                    /*Изменение состояние на завершенное. В последствии будет обработано remove_all_terminated_processes*/
					node->state = eTerminated;
				}
			}
		}
	}
    
    /*Освобождение критической секции для других процессов/потоков*/
	up(&mutex);

    /*Возвращение измененного состояния процесс, связанного с внутренним вызовом метода изменения задачи*/
	return ret_process_change_status;
}

/*Функция для вывода очереди процессов*/
int print_process_queue(void) {
			
	struct proc *tmp;
	printk(KERN_INFO "Process Queue: \n");
    
    /*Проверка доступности семафора (если не доступен, то процесс будет помещен в очередь ожидания семафора). Блокирует семафор для осуществления определенных действий. Обеспечивает безопасный доступ к критической секции*/
	if(down_interruptible(&mutex)){
		printk(KERN_ALERT "Process Queue ERROR:Mutual Exclusive position access failed from print function");
		return -ERESTARTSYS;
	}	
    /*Проход по очереди процессов и вывод id каждого процоесса*/
	list_for_each_entry(tmp, &(top.list), list) {
	
		printk(KERN_INFO "Process ID: %d\n", tmp->pid);
	}
	
    /*Освобождение критической секции для других процессов/потоков*/
	up(&mutex);
	return 0;
}

/*Функция для получения первого процесса в очереди процессов*/
int get_first_process_in_queue(void) {

	struct proc *tmp;
    /*Инициализация pid как недействитильного*/
	int pid = INVALID_PID;
	
    /*Проверка доступности семафора (если не доступен, то процесс будет помещен в очередь ожидания семафора). Блокирует семафор для осуществления определенных действий. Обеспечивает безопасный доступ к критической секции*/
	if(down_interruptible(&mutex)){
		printk(KERN_ALERT "Process Queue ERROR:Mutual Exclusive position access failed from print function");
		return -ERESTARTSYS;
	}	

    /*Проход по очереди процессов и поиск первого незавершенного процесса*/
	list_for_each_entry(tmp, &(top.list), list) {
        /*Проверка на то, завершена ли задача у процесса или нет*/
		if((pid==INVALID_PID)&&(is_task_exists(tmp->pid)==eTaskStatusExist)) {
			/*Установка идентификатора процесса для прочтения этого процесса*/
			pid = tmp->pid;
		}

	}
	
    /*Освобождение критической секции для других процессов/потоков*/
	up(&mutex);

    /*Возвращение идентификатора первого процесса*/
	return pid;
}

/*Функция, проверяющая существует ли задача или нет*/
enum task_status_code is_task_exists(int pid) {
	
	struct task_struct *current_pr;
    /*Получения структуры задачи связанной с прооцессом*/
	current_pr = pid_task(find_vpid(pid), PIDTYPE_PID);
    /*Проверка существования задачи*/
	if(current_pr == NULL) {
        /*Возвращение статуса задачи как завершенного*/
		return eTaskStatusTerminated;
	}
    
    /*Возвращение статуса задачи как существуюшего*/
	return eTaskStatusExist;
}

/*Функция меняет статус задачи*/
enum task_status_code task_status_change(int pid, enum process_state eState) {

	struct task_struct *current_pr;
    /*Получения структуры задачи связанной с прооцессом*/
	current_pr = pid_task(find_vpid(pid), PIDTYPE_PID);
    /*Проверка существования задачи*/
	if(current_pr == NULL) {
        /*Возвращение статуса задачи как завершенного*/
		return eTaskStatusTerminated;
	}

    /*Проверка на то, что состояние изменения было eRunning*/
	if(eState == eRunning) {
		/*Вызов сигнала для продолжения задачи, связанной с процессом*/
		kill_pid(task_pid(current_pr), SIGCONT, 1);
		printk(KERN_INFO "Task status change to Running\n");
	}
    /*Проверка на то, что состояние изменения было eWaiting*/
	else if(eState == eWaiting) {
        /*Вызов сигнала для приостановки задачи, связанной с процессом*/
		kill_pid(task_pid(current_pr), SIGSTOP, 1);
		printk(KERN_INFO "Task status change to Waiting\n");
	}
    /*Проверка на то, что состояние изменения было eBlocked*/
	else if(eState == eBlocked) {

		printk(KERN_INFO "Task status change to Blocked\n");
	}
    /*Проверка на то, что состояние изменения было eTerminated*/
	else if(eState == eTerminated) {

		printk(KERN_INFO "Task status change to Terminated\n");
	}
    
    /*Возвращение статуса задаси как существующего*/
	return eTaskStatusExist;
}

/*Функция инициализации модуля ядра. Вызывается при запуске модуля ядра*/
static int __init process_queue_module_init(void)
{
	printk(KERN_INFO "Process Queue module is being loaded.\n");
    /*Инициализация семафоров*/
	/*Установка мьютекса, используемого для критической секции внутри модулей fifo, как 1.
      Указывает, что критическая секция свободна для использования.*/
	sema_init(&mutex,1); 		
	
    /*Инициализация очереди процессов*/
	init_process_queue();

	return 0;
}

/*Функция очистки модуля ядра. Вызывается при удалении модуля ядра*/
static void __exit process_queue_module_cleanup(void)
{
	printk(KERN_INFO "Process Queue module is being unloaded.\n");
    /*Освобождение очереди процессов*/
	release_process_queue();
}

module_init(process_queue_module_init);
module_exit(process_queue_module_cleanup);

EXPORT_SYMBOL_GPL(init_process_queue);
EXPORT_SYMBOL_GPL(release_process_queue);
EXPORT_SYMBOL_GPL(add_process_to_queue);
EXPORT_SYMBOL_GPL(remove_process_from_queue);
EXPORT_SYMBOL_GPL(print_process_queue);
EXPORT_SYMBOL_GPL(get_first_process_in_queue);
EXPORT_SYMBOL_GPL(change_process_state_in_queue);
EXPORT_SYMBOL_GPL(remove_terminated_processes_from_queue);
