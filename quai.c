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

#define ALL_REG_PIDS	-100
#define	INVALID_PID		-1

enum process_state {
	
	eCreated		=	0, 
	eRunning		=	1, 
	eWaiting		=	2, 
	eBlocked		=	3, 
	eTerminated		=	4  
};


enum task_status_code {

	eTaskStatusExist 		= 	0,	
	eTaskStatusTerminated 	=  -1   
};

struct proc {
	int pid; 					
	enum process_state state;	
	struct list_head list;		
}top;

static struct semaphore mutex;

enum task_status_code task_status_change(int pid, enum process_state eState);
enum task_status_code is_task_exists(int pid);

int init_process_queue(void);
int release_process_queue(void);
int add_process_to_queue(int pid);
int remove_process_from_queue(int pid);
int print_process_queue(void);
int change_process_state_in_queue(int pid, int changeState);
int get_first_process_in_queue(void);
int remove_terminated_processes_from_queue(void);

int init_process_queue(void) {

	printk(KERN_INFO "Initializing the Process Queue...\n");
	INIT_LIST_HEAD(&top.list);
	return 0;
}

int release_process_queue(void) {
		 	
	struct proc *tmp, *node;
	printk(KERN_INFO "Releasing Process Queue...\n");
	
	list_for_each_entry_safe(node, tmp, &(top.list), list) {
	
		list_del(&node->list);
		kfree(node);
	}

    return 0;
}

int add_process_to_queue(int pid) {
			
	struct proc *new_process = kmalloc(sizeof(struct proc), GFP_KERNEL);
	
	if(!new_process) {

		printk(KERN_ALERT "Process Queue module ERROR:kmalloc ");
		return -ENOMEM;
	}
	new_process->pid = pid;
	new_process->state = eWaiting;
    
	task_status_change(new_process->pid, new_process-> state);

	if(down_interruptible(&mutex)){
		printk(KERN_ALERT "Process Queue module ERROR: down_interruptible");
		return -ERESTARTSYS;
	}

	INIT_LIST_HEAD(&new_process->list);
	list_add_tail(&(new_process->list), &(top.list));
	
	up(&mutex);

	printk(KERN_INFO "Add Process with pid = %d to the  Process Queue...\n", pid);
    
	return 0;
}

int remove_process_from_queue(int pid) {
		 	
	struct proc *tmp, *node;
	
	if(down_interruptible(&mutex)){
		printk(KERN_ALERT "Process Queue module ERROR: down_interruptible");
		return -ERESTARTSYS;
	}
    
	list_for_each_entry_safe(node, tmp, &(top.list), list) {
	
		if(node->pid == pid) {
			printk(KERN_INFO "Remove Process with pid = %d from the  Process Queue...\n", pid);
            list_del(&node->list);
            kfree(node);
		}
	}
	
	up(&mutex);
	return 0;
}

int remove_terminated_processes_from_queue(void) {
		 	
	struct proc *tmp, *node;
    
	if(down_interruptible(&mutex)){
		printk(KERN_ALERT "Process Queue module ERROR: down_interruptible");
		return -ERESTARTSYS;
	}
    
	list_for_each_entry_safe(node, tmp, &(top.list), list) {
	
		if(node->state == eTerminated) {
			printk(KERN_INFO "Remove Process with pid = %d from the  Process Queue...\n", node->pid);
			list_del(&node->list);
			kfree(node);
		}
	}
	
	up(&mutex);
	return 0;
}

int change_process_state_in_queue(int pid, int changeState) {
		 	
	struct proc *tmp, *node;

	enum process_state ret_process_change_status;

	if(down_interruptible(&mutex)){
		printk(KERN_ALERT "Process Queue module ERROR: down_interruptible");
		return -ERESTARTSYS;
	}
    
	if(pid == ALL_REG_PIDS) {
		list_for_each_entry_safe(node, tmp, &(top.list), list) {
	
			printk(KERN_INFO "Update Process with pid = %d state in  Process Queue...\n", node->pid);
			node->state = changeState;
			if(task_status_change(node->pid, node->state)==eTaskStatusTerminated) {
				node->state = eTerminated;
			}
		}
	}
	else {
		list_for_each_entry_safe(node, tmp, &(top.list), list) {
		
			if(node->pid == pid) {
				
				printk(KERN_INFO "Update Process with pid = %d state in  Process Queue...\n", pid);
				node->state = changeState;
				if(task_status_change(node->pid, node->state)==eTaskStatusTerminated) {
					node->state = eTerminated;
					ret_process_change_status = eTerminated;
				}
			}
			else {
				if(is_task_exists(node->pid)==eTaskStatusTerminated) {
					node->state = eTerminated;
				}
			}
		}
	}
    
	up(&mutex);

	return ret_process_change_status;
}

int print_process_queue(void) {
			
	struct proc *tmp;
	printk(KERN_INFO "Process Queue: \n");
    
	if(down_interruptible(&mutex)){
		printk(KERN_ALERT "Process Queue module ERROR: down_interruptible");
		return -ERESTARTSYS;
	}	
	list_for_each_entry(tmp, &(top.list), list) {
	
		printk(KERN_INFO "Process ID: %d\n", tmp->pid);
	}
	
	up(&mutex);
	return 0;
}

int get_first_process_in_queue(void) {

	struct proc *tmp;
	int pid = INVALID_PID;
	
	if(down_interruptible(&mutex)){
		printk(KERN_ALERT "Process Queue module ERROR: down_interruptible");
		return -ERESTARTSYS;
	}	

	list_for_each_entry(tmp, &(top.list), list) {
		if((pid==INVALID_PID)&&(is_task_exists(tmp->pid)==eTaskStatusExist)) {
			pid = tmp->pid;
		}

	}
	
	up(&mutex);

	return pid;
}

enum task_status_code is_task_exists(int pid) {
	
	struct task_struct *current_pr;
	current_pr = pid_task(find_vpid(pid), PIDTYPE_PID);
	if(current_pr == NULL) {
		return eTaskStatusTerminated;
	}
    
	return eTaskStatusExist;
}

enum task_status_code task_status_change(int pid, enum process_state eState) {

	struct task_struct *current_pr;
	current_pr = pid_task(find_vpid(pid), PIDTYPE_PID);
	if(current_pr == NULL) {
		return eTaskStatusTerminated;
	}

	if(eState == eRunning) {
		kill_pid(task_pid(current_pr), SIGCONT, 1);
		printk(KERN_INFO "Task status change to Running\n");
	}
	else if(eState == eWaiting) {
		kill_pid(task_pid(current_pr), SIGSTOP, 1);
		printk(KERN_INFO "Task status change to Waiting\n");
	}
	else if(eState == eBlocked) {

		printk(KERN_INFO "Task status change to Blocked\n");
	}
	else if(eState == eTerminated) {

		printk(KERN_INFO "Task status change to Terminated\n");
	}
    
	return eTaskStatusExist;
}

static int __init process_queue_module_init(void)
{
	printk(KERN_INFO "Process Queue module loaded.\n");

	sema_init(&mutex,1); 		
	
	init_process_queue();

	return 0;
}

static void __exit process_queue_module_cleanup(void)
{
	printk(KERN_INFO "Process Queue module unloaded.\n");
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
