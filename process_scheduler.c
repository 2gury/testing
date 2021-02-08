#include <linux/module.h>
#include <linux/init.h>
#include <linux/errno.h>
#include <linux/fs.h>
#include <linux/time.h>
#include <linux/proc_fs.h>
#include <linux/kernel.h>
#include <linux/list.h>
#include <linux/slab.h>
#include <linux/workqueue.h>
#include <linux/sched.h>

MODULE_AUTHOR("Anton Timonin");
MODULE_DESCRIPTION("Process Scheduler Module");
MODULE_LICENSE("GPL");

/*Макросы*/
#define ALL_REG_PIDS	-100

/*Состояния процессов*/
enum process_state {
    
    eCreated        =    0, /*Процесс сощдан*/
    eRunning        =    1, /*Процесс выполняется*/
    eWaiting        =    2, /*Процесс в состоянии ожидания*/
    eBlocked        =    3, /*Процесс заблокирован*/
    eTerminated     =    4  /*Процесс завершен*/
};

/*Прототипы  внешних  функций очереди процессов*/
extern int add_process_to_queue(int pid);
extern int remove_process_from_queue(int pid);
extern int print_process_queue(void);
extern int change_process_state_in_queue(int pid, int changeState);
extern int get_first_process_in_queue(void);
extern int remove_terminated_processes_from_queue(void);

/*Прототипы функций для планировщика*/
static void context_switch(struct work_struct *w);
int static_round_robin_scheduling(void);

/*Флаги*/
static int flag = 0;

/*Временная переменная хранения для упреждающих планировщиков*/
static int time_quantum=3;

/*Текущий PID*/
static int current_pid = -1;

/*WorkQueue объект*/
struct workqueue_struct *scheduler_wq;

/*Создание объекта delayed_work с помощью предоставленного обработчика функций*/
static DECLARE_DELAYED_WORK(scheduler_hdlr, context_switch);

/*Функция, которая переключает выполняемый процесс на другой. Внутри функция использует свою политику планирования*/
static void context_switch(struct work_struct *w){
	
    /*Статус*/
	bool q_status=false;
	
	printk(KERN_ALERT "Scheduler instance: Context Switch\n");

    /*Вызов статического RR планирования*/
	static_round_robin_scheduling();

    /*Проверка флага выгрузки модуля ядра*/
	if (flag == 0){
        /*Установка задержки выполнения работ для предусмотренного тарифа*/
		q_status = queue_delayed_work(scheduler_wq, &scheduler_hdlr, time_quantum*HZ);
	}
	else
		printk(KERN_ALERT "Scheduler instance: scheduler is unloading\n");
}

/*Функция для статического планирования RR*/
int static_round_robin_scheduling(void)
{
    /*Переменная, котоаря хранит изменение состояния процесса */
	int ret_process_state=-1;

	printk(KERN_INFO "Static Round Robin Scheduling scheme.\n");
	
    /*Удаление всех завершенных процессов из очереди процессов*/
	remove_terminated_processes_from_queue();

    /*Проверка валидности текущего id процесса*/
	if(current_pid != -1) {
        /*Добавление текущего процесса в очередь процессов*/
		add_process_to_queue(current_pid);	
	}

    /*Получение первого процесса в очереди ожидания*/
	current_pid = get_first_process_in_queue();

    /*Проверка валидности id процесса. Если невалидно, то в очереди нет ни одного активного процесса*/
	if(current_pid != -1) {
        /*Изменение состояния процесса полученного из очереди на запущенный*/
		ret_process_state = change_process_state_in_queue(current_pid, eRunning);
        /*Удаление процесса из очереди ожидания*/
		remove_process_from_queue(current_pid);
	}
	
	printk(KERN_INFO "Currently running process: %d\n", current_pid);

    /*Проверка на то, нет ли еще активных процессов в очереди*/
	if(current_pid != -1) {
		printk(KERN_INFO "Current Process Queue...\n");
        /*Вывод очереди процессов*/
		print_process_queue();
		printk(KERN_INFO "Currently running process: %d\n", current_pid);
	}
	
    return 0;
}


/*Функция инициализации модуля ядра. Вызывается при запуске модуля ядра*/
static int __init process_scheduler_module_init(void)
{
    /*Статус очереди*/
	bool q_status=false;

	printk(KERN_INFO "Process Scheduler module is being loaded.\n");
	
    /*Выделение workqueue под именем "scheduler-wq" и количество планировщиков = 1*/
	scheduler_wq = alloc_workqueue("scheduler-wq", WQ_UNBOUND, 1);

    /*Проверка на корректность выделения памяти под workqueue*/
	if (scheduler_wq== NULL){
		
		printk(KERN_ERR "Scheduler instance ERROR:Workqueue cannot be allocated\n");
		return -ENOMEM;
	}
	else {
		/*Установка задержки для выполнения работ заданного тарифа*/
		q_status = queue_delayed_work(scheduler_wq, &scheduler_hdlr, time_quantum*HZ);
	}

	return 0;
}

/*Функция очистки модуля ядра. Вызывается при удалении модуля ядра*/
static void __exit process_scheduler_module_cleanup(void)
{
	/*Флаг выгрузки модуля планировщика*/
	flag = 1;
    /*Отмена отложенных заданий в рабочей очереди*/
	cancel_delayed_work(&scheduler_hdlr);
    /*Удаление всех отложенных заданий рабочей очереди*/
	flush_workqueue(scheduler_wq);
    /*Освобождение рабочей очереди*/
	destroy_workqueue(scheduler_wq);

	printk(KERN_INFO "Process Scheduler module is being unloaded.\n");
}
module_init(process_scheduler_module_init);
module_exit(process_scheduler_module_cleanup);

/*Инициализация time_quantum*/
module_param(time_quantum, int, 0);
