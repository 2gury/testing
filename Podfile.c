#include <linux/module.h>
#include <linux/init.h>
#include <linux/errno.h>
#include <linux/fs.h>
#include <linux/time.h>
#include <linux/proc_fs.h>
#include <linux/kernel.h>
#include <linux/list.h>
#include <linux/slab.h>
#include <linux/uaccess.h>

#define BUFSIZE  100

static int irq=20;
module_param(irq,int,0660);

MODULE_AUTHOR("Timoin Anton");
MODULE_DESCRIPTION("Process Setting Module");
MODULE_LICENSE("GPL");

#define PROC_CONFIG_FILE_NAME	"process_sched_add"
#define BASE_10 		10

enum process_state {
	
	eCreated		=	0, 
	eRunning		=	1, 
	eWaiting		=	2, 
	eBlocked		=	3,
	eTerminated		=	4 
};

enum execution {

	eExecFailed 	= 	-1, 
	eExecSuccess 	=	 0  
};

static struct proc_dir_entry *proc_sched_add_file_entry;

extern int add_process_to_queue(int pid);
extern int remove_process_from_queue(int pid);
extern int print_process_queue(void);
extern int get_first_process_in_queue(void);
extern int remove_terminated_processes_from_queue(void);
extern int change_process_state_in_queue(int pid, int changeState);

static ssize_t process_sched_add_module_read(struct file *file, char *buf, size_t count, loff_t *ppos)
{
	
	printk(KERN_INFO "Process Scheduler Add Module read.\n");
	printk(KERN_INFO "Next Executable PID in the list if RR Scheduling: %d\n", get_first_process_in_queue());
	return 0;
}

static ssize_t process_sched_add_module_write(struct file *file, const char *ubuf, size_t count, loff_t *ppos)
{
	int num,c,i, ret;
	char buf[BUFSIZE];
	if(*ppos > 0 || count > BUFSIZE)
		return -EFAULT;
	if(copy_from_user(buf, ubuf, count))
		return -EFAULT;
	num = sscanf(buf,"%d",&i);
	if(num != 1)
		return -EFAULT;
	irq = i; 
	c = strlen(buf);
	*ppos = c;

	ret = add_process_to_queue(i);
	if(ret != eExecSuccess) {
		printk(KERN_ALERT "Process Set ERROR:add_process_to_queue");
		return -ENOMEM;
	}

	return c;
}

static int process_sched_add_module_open(struct inode * inode, struct file * file)
{
	printk(KERN_INFO "Process Scheduler Add Module open.\n");
	return 0;
}

static int process_sched_add_module_release(struct inode * inode, struct file * file)
{
	printk(KERN_INFO "Process Scheduler Add Module released.\n");
	return 0;
}

static struct file_operations process_sched_add_module_fops = {
	.owner =	THIS_MODULE,
	.read =		process_sched_add_module_read,
	.write =	process_sched_add_module_write,
	.open =		process_sched_add_module_open,
	.release =	process_sched_add_module_release,
};

static int __init process_sched_add_module_init(void)
{
	printk(KERN_INFO "Process Set moduleloaded.\n");
	
	proc_sched_add_file_entry = proc_create(PROC_CONFIG_FILE_NAME,0777,NULL,&process_sched_add_module_fops);
	if(proc_sched_add_file_entry == NULL) {
		printk(KERN_ALERT "Error: Initialize /proc/%s\n",PROC_CONFIG_FILE_NAME);
		return -ENOMEM;
	}
	
	return 0;
}

static void __exit process_sched_add_module_cleanup(void)
{
	
	printk(KERN_INFO "Process Set module unloaded.\n");
	proc_remove(proc_sched_add_file_entry);
}

module_init(process_sched_add_module_init);
module_exit(process_sched_add_module_cleanup);
