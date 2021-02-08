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

#define ALL_REG_PIDS	-100

enum process_state {
    
    eCreated        =    0,
    eRunning        =    1, 
    eWaiting        =    2,
    eBlocked        =    3, 
    eTerminated     =    4  
};

extern int add_process_to_queue(int pid);
extern int remove_process_from_queue(int pid);
extern int print_process_queue(void);
extern int change_process_state_in_queue(int pid, int changeState);
extern int get_first_process_in_queue(void);
extern int remove_terminated_processes_from_queue(void);

static void context_switch(struct work_struct *w);
int static_round_robin_scheduling(void);

static int flag = 0;

static int time_quantum=3;

static int current_pid = -1;

struct workqueue_struct *scheduler_wq;

static DECLARE_DELAYED_WORK(scheduler_hdlr, context_switch);

static void context_switch(struct work_struct *w){
	
	bool q_status=false;
	
	printk(KERN_ALERT "Process Scheduler: Context Switch\n");

	static_round_robin_scheduling();

	if (flag == 0){
		q_status = queue_delayed_work(scheduler_wq, &scheduler_hdlr, time_quantum*HZ);
	}
	else
		printk(KERN_ALERT "Process Scheduler: scheduler is unloading\n");
}

int static_round_robin_scheduling(void)
{
	int ret_process_state=-1;

	printk(KERN_INFO "Static Round Robin Scheduling scheme.\n");
	
	remove_terminated_processes_from_queue();

	if(current_pid != -1) {
		add_process_to_queue(current_pid);	
	}

	current_pid = get_first_process_in_queue();

	if(current_pid != -1) {
		ret_process_state = change_process_state_in_queue(current_pid, eRunning);
		remove_process_from_queue(current_pid);
	}
	
	printk(KERN_INFO "Currently running process: %d\n", current_pid);

	if(current_pid != -1) {
		printk(KERN_INFO "Current Process Queue...\n");
		print_process_queue();
		printk(KERN_INFO "Currently running process: %d\n", current_pid);
	}
	
    return 0;
}


static int __init process_scheduler_module_init(void)
{
	bool q_status=false;

	printk(KERN_INFO "Process Scheduler module loaded.\n");
	
	scheduler_wq = alloc_workqueue("scheduler-wq", WQ_UNBOUND, 1);

	if (scheduler_wq== NULL){
		
		printk(KERN_ERR "Process Scheduler ERROR:Workqueue \n");
		return -ENOMEM;
	}
	else {
		q_status = queue_delayed_work(scheduler_wq, &scheduler_hdlr, time_quantum * HZ);
	}

	return 0;
}

static void __exit process_scheduler_module_cleanup(void)
{
	flag = 1;
	cancel_delayed_work(&scheduler_hdlr);
	flush_workqueue(scheduler_wq);
	destroy_workqueue(scheduler_wq);

	printk(KERN_INFO "Process Scheduler module unloaded.\n");
}
module_init(process_scheduler_module_init);
module_exit(process_scheduler_module_cleanup);

/*Инициализация time_quantum*/
module_param(time_quantum, int, 0);
